#' Create a Collection
#' 
#' This is a constructor for the Collection class. It creates a Collection
#' object for use in a Microbiome Dataset. 
#' @param name The name of the collection
#' @param data A data.frame or a character vector representing a file path to a data.frame
#' @param recordIdColumn The name of the column in the data.frame that contains the record id
#' @param ancestorIdColumns A character vector of column names representing parent entities of the recordIdColumn
#' @export
#' @rdname Collection-methods
setGeneric("Collection", function(name, data, recordIdColumn, ancestorIdColumns) standardGeneric("Collection"))

#' @rdname Collection-methods
#' @aliases Collection,character,data.frame,character,character-method
setMethod("Collection", signature("character", "data.frame", "character", "character"), function(name, data, recordIdColumn, ancestorIdColumns) {
    data <- data.table::setDT(data)
    new("Collection", name = name, data = data, recordIdColumn = recordIdColumn, ancestorIdColumns = ancestorIdColumns)
})

#' @rdname Collection-methods
#' @aliases Collection,character,data.frame,missing,missing-method
setMethod("Collection", signature("character", "data.frame", "missing", "missing"), function(name, data, recordIdColumn, ancestorIdColumns) {
    warning("Id columns not specified, assuming first column is record id and other Id columns end in `_Id`")
    recordIdColumn <- findRecordIdColumn(names(data))
    ancestorIdColumns <- findAncestorIdColumns(names(data))
    data <- data.table::setDT(data)
    new("Collection", name = name, data = data, recordIdColumn = recordIdColumn, ancestorIdColumns = ancestorIdColumns)
})

#' @rdname Collection-methods
#' @aliases Collection,character,character,missing,missing-method
setMethod("Collection", signature("character", "character", "missing", "missing"), function(name, data, recordIdColumn, ancestorIdColumns) {
    data <- data.table::fread(data)
    warning("Id columns not specified, assuming first column is record id and other Id columns end in `_Id`")
    recordIdColumn <- findRecordIdColumn(names(data))
    ancestorIdColumns <- findAncestorIdColumns(names(data))
    new("Collection", name = name, data = data, recordIdColumn = recordIdColumn, ancestorIdColumns = ancestorIdColumns)
})

#' @rdname Collection-methods
#' @aliases Collection,character,character,character,character-method
setMethod("Collection", signature("character", "character", "character", "character"), function(name, data, recordIdColumn, ancestorIdColumns) {
    data <- data.table::fread(data)
    new("Collection", name =name, data = data, recordIdColumn = recordIdColumn, ancestorIdColumns = ancestorIdColumns)
})

#' @rdname Collection-methods
#' @aliases Collection,missing,missing,missing,missing-method
setMethod("Collection", signature("missing", "missing", "missing", "missing"), function(name, data, recordIdColumn, ancestorIdColumns) {
    new("Collection")
})


##### some helpers for building Collections objects from various data sources #####

findCollectionId <- function(dataColName) {
    # this is the case where the id columns follow no format and the data columns follow `Name [CollectionId_VariableId]` format (downloads)
    if (grepl("\\[", dataColName)) {
        varId <- strsplit(dataColName, "\\[")[[1]][2]
        collectionId <- regmatches(varId,regexpr("^([^_]*_[^_]*)",varId))
        return(collectionId)
    }

    # this presumably the case where the column headers follow the `entityId.variableId` format (the eda services format)
    if (grepl(".", dataColName, fixed = TRUE)) {
        varId <- strsplit(dataColName, ".", fixed = TRUE)[[1]][1]
        collectionId <- strsplit(varId, "_", fixed = TRUE)[[1]][1]
        return(collectionId)
    }

    stop((sprintf("Could not find collection id for column: %s. Unrecognized format.", dataColName)))
}

findCollectionIds <- function(dataColNames) {
    recordIdColumn <- findRecordIdColumn(dataColNames)
    ancestorIdColumns <- findAncestorIdColumns(dataColNames)
    variableColNames <- dataColNames[!dataColNames %in% c(recordIdColumn,ancestorIdColumns)]

    return(unique(unlist(sapply(variableColNames, findCollectionId))))
}

findRecordIdColumn <- function(dataColNames) {
    # for now assume were working w bulk download files, which means its the first column
    allIdColumns <- dataColNames[grepl("_Id", dataColNames, fixed=TRUE)]
    return(allIdColumns[1])
}

findAncestorIdColumns <- function(dataColNames) {
    # for now assume were working w bulk download files, which means they have '_Id'
    allIdColumns <- dataColNames[grepl("_Id", dataColNames, fixed=TRUE)]
    if (length(allIdColumns) == 1) {
        return(character(0))
    }

    return(allIdColumns[2:length(allIdColumns)])
}

clean_names <- function(names, makeUnique = FALSE) {
    # remove everything after the last opening square bracket to get rid of IRIs
    names <- gsub("\\[.*$", "", names)

    names <- gsub("%+", "_pct_", names)
    names <- gsub("\\$+", "_dollars_", names)
    names <- gsub("\\++", "_plus_", names)
    names <- gsub("-+", "_minus_", names)
    names <- gsub("\\*+", "_star_", names)
    names <- gsub("#+", "_cnt_", names)
    names <- gsub("&+", "_and_", names)
    names <- gsub("@+", "_at_", names)

    names <- gsub("[^a-zA-Z0-9_]+", "_", names)
    names <- gsub("([A-Z][a-z])", "_\\1", names)
    names <- tolower(trimws(names))

    names <- gsub("(^_+|_+$)", "", names)

    names <- gsub("_+", "_", names)

    if (makeUnique) names <- make.unique(names, sep = "_")

    return(names)
}

getDataFromSource <- function(dataSource, keepIdsAndNumbersOnly = c(TRUE, FALSE), cleanColumnNames = c(FALSE, TRUE)) {
    keepIdsAndNumbersOnly <- veupathUtils::matchArg(keepIdsAndNumbersOnly)
    cleanColumnNames <- veupathUtils::matchArg(cleanColumnNames)

    if (inherits(dataSource, "character")) {
        veupathUtils::logWithTime(sprintf("Attempting to read file: %s", dataSource), verbose = TRUE)
        dt <- data.table::fread(dataSource)
    } else if (inherits(dataSource, "data.frame")) {
        dt <- data.table::as.data.table(dataSource)        
    }

    dataColNames <- names(dt)
    recordIdColumn <- findRecordIdColumn(dataColNames)
    ancestorIdColumns <- findAncestorIdColumns(dataColNames)

    # theres probably a better way to do this..
    # the idea is that some assay entities have things like presence/ absence of a bug. 
    # they show up as character columns w values like 'Y' and 'N', but were not supporting these data for now.
    if (keepIdsAndNumbersOnly) {
        numericColumns <- dataColNames[which(sapply(dt,is.numeric))]
        dt <- dt[, unique(c(recordIdColumn, ancestorIdColumns, numericColumns)), with=FALSE]
    }

    if (cleanColumnNames) {
        names(dt)[!names(dt) %in% c(recordIdColumn, ancestorIdColumns)] <- clean_names(names(dt)[!names(dt) %in% c(recordIdColumn, ancestorIdColumns)])
    }

    return(dt)
}

findCollectionDataColumns <- function(dataColNames, collectionId) {
    return(dataColNames[grepl(collectionId, dataColNames, fixed=TRUE)])
}

getCollectionName <- function(collectionId, dataSourceName, ontology = NULL) {
    if (grepl("16S", dataSourceName, fixed=TRUE)) {
        dataSourceName <- "16S"
    }

    if (grepl("Metagenomic", dataSourceName, fixed=TRUE)) {
        dataSourceName <- "WGS"
    }

    if (grepl("Mass_spectrometry", dataSourceName, fixed=TRUE)) {
        dataSourceName <- "Metabolomics"
    }

    if (!is.null(ontology)) {
        # this assumes were getting one of our own ontology download files
        # w columns like `iri` and `label`
        collectionLabel <- unique(ontology$label[ontology$iri == collectionId])

        if (length(collectionLabel) == 1) {
            return(paste(dataSourceName, collectionLabel))
        } else {
            warning("Could not find collection label for collection id: ", collectionId)
        }
    }

    return(paste(dataSourceName, collectionId))
}

# so i considered that these should be constructors or something maybe.. 
# but i mean them to only ever be used internally so im not going to worry about it until something forces me to
collectionBuilder <- function(collectionId, dt, ontology = NULL) {
    dataColNames <- names(dt)
    collectionColumns <- findCollectionDataColumns(dataColNames, collectionId)
    recordIdColumn <- findRecordIdColumn(dataColNames)
    ancestorIdColumns <- findAncestorIdColumns(dataColNames)

    collection <- new("Collection", 
        name=getCollectionName(collectionId, recordIdColumn, ontology),
        data=dt[, c(recordIdColumn, ancestorIdColumns, collectionColumns), with = FALSE],
        recordIdColumn=recordIdColumn,
        ancestorIdColumns=ancestorIdColumns
    )

    return(collection)
}

getCollectionsList <- function(dataSource, ontology = NULL) {
    if (inherits(dataSource, "Collection")) return(dataSource)

    dt <- getDataFromSource(dataSource)
    dataColNames <- names(dt)
    collectionIds <- findCollectionIds(dataColNames)

    collections <- lapply(collectionIds, collectionBuilder, dt, ontology)

    return(collections)
}

collectionsBuilder <- function(dataSources, ontology = NULL) {
    collectionsLists <- lapply(dataSources, getCollectionsList, ontology)
    collections <- unlist(collectionsLists, recursive = FALSE)

    collections <- new("Collections", collections)

    return(collections)
}

#' Create Collections
#' 
#' This is a constructor for the Collections class. It creates a Collections
#' object for use in a Microbiome Dataset. A Collections object is a list of
#' Collection objects.
#' @param collections A list of Collection objects, a data.frame containing multiple
#'  collections, or a character vector containing a file path to a data.frame
#' @param ontology A data.frame containing the ontology for the dataset
#' @return A Collections object
#' @export
#' @rdname Collections-methods
setGeneric("Collections", function(collections, ontology) standardGeneric("Collections"))

#' @rdname Collections-methods
#' @aliases Collections,missing,missing-method
setMethod("Collections", signature("missing", "missing"), function(collections, ontology) {
    new("Collections")
})

#' @rdname Collections-methods
#' @aliases Collections,list,missing-method
setMethod("Collections", signature("list", "missing"), function(collections, ontology) {
    if (length(collections) == 0) {
        new("Collections")
    } else {
        collectionsBuilder(collections)
    }
})

#' @rdname Collections-methods
#' @aliases Collections,list,data.frame-method
setMethod("Collections", signature("list", "data.frame"), function(collections, ontology) {
    if (length(collections) == 0) {
        new("Collections")
    } else {
        collectionsBuilder(collections, ontology)
    }
})

#' @rdname Collections-methods
#' @aliases Collections,data.frame,missing-method
setMethod("Collections", signature("data.frame", "missing"), function(collections, ontology) {
    if (nrow(collections) == 0) {
        new("Collections")
    } else {
        collectionsBuilder(list(collections))
    }  
})

#' @rdname Collections-methods
#' @aliases Collections,data.frame,data.frame-method
setMethod("Collections", signature("data.frame", "data.frame"), function(collections, ontology) {
    if (nrow(collections) == 0) {
        new("Collections")
    } else {
        collectionsBuilder(list(collections), ontology)
    }  
})

# For these two cases, the MbioDataset constructor should have already warned the user
# that ontology is not needed.
#' @rdname Collections-methods
#' @aliases Collections,Collection,missing-method
setMethod("Collections", signature("Collection", "missing"), function(collections, ontology) {
    new("Collections", list(collections))
})

#' @rdname Collections-methods
#' @aliases Collections,character,missing-method
setMethod("Collections", signature("character", "missing"), function(collections, ontology) {
    if (!length(collections) || collections == '') {
        new("Collections")
    } else {
        collectionsBuilder(list(collections))
    }
})

sampleMetadataBuilder <- function(dataSource) {
    dt <- getDataFromSource(dataSource, keepIdsAndNumbersOnly=FALSE, cleanColumnNames=TRUE)
    dataColNames <- names(dt)
    recordIdColumn <- findRecordIdColumn(dataColNames)
    ancestorIdColumns <- findAncestorIdColumns(dataColNames)

    sampleMetadata <- new("SampleMetadata",
        data=dt,
        recordIdColumn = recordIdColumn,
        ancestorIdColumns = ancestorIdColumns
    )

    return(sampleMetadata)
}

mergeSampleMetadata <- function(x, y) {
    uniqueAncestorIdColumns <- unique(c(x@ancestorIdColumns, y@ancestorIdColumns))
    recordIdColumn <- ifelse(x@recordIdColumn %in% uniqueAncestorIdColumns, y@recordIdColumn, x@recordIdColumn)
    data <- merge(x@data, y@data, by = uniqueAncestorIdColumns, all = TRUE)

    sampleMetadata <- new("SampleMetadata",
        data = data,
        recordIdColumn = recordIdColumn,
        ancestorIdColumns = uniqueAncestorIdColumns
    )

    return(sampleMetadata)
}

#' @importFrom purrr reduce
sampleMetadataFromDataSources <- function(dataSources) {
    sampleMetataList <- lapply(dataSources, sampleMetadataBuilder)
    sampleMetadata <- purrr::reduce(sampleMetataList, mergeSampleMetadata)

    return(sampleMetadata)
}


##### I have never hated S4 so much... even ai assisted this was excruciating #####

#' Create a Microbiome Dataset
#' 
#' This is a constructor for the MbioDataset class. It creates a MbioDataset containing
#' a list of Collections and a SampleMetadata object.
#' @param collections A list of Collection objects, a data.frame containing multiple collections,
#'  or a character vector containing one or more file path(s)
#' @param metadata A SampleMetadata object, a data.frame containing sample metadata,
#' or a list of file path(s)
#' @param ontology An data.frame containing the ontology of the dataset, or a character vector
#'  containing a file path to a data.frame
#' @export
#' @rdname MbioDataset-methods
setGeneric("MbioDataset", function(collections, metadata, ontology) standardGeneric("MbioDataset"))

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,missing,missing,missing-method
setMethod("MbioDataset", signature("missing", "missing", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset")
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,SampleMetadata,missing-method
setMethod("MbioDataset", signature("Collections", "SampleMetadata", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = collections, metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,SampleMetadata,data.frame-method
setMethod("MbioDataset", signature("Collections", "SampleMetadata", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,SampleMetadata,character-method
setMethod("MbioDataset", signature("Collections", "SampleMetadata", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,data.frame,missing-method
setMethod("MbioDataset", signature("Collections", "data.frame", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = collections, metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,data.frame,data.frame-method
setMethod("MbioDataset", signature("Collections", "data.frame", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,data.frame,character-method
setMethod("MbioDataset", signature("Collections", "data.frame", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,list,missing-method
setMethod("MbioDataset", signature("Collections", "list", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = collections, metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,list,data.frame-method
setMethod("MbioDataset", signature("Collections", "list", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,list,character-method
setMethod("MbioDataset", signature("Collections", "list", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,missing,missing-method
setMethod("MbioDataset", signature("Collections", "missing", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = collections)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,missing,data.frame-method
setMethod("MbioDataset", signature("Collections", "missing", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,missing,character-method
setMethod("MbioDataset", signature("Collections", "missing", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,character,missing-method
setMethod("MbioDataset", signature("Collections", "character", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = collections, metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,character,data.frame-method
setMethod("MbioDataset", signature("Collections", "character", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collections,character,character-method
setMethod("MbioDataset", signature("Collections", "character", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collections object is provided.")
    new("MbioDataset", collections = collections, metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,SampleMetadata,missing-method
setMethod("MbioDataset", signature("Collection", "SampleMetadata", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,SampleMetadata,data.frame-method
setMethod("MbioDataset", signature("Collection", "SampleMetadata", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,SampleMetadata,character-method
setMethod("MbioDataset", signature("Collection", "SampleMetadata", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,data.frame,missing-method
setMethod("MbioDataset", signature("Collection", "data.frame", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,data.frame,data.frame-method
setMethod("MbioDataset", signature("Collection", "data.frame", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,data.frame,character-method
setMethod("MbioDataset", signature("Collection", "data.frame", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,list,missing-method
setMethod("MbioDataset", signature("Collection", "list", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,list,data.frame-method
setMethod("MbioDataset", signature("Collection", "list", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,list,character-method
setMethod("MbioDataset", signature("Collection", "list", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,missing,missing-method
setMethod("MbioDataset", signature("Collection", "missing", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,missing,data.frame-method
setMethod("MbioDataset", signature("Collection", "missing", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,missing,character-method
setMethod("MbioDataset", signature("Collection", "missing", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,character,missing-method
setMethod("MbioDataset", signature("Collection", "character", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,character,data.frame-method
setMethod("MbioDataset", signature("Collection", "character", "data.frame"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,Collection,character,character-method
setMethod("MbioDataset", signature("Collection", "character", "character"), function(collections, metadata, ontology) {
    warning("Ontology specified but not used when a Collection object is provided.")
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,SampleMetadata,missing-method
setMethod("MbioDataset", signature("list", "SampleMetadata", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,SampleMetadata,data.frame-method
setMethod("MbioDataset", signature("list", "SampleMetadata", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,SampleMetadata,character-method
setMethod("MbioDataset", signature("list", "SampleMetadata", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,data.frame,missing-method
setMethod("MbioDataset", signature("list", "data.frame", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,data.frame,data.frame-method
setMethod("MbioDataset", signature("list", "data.frame", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,data.frame,character-method
setMethod("MbioDataset", signature("list", "data.frame", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,missing,missing-method
setMethod("MbioDataset", signature("list", "missing", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,missing,data.frame-method
setMethod("MbioDataset", signature("list", "missing", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,missing,character-method
setMethod("MbioDataset", signature("list", "missing", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,list,missing-method
setMethod("MbioDataset", signature("list", "list", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,list,data.frame-method
setMethod("MbioDataset", signature("list", "list", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,list,character-method
setMethod("MbioDataset", signature("list", "list", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,character,missing-method
setMethod("MbioDataset", signature("list", "character", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,character,data.frame-method
setMethod("MbioDataset", signature("list", "character", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,list,character,character-method
setMethod("MbioDataset", signature("list", "character", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,SampleMetadata,missing-method
setMethod("MbioDataset", signature("data.frame", "SampleMetadata", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,SampleMetadata,data.frame-method
setMethod("MbioDataset", signature("data.frame", "SampleMetadata", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,SampleMetadata,character-method
setMethod("MbioDataset", signature("data.frame", "SampleMetadata", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,list,missing-method
setMethod("MbioDataset", signature("data.frame", "list", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,list,data.frame-method
setMethod("MbioDataset", signature("data.frame", "list", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,list,character-method
setMethod("MbioDataset", signature("data.frame", "list", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,missing,missing-method
setMethod("MbioDataset", signature("data.frame", "missing", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,missing,data.frame-method
setMethod("MbioDataset", signature("data.frame", "missing", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,missing,character-method
setMethod("MbioDataset", signature("data.frame", "missing", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,data.frame,missing-method
setMethod("MbioDataset", signature("data.frame", "data.frame", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,data.frame,data.frame-method
setMethod("MbioDataset", signature("data.frame", "data.frame", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,data.frame,character-method
setMethod("MbioDataset", signature("data.frame", "data.frame", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,character,missing-method
setMethod("MbioDataset", signature("data.frame", "character", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,character,data.frame-method
setMethod("MbioDataset", signature("data.frame", "character", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,data.frame,character,character-method
setMethod("MbioDataset", signature("data.frame", "character", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,character,missing-method
setMethod("MbioDataset", signature("character", "character", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,character,data.frame-method
setMethod("MbioDataset", signature("character", "character", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,character,character-method
setMethod("MbioDataset", signature("character", "character", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,list,missing-method
setMethod("MbioDataset", signature("character", "list", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,list,data.frame-method
setMethod("MbioDataset", signature("character", "list", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,list,character-method
setMethod("MbioDataset", signature("character", "list", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataFromDataSources(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,missing,missing-method
setMethod("MbioDataset", signature("character", "missing", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,missing,data.frame-method
setMethod("MbioDataset", signature("character", "missing", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,missing,character-method
setMethod("MbioDataset", signature("character", "missing", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,data.frame,missing-method
setMethod("MbioDataset", signature("character", "data.frame", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,data.frame,data.frame-method
setMethod("MbioDataset", signature("character", "data.frame", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,data.frame,character-method
setMethod("MbioDataset", signature("character", "data.frame", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = sampleMetadataBuilder(metadata))
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,SampleMetadata,missing-method
setMethod("MbioDataset", signature("character", "SampleMetadata", "missing"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,SampleMetadata,data.frame-method
setMethod("MbioDataset", signature("character", "SampleMetadata", "data.frame"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, ontology), metadata = metadata)
})

#' @rdname MbioDataset-methods
#' @aliases MbioDataset,character,SampleMetadata,character-method
setMethod("MbioDataset", signature("character", "SampleMetadata", "character"), function(collections, metadata, ontology) {
    new("MbioDataset", collections = Collections(collections, data.table::fread(ontology)), metadata = metadata)
})