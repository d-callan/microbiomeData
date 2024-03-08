#some basic accessors
#' @export
setGeneric("name", function(x) standardGeneric("name"))
setMethod("name", "Collection", function(x) return(x@name))
#' @export
setGeneric("name<-", function(x, value) standardGeneric("name<-"))
setMethod("name<-", "Collection", function(x, value) {x@name <- value; return(x)})
setMethod(getGeneric("names"), "Collections", function(x) return(sapply(x, name)))

#' @export
setMethod("getMetadataVariableNames", "Collection", function(object) return(names(object@sampleMetadata@data)))

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

#' @export
setMethod("getSampleMetadataIdColumns", "Collection", function(object) getIdColumns(object@sampleMetadata))