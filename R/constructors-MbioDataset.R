#' Create a Collection
#' 
#' This is a constructor for the Collection class. It creates a Collection
#' object for use in a Microbiome Dataset. 
#' @param name The name of the collection
#' @param data A data.frame or a character vector representing a file path to a data.frame
#' @param recordIdColumn The name of the column in the data.frame that contains the record id
#' @export
setGeneric("Collection", function(name, data, recordIdColumn) standardGeneric("Collection"))

#' @export
setMethod("Collection", signature("character", "data.frame", "character"), function(name, data, recordIdColumn) {
    data <- data.table::setDT(data)
    new("Collection", name = name, data = data, recordIdColumn = recordIdColumn)
})

#' @export
setMethod("Collection", signature("character", "data.frame", "missing"), function(name, data, recordIdColumn) {
    # TODO find recordIdColumn, maybe an arg to say if the first column is the record id
    warning("recordIdColumn not specified, assuming first column is record id")
    recordIdColumn <- names(data)[1]
    data <- data.table::setDT(data)
    new("Collection", name = name, data = data, recordIdColumn = recordIdColumn)
})

#' @export
setMethod("Collection", signature("character", "character", "missing"), function(name, data, recordIdColumn) {
    data <- data.table::fread(data)
    # TODO find recordIdColumn, maybe an arg to say if the first column is the record id
    warning("recordIdColumn not specified, assuming first column is record id")
    recordIdColumn <- names(data)[1]
    new("Collection", name = name, data = data, recordIdColumn = recordIdColumn)
})

#' @export 
setMethod("Collection", signature("character", "character", "character"), function(name, data, recordIdColumn) {
    data <- data.table::fread(data)
    new("Collection", name =name, data = data, recordIdColumn = recordIdColumn)
})

#' @export
setMethod("Collection", signature("missing", "missing", "missing"), function(name, data, recordIdColumn) {
    new("Collection")
})


##### some helpers for building Collections objects from various data sources #####

findCollectionId <- function(dataColName) {
    # this is the case where the id columns follow no format and the data columns follow `Name [CollectionId_VariableId]` format (downloads)
    if (grepl("\\[", dataColName, fixed = TRUE)) {
        varId <- strsplit(dataColName, "\\[", fixed = TRUE)[[1]][1]
        collectionId <- strsplit(varId, "_", fixed = TRUE)[[1]][1]
        return(collectionId)
    }

    # this presumably the case where the column headers follow the `entityId.variableId`` format (the eda services format)
    if (grepl(".", dataColName, fixed = TRUE)) {
        varId <- strsplit(dataColName, ".", fixed = TRUE)[[1]][1]
        collectionId <- strsplit(varId, "_", fixed = TRUE)[[1]][1]
        return(collectionId)
    }

    stop("Could not find collection ids. Unrecognized format.")
}

findCollectionIds <- function(dataColNames) {
    return(unique(sapply(dataColNames, findCollectionId)))
}

# TODO add support for eda services format to these helpers
findRecordIdColumn <- function(dataColNames) {
    # for now assume were working w bulk download files, which means its the first column
    return(dataColNames[1])
}

findAncestorIdColumns <- function(dataColNames) {
    # for now assume were working w bulk download files, which means they have '_Id'
    allIdColumns <- dataColNames[grepl("_Id", dataColNames, fixed=TRUE)]
    return(allIdColumns[2:length(allIdColumns)])
}

getDataFromSource <- function(dataSource) {
    if (inherits(dataSource, "character")) {
        veupathUtils::logWithTime(sprintf("Attempting to read file: %s", dataSource))
        dt <- data.table::fread(dataSource)
    } else if (inherits(dataSource, "data.frame")) {
        dt <- data.table::as.data.table(dataSource)        
    }

    return(dt)
}

findCollectionDataColumns <- function(dataColNames, collectionId) {
    return(grepl(collectionId, dataColNames, fixed=TRUE))
}

# TODO figure how to turn these into human readable somethings
# maybe a manually curated named list here, or allow parsing of ontology file from downloads, or...
getCollectionName <- function(collectionId) {
    return(as.character(collectionId))
}

# so i considered that these should be constructors or something maybe.. 
# but i mean them to only ever be used internally so im not going to worry about it until something forces me to
collectionBuilder <- function(collectionId, dt) {
    dataColNames <- names(dt)
    collectionColumns <- findCollectionDataColumns(dataColNames, collectionId)
    recordIdColumn <- findRecordIdColumn(dataColNames)
    findAncestorIdColumns <- findAncestorIdColumns(dataColNames)

    collection <- new("Collection", 
        name=getCollectionName(collectionId),
        data=dt[, c(recordIdColumn, findAncestorIdColumns,collectionColumns), with = FALSE],
        recordIdColumn=recordIdColumn,
        findAncestorIdColumns=findAncestorIdColumns
    )

    return(collection)
}

getCollectionsList <- function(dataSource) {
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
    dt <- getDataFromSource(dataSource)
    dataColNames <- names(dt)
    recordIdColumn <- findRecordIdColumn(dataColNames)
    findAncestorIdColumns <- findAncestorIdColumns(dataColNames)

    sampleMetadata <- new("SampleMetadata",
        data=dt,
        recordIdColumn = recordIdColumn,
        findAncestorIdColumns = findAncestorIdColumns
    )

    return(sampleMetadata)
}

# TODO turn this into a proper S4 method of SampleMetadata and put it in a different package?
# this will not work for metadata across different branches of the tree. IDK if we have that case in mbio?
mergeSampleMetadata <- function(x, y) {
    uniqueAncestorIdColumns <- unique(x@findAncestorIdColumns, y@findAncestorIdColumns)
    recordIdColumn <- ifelse(x@recordIdColumn %in% uniqueAncestorIdColumns, y@recordIdColumn, x@recordIdColumn)
    data <- merge(x@data, y@data, by = uniqueAncestorIdColumns, all = TRUE)

    sampleMetadata <- new("SampleMetadata",
        data = data,
        recordIdColumn = recordIdColumn,
        findAncestorIdColumns = uniqueAncestorIdColumns
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
setMethod("MbioDataset", signature("Collections", "data.frame"), function(collections, metadata) {
    new("MbioDataset", collections = collections, metadata = sampleMetadataBuilder(metadata))
})

#' @export
setMethod("MbioDataset", signature("Collections", "missing"), function(collections, metadata) {
    new("MbioDataset", collections = collections)
})

#' @export
setMethod("MbioDataset", signature("Collection", "data.frame"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
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
setMethod("MbioDataset", signature("data.frame", "missing"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections))
})

#' @export
setMethod("MbioDataset", signature("data.frame", "data.frame"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = sampleMetadataBuilder(metadata))
})