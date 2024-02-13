# TODO need to accept an ontologyMapping file as well, and use it to update names of collections and variables to human readable names.
# TODO consider that the Collection constructors should take a single object, and work like collectionBuilder. then remove collectionBuilder.
# TODO consider ways to validate input files as our own download files.

#' Create a Collection
#' 
#' This is a constructor for the Collection class. It creates a Collection
#' object for use in a Microbiome Dataset. 
#' @param name The name of the collection
#' @param data A data.frame or a character vector representing a file path to a data.frame
#' @param recordIdColumn The name of the column in the data.frame that contains the record id
#' @export
setGeneric("Collection", function(name, data, recordIdColumn, ancestorIdColumns) standardGeneric("Collection"))

#' @export
setMethod("Collection", signature("character", "data.frame", "character", "character"), function(name, data, recordIdColumn, ancestorIdColumns) {
    data <- data.table::setDT(data)
    new("Collection", name = name, data = data, recordIdColumn = recordIdColumn, ancestorIdColumns = ancestorIdColumns)
})

#' @export
setMethod("Collection", signature("character", "data.frame", "missing", "missing"), function(name, data, recordIdColumn, ancestorIdColumns) {
    warning("Id columns not specified, assuming first column is record id and other Id columns end in `_Id`")
    recordIdColumn <- findRecordIdColumn(names(data))
    ancestorIdColumns <- findAncestorIdColumns(names(data))
    data <- data.table::setDT(data)
    new("Collection", name = name, data = data, recordIdColumn = recordIdColumn, ancestorIdColumns = ancestorIdColumns)
})

#' @export
setMethod("Collection", signature("character", "character", "missing"), function(name, data, recordIdColumn, ancestorIdColumns) {
    data <- data.table::fread(data)
    warning("Id columns not specified, assuming first column is record id and other Id columns end in `_Id`")
    recordIdColumn <- findRecordIdColumn(names(data))
    ancestorIdColumns <- findAncestorIdColumns(names(data))
    new("Collection", name = name, data = data, recordIdColumn = recordIdColumn, ancestorIdColumns = ancestorIdColumns)
})

#' @export 
setMethod("Collection", signature("character", "character", "character", "character"), function(name, data, recordIdColumn, ancestorIdColumns) {
    data <- data.table::fread(data)
    new("Collection", name =name, data = data, recordIdColumn = recordIdColumn, ancestorIdColumns = ancestorIdColumns)
})

#' @export
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

# TODO add support for eda services format to these helpers
findRecordIdColumn <- function(dataColNames) {
    # for now assume were working w bulk download files, which means its the first column
    allIdColumns <- dataColNames[grepl("_Id", dataColNames, fixed=TRUE)]
    return(allIdColumns[1])
}

findAncestorIdColumns <- function(dataColNames) {
    # for now assume were working w bulk download files, which means they have '_Id'
    allIdColumns <- dataColNames[grepl("_Id", dataColNames, fixed=TRUE)]
    return(allIdColumns[2:length(allIdColumns)])
}

getDataFromSource <- function(dataSource, keepIdsAndNumbersOnly = c(TRUE, FALSE)) {
    keepIdsAndNumbersOnly <- veupathUtils::matchArg(keepIdsAndNumbersOnly)

    if (inherits(dataSource, "character")) {
        veupathUtils::logWithTime(sprintf("Attempting to read file: %s", dataSource), verbose = TRUE)
        dt <- data.table::fread(dataSource)
    } else if (inherits(dataSource, "data.frame")) {
        dt <- data.table::as.data.table(dataSource)        
    }

    # theres probably a better way to do this..
    # the idea is that some assay entities have things like presence/ absence of a bug. 
    # they show up as character columns w values like 'Y' and 'N', but were not supporting these data for now.
    if (keepIdsAndNumbersOnly) {
        dataColNames <- names(dt)
        recordIdColumn <- findRecordIdColumn(dataColNames)
        ancestorIdColumns <- findAncestorIdColumns(dataColNames)
        numericColumns <- dataColNames[which(sapply(dt,is.numeric))]
        dt <- dt[, c(recordIdColumn, ancestorIdColumns, numericColumns), with=FALSE]
    }

    return(dt)
}

findCollectionDataColumns <- function(dataColNames, collectionId) {
    return(dataColNames[grepl(collectionId, dataColNames, fixed=TRUE)])
}

# TODO figure how to turn these into human readable somethings
# maybe a manually curated named list here, or allow parsing of ontology file from downloads, or...
# TODO will have to add dataSourceName mappings manually unless i think of something better..
getCollectionName <- function(collectionId, dataSourceName) {
    if (grepl("16S", dataSourceName, fixed=TRUE)) {
        dataSourceName <- "16S"
    }

    if (grepl("Metagenomic", dataSourceName, fixed=TRUE)) {
        dataSourceName <- "WGS"
    }

    return(paste(dataSourceName, collectionId))
}

# so i considered that these should be constructors or something maybe.. 
# but i mean them to only ever be used internally so im not going to worry about it until something forces me to
collectionBuilder <- function(collectionId, dt) {
    dataColNames <- names(dt)
    collectionColumns <- findCollectionDataColumns(dataColNames, collectionId)
    recordIdColumn <- findRecordIdColumn(dataColNames)
    ancestorIdColumns <- findAncestorIdColumns(dataColNames)

    collection <- new("Collection", 
        name=getCollectionName(collectionId, recordIdColumn),
        data=dt[, c(recordIdColumn, ancestorIdColumns, collectionColumns), with = FALSE],
        recordIdColumn=recordIdColumn,
        ancestorIdColumns=ancestorIdColumns
    )

    return(collection)
}

getCollectionsList <- function(dataSource) {
    if (inherits(dataSource, "Collection")) return(dataSource)

    dt <- getDataFromSource(dataSource)
    dataColNames <- names(dt)
    collectionIds <- findCollectionIds(dataColNames)

    collections <- lapply(collectionIds, collectionBuilder, dt)

    return(collections)
}

collectionsBuilder <- function(dataSources) {
    collectionsLists <- lapply(dataSources, getCollectionsList)
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
#' @export
setGeneric("Collections", function(collections) standardGeneric("Collections"))

#' @export
setMethod("Collections", signature("missing"), function(collections) {
    new("Collections")
})

#' @export
setMethod("Collections", signature("list"), function(collections) {
    if (length(collections) == 0) {
        new("Collections")
    } else {
        # TODO this wont work if the list is already a list of Collection objects
        collectionsBuilder(collections)
    }
})

#' @export
setMethod("Collections", signature("data.frame"), function(collections) {
    if (nrow(collections) == 0) {
        new("Collections")
    } else {
        collectionsBuilder(list(collections))
    }  
})

#' @export
setMethod("Collections", signature("Collection"), function(collections) {
    new("Collections", list(collections))
})

#' @export
setMethod("Collections", signature("character"), function(collections) {
    if (!length(collections) || collections == '') {
        new("Collections")
    } else {
        collectionsBuilder(list(collections))
    }
})

sampleMetadataBuilder <- function(dataSource) {
    dt <- getDataFromSource(dataSource, keepIdsAndNumbersOnly=FALSE)
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

# TODO turn this into a proper S4 method of SampleMetadata and put it in a different package?
# this will not work for metadata across different branches of the tree. IDK if we have that case in mbio?
mergeSampleMetadata <- function(x, y) {
    uniqueAncestorIdColumns <- unique(x@ancestorIdColumns, y@ancestorIdColumns)
    recordIdColumn <- ifelse(x@recordIdColumn %in% uniqueAncestorIdColumns, y@recordIdColumn, x@recordIdColumn)
    data <- merge(x@data, y@data, by = uniqueAncestorIdColumns, all = TRUE)

    sampleMetadata <- new("SampleMetadata",
        data = data,
        recordIdColumn = recordIdColumn,
        ancestorIdColumns = uniqueAncestorIdColumns
    )

    return(sampleMetadata)
}

sampleMetadataFromDataSources <- function(dataSources) {
    sampleMetataList <- lapply(dataSources, sampleMetadataBuilder)
    sampleMetadata <- purrr::reduce(sampleMetataList, mergeSampleMetadata)

    return(sampleMetadata)
}

#' Create a Microbiome Dataset
#' 
#' This is a constructor for the MbioDataset class. It creates a MbioDataset containing
#' a list of Collections and a SampleMetadata object.
#' @param collections A list of Collection objects, a data.frame containing multiple collections,
#'  or a character vector containing one or more file path(s)
#' @param metadata A SampleMetadata object, a data.frame containing sample metadata,
#' or a list of file path(s)
#' @export
setGeneric("MbioDataset", function(collections, metadata) standardGeneric("MbioDataset"))

#' @export
setMethod("MbioDataset", signature("missing", "missing"), function(collections, metadata) {
    new("MbioDataset")
})

#' @export 
setMethod("MbioDataset", signature("Collections", "SampleMetadata"), function(collections, metadata) {
    new("MbioDataset", collections = collections, metadata = metadata)
})

#' @export
setMethod("MbioDataset", signature("Collections", "data.frame"), function(collections, metadata) {
    new("MbioDataset", collections = collections, metadata = sampleMetadataBuilder(metadata))
})

#' @export 
setMethod("MbioDataset", signature("Collections", "list"), function(collections, metadata) {
    new("MbioDataset", collections = collections, metadata = sampleMetadataFromDataSources(metadata))
})

#' @export
setMethod("MbioDataset", signature("Collections", "missing"), function(collections, metadata) {
    new("MbioDataset", collections = collections)
})

#' @export
setMethod("MbioDataset", signature("Collections", "character"), function(collections, metadata) {
    new("MbioDataset", collections = collections, metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @export 
setMethod("MbioDataset", signature("Collection", "SampleMetadata"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})

#' @export
setMethod("MbioDataset", signature("Collection", "data.frame"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @export 
setMethod("MbioDataset", signature("Collection", "list"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @export 
setMethod("MbioDataset", signature("Collection", "missing"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections))
})

#' @export
setMethod("MbioDataset", signature("Collection", "character"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @export 
setMethod("MbioDataset", signature("list", "SampleMetadata"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})

#' @export
setMethod("MbioDataset", signature("list", "data.frame"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @export
setMethod("MbioDataset", signature("list", "missing"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections))
})

#' @export
setMethod("MbioDataset", signature("list", "list"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @export
setMethod("MbioDataset", signature("list", "character"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @export 
setMethod("MbioDataset", signature("data.frame", "SampleMetadata"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})

#' @export
setMethod("MbioDataset", signature("data.frame", "list"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @export
setMethod("MbioDataset", signature("data.frame", "missing"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections))
})

#' @export
setMethod("MbioDataset", signature("data.frame", "data.frame"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' export
setMethod("MbioDataset", signature("data.frame", "character"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @export 
setMethod("MbioDataset", signature("character", "character"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(list(metadata)))
})

#' @export 
setMethod("MbioDataset", signature("character", "list"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataFromDataSources(metadata))
})

#' @export 
setMethod("MbioDataset", signature("character", "missing"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections))
})

#' @export 
setMethod("MbioDataset", signature("character", "data.frame"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})

#' @export
setMethod("MbioDataset", signature("character", "SampleMetadata"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = metadata)
})