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
    new("Collection", name, data, recordIdColumn)
})

#' @export
setMethod("Collection", signature("character", "missing", "missing"), function(name, data, recordIdColumn) {
    new("Collection", name)
})

#' @export
setMethod("Collection", signature("character", "data.frame", "missing"), function(name, data, recordIdColumn) {
    # TODO find recordIdColumn, maybe an arg to say if the first column is the record id
    new("Collection", name, data)
})

#' @export
setMethod("Collection", signature("character", "character", "missing"), function(name, data, recordIdColumn) {
    # TODO read from file
    # TODO find recordIdColumn, maybe an arg to say if the first column is the record id
    new("Collection", name, data)
})


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
    # TODO make Collections from a list of files
    new("Collections", collections)
})

#' @export
setMethod("Collections", signature("data.frame"), function(collections) {
    # TODO make Collections from a data frame
    new("Collections", collections)
})

#' @export
setMethod("Collections", signature("Collection"), function(collections) {
    new("Collections", list(collections))
})

#' @export
setMethod("Collections", signature("character"), function(collections) {
    # TODO make Collections from a file
    new("Collections", list(Collection(collections)))
})


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
    new("MbioDataset", collections = collections, metadata = SampleMetadata(metadata))
})

#' @export
setMethod("MbioDataset", signature("Collections", "missing"), function(collections, metadata) {
    new("MbioDataset", collections = collections)
})

#' @export
setMethod("MbioDataset", signature("Collection", "data.frame"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections), metadata = SampleMetadata(metadata))
})

#' @export
setMethod("MbioDataset", signature("Collection", "missing"), function(collections, metadata) {
    new("MbioDataset", collections = Collections(collections))
})

#' @export
setMethod("MbioDataset", signature("list", "data.frame"), function(collections, metadata) {
    # TODO make Collections from a list of files containing data
    new("MbioDataset", collections = Collections(collections), metadata = SampleMetadata(metadata))
})

#' @export
setMethod("MbioDataset", signature("list", "missing"), function(collections, metadata) {
    # TODO make Collections from a list of files containing data
    new("MbioDataset", collections = Collections(collections))
})

#' @export
setMethod("MbioDataset", signature("list", "list"), function(collections, metadata) {
    # TODO make Collections and SampleMetadata from a list of files containing data
    new("MbioDataset", collections = Collections(collections), metadata = SampleMetadata(metadata))
})

#' @export
setMethod("MbioDataset", signature("data.frame", "missing"), function(collections, metadata) {
    # TODO parse data frame into Collections
    new("MbioDataset", collections = Collections(collections))
})

#' @export
setMethod("MbioDataset", signature("data.frame", "data.frame"), function(collections, metadata) {
    # TODO parse data frame into Collections
    new("MbioDataset", collections = Collections(collections), metadata = SampleMetadata(metadata))
})