## each directory in data-raw should represent a curated dataset
## the name of the directory will become the name of the dataset
## it should have subdirectories like `assayData`, `sampleMetadata` and `ontology`
## the convenience function here should be called on each directory
## the convenience function should build an MbioDataset object
## then it should call use_data and overwrite the old object


buildMbioDatasetFromDataDir <- function(dataDir) {
    dataSet <- MicrobiomeDB::MbioDataset(
	    as.list(list.files(paste(dataDir, "assayData", sep = "/"), full.names = TRUE)),
	    as.list(list.files(paste(dataDir, "sampleMetadata", sep = "/"), full.names = TRUE)),
	    list.files(paste(dataDir, "ontology", sep = "/"), full.names = TRUE)
    )

    assign(basename(dataDir), dataSet, envir = as.environment(1)) ## this is the global env

    return(invisible(dataSet))
}

path <- function(x) {
    baseDir <- system.file("data", package = "microbiomeData", mustWork = TRUE)

    file.path(file.path(baseDir, x),'.rda',fsep='')
}

custom_use_data <- function(x) {
    paths <-path(x)

    mapply(save, list = x, file = paths, MoreArgs = list(envir = as.environment(1), 
        compress = 'xz', version = 3, ascii = FALSE))

    invisible()
}

baseDataDir <- system.file("data-raw", package = "microbiomeData", mustWork = TRUE)
studyDirectories <- list.files(baseDataDir, full.names = TRUE)
studyDirectories <- studyDirectories[!grepl(".R", studyDirectories, fixed = TRUE)] 

lapply(studyDirectories, buildMbioDatasetFromDataDir)
custom_use_data(basename(studyDirectories))
