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
setMethod("getCollectionNames", "MbioDataset", function(object) return(unname(names(object@collections))))

#' Get Microbiome Dataset Metadata Variable Names
#' 
#' Get the names of the metadata variables in the Microbiome Dataset.
#' @param object A Microbiome Dataset
#' @return a character vector of metadata variable names
#' @export
setGeneric("getMetadataVariableNames", function(object) standardGeneric("getMetadataVariableNames"))
setMethod("getMetadataVariableNames", "MbioDataset", function(object) return(names(object@metadata@data)))
setMethod("getMetadataVariableNames", "AbundanceData", function(object) return(names(object@sampleMetadata@data)))
setMethod("getMetadataVariableNames", "Collection", function(object) return(names(object@sampleMetadata@data)))

#' Get Microbiome Dataset Sample Metadata
#' 
#' Get the sample metadata from the Microbiome Dataset. If metadata variables are not specified, all sample metadata will be returned.
#' @param object A Microbiome Dataset
#' @param metadataVariables The metadata variables to include in the sample metadata. If NULL, all metadata variables will be included.
#' @return A data.table of sample metadata
#' @export
setGeneric("getSampleMetadata", function(object, metadataVariables = NULL) standardGeneric("getSampleMetadata"), signature = c("object"))
setMethod("getSampleMetadata", "MbioDataset", function(object, metadataVariables = NULL) {
    if (!length(object@metadata@data)) return(NULL)

    dt <- data.table::setDT(object@metadata@data)
    if (!is.null(metadataVariables)) {
        metadataIdColumns <- c(object@metadata@recordIdColumn, object@metadata@ancestorIdColumns)
        dt <- dt[, c(metadataIdColumns, metadataVariables), with = FALSE]
    }

    return(dt)
})
setMethod("getSampleMetadata", "AbundanceData", function(object, metadataVariables = NULL) {
    if (!length(object@sampleMetadata@data)) return(NULL)

    dt <- data.table::setDT(object@sampleMetadata@data)
    if (!is.null(metadataVariables)) {
        metadataIdColumns <- c(object@sampleMetadata@recordIdColumn, object@sampleMetadata@ancestorIdColumns)
        dt <- dt[, c(metadataIdColumns, metadataVariables), with = FALSE]
    }

    return(dt)
})
setMethod("getSampleMetadata", "Collection", function(object, metadataVariables = NULL) {
    if (!length(object@sampleMetadata@data)) return(NULL) 

    dt <- data.table::setDT(object@sampleMetadata@data)
    if (!is.null(metadataVariables)) {
        metadataIdColumns <- c(object@sampleMetadata@recordIdColumn, object@sampleMetadata@ancestorIdColumns)
        dt <- dt[, c(metadataIdColumns, metadataVariables), with = FALSE]
    }

    return(dt)
})

#' Get Microbiome Dataset Id Column Names
#' 
#' Get the names of the record and ancestor id columns in the Microbiome Dataset.
#' @param object A Microbiome Dataset, or other object w recordIdColumn and ancestorIdColumns slots
#' @return a character vector of id column names
#' @export
setGeneric("getIdColumnNames", function(object) standardGeneric("getIdColumnNames"))
setMethod("getIdColumnNames", "ANY", function(object) {
    if (all(c('recordIdColumn','ancestorIdColumns') %in% slotNames(object))) {
        return(c(object@recordIdColumn, object@ancestorIdColumns))
    } else {
        stop("Object does not have recordIdColumn and/or ancestorIdColumns slots. Received object of class ", class(object))
    }
})

#' Get Sample Metadata Id Column Names
#' 
#' Get the names of the record and ancestor id columns in the sample metadata of the Microbiome Dataset.
#' @param object A Microbiome Dataset, or other object w sample metadata
#' @return a character vector of id column names
#' @export
setGeneric("getSampleMetadataIdColumnNames", function(object) standardGeneric("getSampleMetadataIdColumnNames"))
setMethod("getSampleMetadataIdColumnNames", "MbioDataset", function(object) getIdColumnNames(object@metadata))
setMethod("getSampleMetadataIdColumnNames", "AbundanceData", function(object) getIdColumnNames(object@sampleMetadata))
setMethod("getSampleMetadataIdColumnNames", "Collection", function(object) getIdColumnNames(object@sampleMetadata))

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
#' as an AbundanceData, phyloseq, or Collection object.
#' @param object A Microbiome Dataset
#' @param collectionName The name of the collection to return
#' @param format The format of the collection to return. Currently supported options are "AbundanceData", "phyloseq", and "Collection".
#' @param continuousMetadataOnly If TRUE, only continuous metadata will be returned. If FALSE, all metadata will be returned.
#' @return An AbundanceData, phyloseq, or Collection object representing the collection and any associated study metadata
#' @importFrom microbiomeComputations AbundanceData
#' @importFrom phyloseq phyloseq
#' @importFrom microbiomeComputations SampleMetadata
#' @export
setGeneric("getCollection", function(object, collectionName, format = c("AbundanceData", "phyloseq", "Collection"), continuousMetadataOnly = c(FALSE, TRUE)) standardGeneric("getCollection"))
setMethod("getCollection", "MbioDataset", function(object, collectionName = character(0), format = c("AbundanceData", "phyloseq", "Collection"), continuousMetadataOnly = c(FALSE, TRUE)) {
    format <- veupathUtils::matchArg(format)
    continuousMetadataOnly <- veupathUtils::matchArg(continuousMetadataOnly)
    
    if (length(collectionName) == 0) {
        stop("Must specify a collection name")
    }
    
    if (!collectionName %in% getCollectionNames(object)) {
        stop(sprintf("Collection '%s' does not exist", collectionName))
    }

    collection <- object@collections[collectionName][[1]]
    if (format == "Collection") {
        return(collection)
    }

    collectionDT <- data.table::setDT(collection@data)
    collectionIdColumns <- c(collection@recordIdColumn, collection@ancestorIdColumns)

    # remove IRI from collection column names. strip everything after and including the last square bracket, and remove trailing spaces
    rawNames <- names(collectionDT)
    names(collectionDT)[! names(collectionDT) %in% collectionIdColumns] <- sub("\\s*\\[([^\\[]*)$", "", names(collectionDT)[! names(collectionDT) %in% collectionIdColumns])
    names(collectionDT)[names(collectionDT) == 'Incertae Sedis'] <- rawNames[names(collectionDT) == 'Incertae Sedis']

    if (!!length(object@metadata@data)) {

        # need to be sure sample metadata contains only the relevant rows, actually having assay data
        # also need to make sure it has the assay record id column
        sampleMetadataDT <- data.table::setDT(merge(
            object@metadata@data, 
            collectionDT[, collectionIdColumns, with = FALSE], 
            by = c(object@metadata@ancestorIdColumns, object@metadata@recordIdColumn),
            all.y = TRUE
        ))

        # if we only want continuous metadata, only keep numeric columns
        # means we lose dates, but i think thats ok for now
        if (continuousMetadataOnly) {
            metadataColNames <- names(sampleMetadataDT)
            numericColumns <- metadataColNames[which(sapply(sampleMetadataDT,is.numeric))]
            sampleMetadataDT <- sampleMetadataDT[, unique(c(collectionIdColumns, numericColumns)), with=FALSE]
        }

        # also need to make sure they are in the same order
        data.table::setorderv(sampleMetadataDT, cols=collection@recordIdColumn)
        data.table::setorderv(collectionDT, cols=collection@recordIdColumn)

        sampleMetadata <- new("SampleMetadata",
            data = sampleMetadataDT,
            recordIdColumn = collection@recordIdColumn,
            ancestorIdColumns = collection@ancestorIdColumns
        )

    } else {
        sampleMetadataDT <- data.table::data.table()
        sampleMetadata <- microbiomeComputations::SampleMetadata()
    }
    
    if (format == "AbundanceData") {

        abundanceData <- microbiomeComputations::AbundanceData(
            data = collectionDT, 
            sampleMetadata = sampleMetadata, 
            recordIdColumn = collection@recordIdColumn,
            ancestorIdColumns = collection@ancestorIdColumns
        )

    } else if (format == "phyloseq") {

        sampleNames <- collectionDT[[collection@recordIdColumn]]
        keepCols <- names(collectionDT)[! names(collectionDT) %in% collectionIdColumns]
        taxaNames <- names(collectionDT[, keepCols, with = FALSE])
        otu <- t(collectionDT[, keepCols, with = FALSE])
        names(otu) <- sampleNames
        rownames(otu) <- taxaNames

        tax <- data.frame(taxonomy = rownames(otu))
        rownames(tax) <- tax$taxonomy

        samples <- sampleMetadataDT

        if (nrow(samples) != 0) {
            rownames(samples) <- sampleNames
            samples <- samples[, !collectionIdColumns, with = FALSE]

            abundanceData <- phyloseq::phyloseq(
                phyloseq::otu_table(as.matrix(otu), taxa_are_rows = TRUE),
                phyloseq::sample_data(samples),
                phyloseq::tax_table(as.matrix(tax))
            )
        } else {
            abundanceData <- phyloseq::phyloseq(
                phyloseq::otu_table(as.matrix(otu), taxa_are_rows = TRUE),
                phyloseq::tax_table(as.matrix(tax))
            )
        }
    } 

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
setGeneric("getComputeResult", function(object, format = c("data.table"), ...) standardGeneric("getComputeResult"))

#' @export
setMethod("getComputeResult", "ComputeResult", function(object, format = c("data.table", "igraph")) {
    format <- veupathUtils::matchArg(format)

    if (!!length(object@statistics)) {
        return(getComputeResult(object@statistics, format))
    } else {
        if (format == "igraph") {
            stop("igraph not yet supported")
        }
    }

    dt <- data.table::setDT(object@data)

    return(dt)  
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

mergeComputeResultAndMetadata <- function(computeResult, dataset, metadataVariables) {
    dt <- getComputeResult(computeResult, "data.table")
    metadata <- getSampleMetadata(dataset, metadataVariables)

    metadataIdColumns <- getSampleMetadataIdColumnNames(dataset)
    dt <- merge(dt, metadata, by = metadataIdColumns, all.x = TRUE)

    return(dt)
}

#' Get Microbiome Dataset Compute Result With Metadata
#' 
#' Get the compute result from a Microbiome Dataset in a particular format with metadata.
#' @param object A Microbiome Dataset
#' @param dataset The MbioDataset, AbundanceData or Collection object from which the compute result was obtained.
#' @param format The format of the compute result. Currently only "data.table" is supported.
#' @param metadataVariables The metadata variables to include in the compute result. If NULL, no metadata variables will be included.
#' @return The compute result in the specified format
#' @export
setGeneric("getComputeResultWithMetadata", 
function(object, dataset, format = c("data.table"), metadataVariables = NULL) 
    standardGeneric("getComputeResultWithMetadata"), 
    signature = c("object", "dataset")
)

#' @export
setMethod("getComputeResultWithMetadata", signature = c("ComputeResult", "MbioDataset"), 
function(object, dataset = NULL, format = c("data.table"), metadataVariables = NULL) {
    format <- veupathUtils::matchArg(format)
    dt <- mergeComputeResultAndMetadata(object, dataset, metadataVariables)

    return(dt)
})

#' @export
setMethod("getComputeResultWithMetadata", signature = c("ComputeResult", "Collection"), 
function(object, dataset = NULL, format = c("data.table"), metadataVariables = NULL) {
    format <- veupathUtils::matchArg(format)
    dt <- mergeComputeResultAndMetadata(object, dataset, metadataVariables)

    return(dt)
})

#' @export 
setMethod("getComputeResultWithMetadata", signature = c("ComputeResult", "AbundanceData"), 
function(object, dataset = NULL, format = c("data.table"), metadataVariables = NULL) {
    format <- veupathUtils::matchArg(format)
    dt <- mergeComputeResultAndMetadata(object, dataset, metadataVariables)

    return(dt)
})