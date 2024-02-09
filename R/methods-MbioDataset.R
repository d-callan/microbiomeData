setGeneric("name", function(x) standardGeneric("name"))
setMethod("name", "Collection", function(x) {
    return(x@name)
})
setGeneric("name<-", function(x, value) standardGeneric("name<-"))
setMethod("name<-", "Collection", function(x, value) {
    x@name <- value
    return(x)
})

setGeneric("names", function(x) standardGeneric("names"))
setMethod("names", "Collections", function(x) {
    return(sapply(x, name))
})

setGeneric("getCollectionNames", function(object) standardGeneric("getCollectionNames"))
setMethod("getCollectionNames", "MbioDataset", function(object) {
    return(names(object@collections))
})

setGeneric("updateCollectionName", function(object, oldName, newName) standardGeneric("updateCollectionName"))
setMethod("updateCollectionName", "MbioDataset", function(object, oldName, newName) {
    object@collections[[oldName]]@name <- newName
    return(object)
})

#' @importFrom microbiomeComputations AbundanceData
setGeneric("getCollection", function(object, collectionName) standardGeneric("getCollection"))
setMethod("getCollection", "MbioDataset", function(object, collectionName = character(0)) {
    if (length(collectionName) == 0) {
        stop("Must specify a collection name")
    }
    
    # TODO check if collection exists, turn into an AbundanceData object
    
})

#' @importFrom microbiomeComputations ComputeResult
setGeneric("getComputeResult", function(object) standardGeneric("getComputeResult"))

setMethod("getComputeResult", "ComputeResult", function(object) {
    return(object@data)  
})

#' @importFrom microbiomeComputations CorrelationComputeResult

setMethod("getComputeResult", "CorrelationComputeResult", function(object) {
    return(object@statistics)  
})