check_collection <- function(object) {
    return(TRUE)
}

setClass("Collection", 
    slots = c(
        name = "character",
        data = "data.frame",
        recordIdColumn = "character"
    ),
    validity = check_collection
)


check_collections <- function(object) {
    return(TRUE)
}

#' @importFrom S4Vectors SimpleList
setClass("Collections", 
    contains = "SimpleList",
    prototype = prototype(
        elementType = "Collection"
    ),
    validity = check_collections
)

check_mbio_dataset <- function(object) {
    return(TRUE)
}

#' @importFrom microbiomeComputations SampleMetadata
setClass("mbioDataset", 
    slots = c(
        collections = "Collections",
        metadata = "SampleMetadata"
    ),
    validity = check_mbio_dataset
)