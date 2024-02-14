#some basic accessors
setGeneric("name", function(x) standardGeneric("name"))
setMethod("name", "Collection", function(x) return(x@name))
setGeneric("name<-", function(x, value) standardGeneric("name<-"))
setMethod("name<-", "Collection", function(x, value) {x@name <- value; return(x)})
setMethod(getGeneric("names"), "Collections", function(x) return(sapply(x, name)))

#' Get Microbiome Dataset Collection Names
#' 
#' Get the names of the collections in the Microbiome Dataset.
#' @param object A Microbiome Dataset
#' @return a character vector of collection names
#' @export
setGeneric("getCollectionNames", function(object) standardGeneric("getCollectionNames"))
setMethod("getCollectionNames", "MbioDataset", function(object) return(names(object@collections)))

#' Update Microbiome Dataset Collection Name
#' 
#' Update the name of a collection in the Microbiome Dataset.
#' @param object A Microbiome Dataset
#' @param oldName The name of the collection to update
#' @param newName The new name of the collection
#' @return A Microbiome Dataset with the updated collection name
#' @export
setGeneric("updateCollectionName", function(object, oldName, newName) standardGeneric("updateCollectionName"))
setMethod("updateCollectionName", "MbioDataset", function(object, oldName, newName) {
    object@collections[oldName][[1]]@name <- newName
    return(object)
})

#' Get Microbiome Dataset Collection
#' 
#' Get a collection from the Microbiome Dataset. The collection will be returned
#' as an AbundanceData object.
#' @param object A Microbiome Dataset
#' @param collectionName The name of the collection to return
#' @return An AbundanceData object representing the collection and any associated study metadata
#' @importFrom microbiomeComputations AbundanceData
#' @export
setGeneric("getCollection", function(object, collectionName) standardGeneric("getCollection"))
setMethod("getCollection", "MbioDataset", function(object, collectionName = character(0)) {
    if (length(collectionName) == 0) {
        stop("Must specify a collection name")
    }
    
    if (!collectionName %in% getCollectionNames(object)) {
        stop(sprintf("Collection '%s' does not exist", collectionName))
    }

    collection <- object@collections[collectionName][[1]]
    collectionIdColumns <- c(collection@recordIdColumn, collection@ancestorIdColumns)

    if (!!length(object@metadata@data)) {
        # need to be sure sample metadata contains only the relevant rows, actually having assay data
        # also need to make sure it has the assay record id column
        sampleMetadataDT <- data.table::setDT(merge(
            object@metadata@data, 
            collection@data[, collectionIdColumns, with = FALSE], 
            by = c(object@metadata@ancestorIdColumns, object@metadata@recordIdColumn)
        ))

        # also need to make sure they are in the same order
        data.table::setorderv(sampleMetadataDT, cols=collection@recordIdColumn)
        data.table::setorderv(collection@data, cols=collection@recordIdColumn)

        sampleMetadata <- new("SampleMetadata",
            data = sampleMetadataDT,
            recordIdColumn = collection@recordIdColumn,
            ancestorIdColumns = collection@ancestorIdColumns
        )
    } else {
        sampleMetadata <- object@metadata
    }
    

    abundanceData <- microbiomeComputations::AbundanceData(
        data = collection@data, 
        sampleMetadata = sampleMetadata, 
        recordIdColumn = collection@recordIdColumn,
        ancestorIdColumns = collection@ancestorIdColumns
    )

    return(abundanceData)
})

#' Get Microbiome Dataset Compute Result
#' 
#' Get the compute result from a Microbiome Dataset in a particular format.
#' Some formats may not be supported for all compute results.
#' @param object A Microbiome Dataset
#' @param format The format of the compute result. Currently only "data.table" and "igraph" are supported.
#' @return The compute result in the specified format
#' @importFrom microbiomeComputations ComputeResult
#' @export
setGeneric("getComputeResult", function(object, format = c("data.table")) standardGeneric("getComputeResult"))

#' @export
setMethod("getComputeResult", "ComputeResult", function(object, format = c("data.table")) {
    format <- veupathUtils::matchArg(format)

    if (nrow(object@data) == 0) {
        return(getComputeResult(object@statistics, format))
    }

    return(data.table::setDT(object@data))  
})

#' @importFrom microbiomeComputations CorrelationResult
#' @export
setMethod("getComputeResult", "CorrelationResult", function(object, format = c("data.table", "igraph")) {
    format <- veupathUtils::matchArg(format)

    result <- data.table::setDT(object@statistics)

    if (format == "igraph") {
        result <- igraph::graph_from_data_frame(result)
    }

    return(result)  
})

#' @importFrom microbiomeComputations DifferentialAbundanceResult
#' @export
setMethod("getComputeResult", "DifferentialAbundanceResult", function(object, format = c("data.table")) {
    format <- veupathUtils::matchArg(format) 
    return(data.table::setDT(object@statistics))
})