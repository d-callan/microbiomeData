## a helper function to test a dataset
test_dataset <- function(x) {
    print(paste("Testing",x))
    x <- get(x)

    #some simple tests that the thing is populated
    expect_s4_class(x, "MbioDataset")
    expect_equal(length(x@collections) > 0, TRUE)
    expect_equal(length(x@metadata@data) > 0, TRUE)
    expect_equal(nrow(x@metadata@data) > 0, TRUE)

    #tests for collection names.
    collectionNames <- MicrobiomeDB::getCollectionNames(x)
    expect_equal(length(collectionNames) > 0, TRUE)
    # all 16s collections have a region
    expect_equal(grepl("16S", collectionNames, fixed=TRUE), grepl("16S (V", collectionNames, fixed=TRUE))

    #tests for collection data
    collectionData <- MicrobiomeDB::getCollection(x, collectionNames[1])
    expect_s4_class(collectionData, "Collection")
    expect_s4_class(collectionData, "AbundanceData")
    expect_equal(length(collectionData@data) > 0, TRUE)
    expect_equal(nrow(collectionData@data) > 0, TRUE)

    #tests for ancestor id and record id cols
    expect_equal(length(collectionData@ancestorIdColumns) > 0, TRUE)
    expect_equal(length(collectionData@recordIdColumn) == 1, TRUE)
    # the id cols should end in _Id
    expect_equal(grepl("_Id$", collectionData@recordIdColumn), TRUE)
    expect_equal(all(grepl("_Id$", collectionData@ancestorIdColumns)), TRUE)
    # the id cols should match the metadata id cols
    expect_equal(collectionData@recordIdColumn == collectionData@sampleMetadata@recordIdColumn, TRUE)
    expect_equal(all(collectionData@ancestorIdColumns == collectionData@sampleMetadata@ancestorIdColumns), TRUE)
}

# test datasets that claim to be here via getCuratedDatasetNames()
# this will be done in a loop, which can make figuring out which datasets
# are wrong more difficult, so well try to add some custom logging in the helper
test_that("automagically loaded data is sane", {
    datasets <- getCuratedDatasetNames()
    expect_equal(length(datasets) > 0, TRUE)

    lapply(datasets, test_dataset)  
})
