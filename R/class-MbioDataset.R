check_collection <- function(object) {
    return(TRUE)
}

#' Microbiome Data Collection
#' 
#' #' This class represents a collection of Microbiome Data. That could be
#' all of the abundance data for all samples in a dataset at a particular taxonomic rank,
#' or all pathway abundance data for all samples in a dataset, or something else. The
#' primary requirement for a collection is that the values of all variables in the
#' collection can be expressed on the same theoretical range.
#' @name Collection-class
#' @rdname Collection-class
#' @export
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

#' Microbiome Data Collections
#' 
#' This is a list of Microbiome Data Collections.
#' @name Collections-class
#' @rdname Collections-class
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

#' MicrobiomeDB Dataset
#' 
#' This class represents a MicrobiomeDB dataset.
#' @name MbioDataset-class
#' @rdname MbioDataset-class
#' @importFrom microbiomeComputations SampleMetadata
setClass("MbioDataset", 
    slots = c(
        collections = "Collections",
        metadata = "SampleMetadata"
    ),
    validity = check_mbio_dataset
)