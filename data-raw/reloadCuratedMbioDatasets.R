## each directory in data-raw should represent a curated dataset
## it should have subdirectories like `assayData`, `sampleMetadata` and `ontology`
## the convenience function here should be called on each directory
## the convenience function should build an MbioDataset object
## then it should call use_data and overwrite the old object

#usethis::use_data(DATASET, overwrite = TRUE)
