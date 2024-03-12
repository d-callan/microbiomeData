# Given a data table, a recordIdColumn, and ancestorIdColumns (see slots of AbundanceData or SampleMetadata),
# check to ensure given id columns are valid. Return any errors. 
validateIdColumns <- function(df, record_id_col=character(), ancestor_id_cols=c()) {

  errors <- character()

  if (length(record_id_col) != 1) {
    msg <- "Record ID column must have a single value."
    errors <- c(errors, msg) 
  }

  if (!record_id_col %in% names(df)) {
    msg <- paste("Record ID column is not present in abundance data.frame")
    errors <- c(errors, msg)
  }

  if (!!length(ancestor_id_cols)) {
    if (!all(ancestor_id_cols %in% names(df))) {
      msg <- paste("Not all ancestor ID columns are present in abundance data.frame")
      errors <- c(errors, msg)
    }
  }

  return(errors)
}

isNAorZero <- function(x) {
  return(is.na(x) | x == 0)
}