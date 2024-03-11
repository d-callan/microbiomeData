#' Get all ID columns
#' 
#' Returns a vector of all ID columns
#' 
#' @param object AbundanceData, or other object with slots recordIdColumn and ancestorIdColumns
#' @return vector of all ID columns
#' @rdname getIdColumns
#' @export
setGeneric("getIdColumns",
  function(object) standardGeneric("getIdColumns"),
  signature = c("object")
)

#' @rdname getIdColumns
#' @aliases getIdColumns,ANY-method
setMethod("getIdColumns", "ANY", function(object) {
    if (all(c('recordIdColumn','ancestorIdColumns') %in% slotNames(object))) {
        return(c(object@recordIdColumn, object@ancestorIdColumns))
    } else {
        stop("Object does not have recordIdColumn and/or ancestorIdColumns slots. Received object of class ", class(object))
    }
})

#' Get data.table of abundances from AbundanceData
#'
#' Returns a data.table of abundances, respecting the
#' `imputeZero` slot.
#' 
#' @param object AbundanceData
#' @param ignoreImputeZero boolean indicating whether we should respect the imputeZero slot
#' @param includeIds boolean indicating whether we should include recordIdColumn and ancestorIdColumns
#' @return data.table of abundances
#' @rdname getAbundances
#' @export
setGeneric("getAbundances",
  function(object, ignoreImputeZero = c(FALSE, TRUE), includeIds = c(TRUE, FALSE), verbose = c(TRUE, FALSE)) standardGeneric("getAbundances"),
  signature = c("object")
)

#' @rdname getAbundances
#' @aliases getAbundances,AbundanceData-method
setMethod("getAbundances", signature("AbundanceData"), function(object, ignoreImputeZero = c(FALSE, TRUE), includeIds = c(TRUE, FALSE), verbose = c(TRUE, FALSE)) {
  ignoreImputeZero <- veupathUtils::matchArg(ignoreImputeZero)
  includeIds <- veupathUtils::matchArg(includeIds)
  verbose <- veupathUtils::matchArg(verbose)

  dt <- object@data
  allIdColumns <- getIdColumns(object)

  # Check that incoming dt meets requirements
  if (!inherits(dt, 'data.table')) {
    # this might technically be bad form, but i think its ok in this context
    data.table::setDT(dt)
  }

  if (object@removeEmptySamples) {
    dt.noIds <- dt[, -..allIdColumns]
    # Remove samples with NA or 0 in all columns
    dt <- dt[rowSums(isNAorZero(dt.noIds)) != ncol(dt.noIds),]
    numSamplesRemoved <- nrow(dt.noIds) - nrow(dt)
    if (numSamplesRemoved > 0) {
      veupathUtils::logWithTime(paste0("Removed ", numSamplesRemoved, " samples with no data."), verbose)
    }
  }

  # Replace NA values with 0
  if (!ignoreImputeZero && object@imputeZero) {
    veupathUtils::setNaToZero(dt)
  }

  if (!includeIds) {
    dt <- dt[, -..allIdColumns]
  }

  return(dt)
})

#' Get data.table of sample metadata from AbundanceData
#'
#' Returns a data.table of sample metadata
#' 
#' @param object AbundanceData
#' @param asCopy boolean indicating whether to return the data as a copy or by reference
#' @param includeIds boolean indicating whether we should include recordIdColumn and ancestorIdColumns
#' @param metadataVariables The metadata variables to include in the sample metadata. If NULL, all metadata variables will be included.
#' @return data.table of sample metadata
#' @import veupathUtils
#' @import data.table
#' @rdname getSampleMetadata
#' @export
setGeneric("getSampleMetadata",
  function(object, asCopy = c(TRUE, FALSE), includeIds = c(TRUE, FALSE), metadataVariables = NULL) standardGeneric("getSampleMetadata"),
  signature = c("object")
)

#' @rdname getSampleMetadata
#' @aliases getSampleMetadata,AbundanceData-method
setMethod("getSampleMetadata", signature("AbundanceData"), function(object, asCopy = c(TRUE, FALSE), includeIds = c(TRUE, FALSE), metadataVariables = NULL) {
  asCopy <- veupathUtils::matchArg(asCopy)
  includeIds <- veupathUtils::matchArg(includeIds)
  
  dt <- object@sampleMetadata@data
  allIdColumns <- getSampleMetadataIdColumns(object)

  # Check that incoming dt meets requirements
  if (!inherits(dt, 'data.table')) {
    data.table::setDT(dt)
  }

  if (asCopy) {
    dt <- data.table::copy(dt)
  }

  if (object@removeEmptySamples) {
    # not using getAbundances here bc i want the empty samples here
    abundances <- object@data[, -..allIdColumns]

    # Remove metadata for samples with NA or 0 in all columns
    dt <- dt[rowSums(isNAorZero(abundances)) != ncol(abundances),]
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

#' Get Microbiome Dataset Metadata Variable Names
#' 
#' Get the names of the metadata variables in the Microbiome Dataset.
#' @param object A Microbiome Dataset
#' @return a character vector of metadata variable names
#' @rdname getSampleMetadataVariableNames
#' @export
setGeneric("getMetadataVariableNames", function(object) standardGeneric("getMetadataVariableNames"))

#' @rdname getMetadataVariableNames
#' @aliases getMetadataVariableNames,AbundanceData-method
setMethod("getMetadataVariableNames", "AbundanceData", function(object) return(names(object@sampleMetadata@data)))

#' Get Sample Metadata Id Column Names
#' 
#' Get the names of the record and ancestor id columns in the sample metadata of the Microbiome Dataset.
#' @param object A Microbiome Dataset, or other object w sample metadata
#' @return a character vector of id column names
#' @rdname getSampleMetadataIdColumns
#' @export
setGeneric("getSampleMetadataIdColumns", function(object) standardGeneric("getSampleMetadataIdColumns"))

#' @rdname getSampleMetadataIdColumns
#' @aliases getSampleMetadataIdColumns,AbundanceData-method
setMethod("getSampleMetadataIdColumns", "AbundanceData", function(object) getIdColumns(object@sampleMetadata))

#' Drop samples with incomplete SampleMetadata
#'
#' Modifies the data and sampleMetadata slots of an 
#' AbundanceData object, to exclude samples with 
#' missing SampleMetadata for a specified column.
#' 
#' @param object AbundanceData
#' @param colName String providing the column name in SampleMetadata to check for completeness
#' @param verbose boolean indicating if timed logging is desired
#' @return AbundanceData with modified data and sampleMetadata slots
#' @rdname removeIncompleteSamples
#' @export
setGeneric("removeIncompleteSamples",
  function(object, colName = character(), verbose = c(TRUE, FALSE)) standardGeneric("removeIncompleteSamples"),
  signature = c("object")
)

#' @rdname removeIncompleteSamples
#' @aliases removeIncompleteSamples,AbundanceData-method
setMethod("removeIncompleteSamples", signature("AbundanceData"), function(object, colName = character(), verbose = c(TRUE, FALSE)) {
  verbose <- veupathUtils::matchArg(verbose)

  df <- getAbundances(object, verbose = verbose)
  sampleMetadata <- getSampleMetadata(object)

  # Remove samples with NA from data and metadata
  if (any(is.na(sampleMetadata[[colName]]))) {
    veupathUtils::logWithTime("Found NAs in specified variable. Removing these samples.", verbose)
    samplesWithData <- which(!is.na(sampleMetadata[[colName]]))
    # Keep samples with data. Recall the AbundanceData object requires samples to be in the same order
    # in both the data and metadata
    sampleMetadata <- sampleMetadata[samplesWithData, ]
    df <- df[samplesWithData, ]

    object@data <- df
    object@sampleMetadata <- SampleMetadata(
      data = sampleMetadata,
      recordIdColumn = object@sampleMetadata@recordIdColumn
    )
    validObject(object)
  }

  return(object)
})

#' Prune features by predicate
#' 
#' Modifies the data slot of an 
#' AbundanceData object, to exclude features for which 
#' the provided predicate function returns FALSE.
#' 
#' @param object AbundanceData
#' @param predicate Function returning a boolean indicating if a feature should be included (TRUE) or excluded (FALSE)
#' @param verbose boolean indicating if timed logging is desired
#' @return AbundanceData with modified data slot
#' @rdname pruneFeatures
#' @export
setGeneric("pruneFeatures",
  function(object, predicate, verbose = c(TRUE, FALSE)) standardGeneric("pruneFeatures"),
  signature = c("object")
)

#' @rdname pruneFeatures
#' @aliases pruneFeatures,AbundanceData-method 
setMethod("pruneFeatures", signature("AbundanceData"), function(object, predicate, verbose = c(TRUE, FALSE)) {
  df <- getAbundances(object)
  allIdColumns <- c(object@recordIdColumn, object@ancestorIdColumns)

  # keep columns that pass the predicate
  keepCols <- df[, lapply(.SD, predicate), .SDcols = colnames(df)[!(colnames(df) %in% allIdColumns)]]
  keepCols <- names(keepCols)[keepCols == TRUE]
  df <- df[, c(allIdColumns, keepCols), with = FALSE]

  # LET ME EXPLAIN
  # since we called getAbundances (which removes empty samples)..
  # we need to do the same for sampleMetadata in order to produce a valid object.
  # and, we dont want those empty samples influencing which features get pruned, so i think were tied to this.
  # we just need to be sure we ask for the metadata before resetting the abundance data, or else we'll get an error
  # bc getSampleMetadata also calls getAbundances to find which samples to remove
  # we could maybe do it better, by introducing a hasSampleMetadata method in here. but i'm not sure if that's worth it.
  if (nrow(object@sampleMetadata@data) > 0) {
    object@sampleMetadata@data <- getSampleMetadata(object)
  }
  object@data <- df
  validObject(object)
  return(object)
})