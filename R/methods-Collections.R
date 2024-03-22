#' Manage Collection Names
#' 
#' Get or set the name of the collection
#' @param x A Collection
#' @rdname name
#' @export
setGeneric("name", function(x) standardGeneric("name"))

#' @rdname name
#' @aliases name,Collection-method
setMethod("name", "Collection", function(x) return(x@name))

#' @rdname name
#' @param value The new name of the collection
#' @export
setGeneric("name<-", function(x, value) standardGeneric("name<-"))

#' @rdname name
#' @aliases name<-,Collection,character-method
setMethod("name<-", "Collection", function(x, value) {x@name <- value; return(x)})

#' Get Names of Collections
#' 
#' Get the names of the collections in the Collections or MbioDataset object
#' @param object A Collections object, or MbioDataset
#' @return A character vector of collection names
#' @export
#' @rdname getCollectionNames
setGeneric("getCollectionNames", function(object) standardGeneric("getCollectionNames"))

#' @rdname getCollectionNames
#' @aliases getCollectionNames,Collections-method
setMethod("getCollectionNames", "Collections", function(object) return(sapply(object, name)))

metadataVarNamesGeneric <- getGeneric("getMetadataVariableNames", "veupathUtils")
#' Get Variable Names of Metadata
#' 
#' Get the names of the metadata variables in an object containing sample metadata.
#' @param object Any object with a slot containing sampleMetadata
#' @return a character vector of metadata variable names
#' @rdname getMetadataVariableNames
#' @aliases getMetadataVariableNames,Collection-method
setMethod(metadataVarNamesGeneric, "Collection", function(object) return(names(object@sampleMetadata@data)))

sampleMetadataGeneric <- getGeneric("getSampleMetadata", "veupathUtils")
#' Returns a data.table of sample metadata
#' 
#' @param object CollectionWithMetadata
#' @param asCopy boolean indicating whether to return the data as a copy or by reference
#' @param includeIds boolean indicating whether we should include recordIdColumn and ancestorIdColumns
#' @param metadataVariables The metadata variables to include in the sample metadata. If NULL, all metadata variables will be included.
#' @return data.table of sample metadata
#' @import veupathUtils
#' @import data.table
#' @rdname getSampleMetadata
#' @aliases getSampleMetadata,Collection-method
setMethod(sampleMetadataGeneric, "Collection", function(object, asCopy = c(TRUE, FALSE), includeIds = c(TRUE, FALSE), metadataVariables = NULL) {
    asCopy <- veupathUtils::matchArg(asCopy)
    includeIds <- veupathUtils::matchArg(includeIds)
    
    if (!length(object@sampleMetadata@data)) return(NULL) 

    dt <- data.table::setDT(object@sampleMetadata@data)
    allIdColumns <- veupathUtils::getSampleMetadataIdColumns(object)

    if (asCopy) {
        dt <- data.table::copy(dt)
    }

    if (includeIds && !is.null(metadataVariables)) {
        dt <- dt[, c(allIdColumns, metadataVariables), with = FALSE]
    } else if (!includeIds && !is.null(metadataVariables)) {
        dt <- dt[, metadataVariables, with = FALSE]
    } else if (!includeIds && is.null(metadataVariables)) {
        dt <- dt[, -..allIdColumns]
    }

    return(dt)
})

sampleMetadataIdColsGeneric <- getGeneric("getSampleMetadataIdColumns", "veupathUtils")
#' Get Sample Metadata Id Column Names
#' 
#' Get the names of the record and ancestor id columns in the sample metadata of an object.
#' @param object An object w sample metadata
#' @return a character vector of id column names
#' @importFrom veupathUtils getIdColumns
#' @rdname getSampleMetadataIdColumns
#' @aliases getSampleMetadataIdColumns,Collection-method
setMethod(sampleMetadataIdColsGeneric, "Collection", function(object) veupathUtils::getIdColumns(object@sampleMetadata))