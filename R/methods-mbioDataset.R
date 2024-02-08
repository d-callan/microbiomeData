#' @importFrom microbiomeComputations AbundanceData
setGeneric("getCollection", function(object, collectionName) standardGeneric("getCollection"))
setMethod("getCollection", "mbioDataset", function(object, collectionName = character(0)) {
    if (length(collectionName) == 0) {
        stop("Must specify a collection name")
    }
    
    # TODO check if collection exists, turn into an AbundanceData object
    
})