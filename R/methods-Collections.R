#' Get A Collection Name
#' 
#' Get the name of the collection
#' @param x A Collection
#' @rdname getName
#' @export
setGeneric("name", function(x) standardGeneric("name"))

#' @rdname getName
#' @aliases name,Collection-method
setMethod("name", "Collection", function(x) return(x@name))

#' Set A Collection Name
#' 
#' Set the name of the collection
#' @param x A Collection
#' @rdname setName
#' @export
setGeneric("name<-", function(x, value) standardGeneric("name<-"))

#' @rdname setName
#' @aliases name<-,Collection,character-method
setMethod("name<-", "Collection", function(x, value) {x@name <- value; return(x)})

#' Get Names of Collections
#' 
#' Get the names of the collections in the Collections object
#' @param x A Collections object
#' @return A character vector of collection names
#' @export
setMethod(getGeneric("names"), "Collections", function(x) return(sapply(x, name)))

#' @rdname getMetadataVariableNames
#' @aliases getMetadataVariableNames,Collection-method
setMethod("getMetadataVariableNames", "Collection", function(object) return(names(object@sampleMetadata@data)))

#' @rdname getSampleMetadata
#' @aliases getSampleMetadata,Collection-method
#' @export
setMethod("getSampleMetadata", "Collection", function(object, asCopy = c(TRUE, FALSE), includeIds = c(TRUE, FALSE), metadataVariables = NULL) {
    asCopy <- veupathUtils::matchArg(asCopy)
    includeIds <- veupathUtils::matchArg(includeIds)
    
    if (!length(object@sampleMetadata@data)) return(NULL) 

    dt <- data.table::setDT(object@sampleMetadata@data)
    allIdColumns <- getSampleMetadataIdColumns(object)

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

#' @rdname getSampleMetadataIdColumns
#' @aliases getSampleMetadataIdColumns,Collection-method
setMethod("getSampleMetadataIdColumns", "Collection", function(object) getIdColumns(object@sampleMetadata))