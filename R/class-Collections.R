isNAorNonNegative <- function(x) {
    return(is.na(x) | x >= 0)
}

check_collection <- function(object) {
    errors <- character()
    allIdColumns <- c(object@recordIdColumn, object@ancestorIdColumns)

    # check that name is not empty
    if (object@name == "") {
        msg <- "name cannot be empty"
        errors <- c(errors, msg)
    }

    # check that recordIdColumn exists in data
    if (!object@recordIdColumn %in% names(object@data)) {
        msg <- sprintf("recordIdColumn '%s' does not exist in data", object@recordIdColumn)
        errors <- c(errors, msg)
    }

    # check that ancestorIdColumns exist in data
    if (!all(object@ancestorIdColumns %in% names(object@data))) {
        msg <- sprintf("ancestorIdColumns '%s' do not exist in data", paste(object@ancestorIdColumns, collapse=", "))
        errors <- c(errors, msg)
    }

    # check that all columns in data are numeric except id columns
    dataColNames <- names(object@data)[!names(object@data) %in% allIdColumns]
    if (!all(sapply(object@data[, ..dataColNames], is.numeric))) {
        msg <- sprintf("all columns in data except '%s' must be numeric", paste(allIdColumns, collapse=", "))
        errors <- c(errors, msg)
    }

    # check that all values are non-negative or NA
    if (any(!isNAorNonNegative(object@data[, dataColNames, with = FALSE]))) {
        msg <- sprintf("all values in data except '%s' must be non-negative", paste(allIdColumns, collapse=", "))
        errors <- c(errors, msg)
    }

    if (length(errors) == 0) {
        return(TRUE)
    } else {
        return(errors)
    }
}

#' Microbiome Data Collection
#' 
#' #' This class represents a collection of Microbiome Data. That could be
#' all of the abundance data for all samples in a dataset at a particular taxonomic rank,
#' or all pathway abundance data for all samples in a dataset, or something else. The
#' primary requirement for a collection is that the values of all variables in the
#' collection can be expressed on the same theoretical range.
#' @slot name The name of the collection
#' @slot data A data.frame of data with samples as rows and variables as columns
#' @slot recordIdColumn The name of the column in the data.frame that contains the record id
#' @slot ancestorIdColumns A character vector of column names representing parent entities of the recordIdColumn
#' @name Collection-class
#' @rdname Collection-class
#' @export
setClass("Collection", 
    slots = c(
        name = "character",
        data = "data.table",
        recordIdColumn = "character",
        ancestorIdColumns = "character"
    ),
    validity = check_collection
)


check_collections <- function(object) {
    errors <- character()

    # check that all names are unique
    if (length(unique(names(object))) != length(object)) {
        msg <- "collection names must be unique"
        errors <- c(errors, msg)
    }

    if (length(object) == 0) {
        return(TRUE)
    }

    # check that at least one ancestorIdColumn is shared between collections
    firstCollectionAncestorIds <- object[[1]]@ancestorIdColumns
    if (!all(sapply(object, function(x) any(x@ancestorIdColumns %in% firstCollectionAncestorIds)))) {
        msg <- "at least one ancestorIdColumn must be shared between collections"
        errors <- c(errors, msg)
    }

    if (length(errors) == 0) {
        return(TRUE)
    } else {
        return(errors)
    }
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