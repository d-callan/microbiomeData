test_that("we can create a new MbioDataset", {
    # an empty one
    mbioDataset <- MbioDataset()
    expect_s4_class(mbioDataset, "MbioDataset")
    
    # a manually populated one
    mbioDataset <- MbioDataset(
        Collections(list(Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2, ancestor.y = 1), "entity.id", "ancestor.y"))), 
        SampleMetadata()
    )
    expect_s4_class(mbioDataset, "MbioDataset")   

    # from a Collection object and SampleMetadata
    mbioDataset <- MbioDataset(
        Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2, ancestor.y = 1), "entity.id", "ancestor.y"), 
        SampleMetadata()
    )
    expect_s4_class(mbioDataset, "MbioDataset")
    
    # from a file of collections and sample metadata
    dataFile1 <- '../../inst/extdata/DiabImmune/DiabImmune_entity_16SRRNAV4Assay.txt'
    metadataFile1 <- '../../inst/extdata/DiabImmune/DiabImmune_ParticipantRepeatedMeasure.txt'
    mbioDataset <- MbioDataset(dataFile1, metadataFile1)
    expect_s4_class(mbioDataset, "MbioDataset")
    # TODO check that things have reasonable names and id columns

    # from a data frame of collections and sample metadata
    df <- data.table::fread(dataFile1)
    metadata <- data.table::fread(metadataFile1)
    mbioDataset <- MbioDataset(df, metadata)
    expect_s4_class(mbioDataset, "MbioDataset")
    # TODO check that things have reasonable names and id columns

    # from a list of files of collections and sample metadata
    dataFile2 <- '../../inst/extdata/DiabImmune/DiabImmune_MetagenomicSequencingAssay.txt'
    metadataFile2 <- '../../inst/extdata/DiabImmune/DiabImmune_Participant.txt'
    metadataFile3 <- '../../inst/extdata/DiabImmune/DiabImmune_Sample.txt'
    mbioDataset <- MbioDataset(list(dataFile1, dataFile2), list(metadataFile1, metadataFile2, metadataFile3))
    expect_s4_class(mbioDataset, "MbioDataset")
    # TODO check that things have reasonable names and id columns

    # from a list of collections and sample metadata data frames
    df2 <- data.table::fread(dataFile2)
    metadata2 <- data.table::fread(metadataFile2)
    metadata3 <- data.table::fread(metadataFile3)
    mbioDataset <- MbioDataset(list(df, df2), list(metadata, metadata2, metadata3))
    expect_s4_class(mbioDataset, "MbioDataset")
    # TODO check that things have reasonable names and id columns
})

test_that("we can update collection names and get collections", {
    mbioDataset <- MbioDataset(
        Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2, ancestor.y = 1), "entity.id", "ancestor.y"), 
        SampleMetadata()
    )

    testDataset <- updateCollectionName(mbioDataset, "my collection", "My Collection")

    expect_equal(testDataset@collections[[1]]@name, "My Collection")
    expect_equal(getCollectionNames(testDataset)[[1]], "My Collection")

    testCollection <- getCollection(testDataset, "My Collection")
    expect_s4_class(testCollection, "AbundanceData")
    expect_equal(testCollection@data, data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2, ancestor.y = 1))
    expect_equal(testCollection@recordIdColumn, "entity.id")
    expect_equal(testCollection@ancestorIdColumns, "ancestor.y")

    testCollection <- getCollection(testDataset, "My Collection", "Collection")
    expect_s4_class(testCollection, "Collection")

    testCollection <- getCollection(testDataset, "My Collection", "phyloseq")
    expect_s4_class(testCollection, "phyloseq")
})

test_that("we can get compute results in different formats", {
    dataFile1 <- '../../inst/extdata/DiabImmune/DiabImmune_entity_16SRRNAV4Assay.txt'
    metadataFile1 <- '../../inst/extdata/DiabImmune/DiabImmune_ParticipantRepeatedMeasure.txt'
    dataFile2 <- '../../inst/extdata/DiabImmune/DiabImmune_MetagenomicSequencingAssay.txt'
    metadataFile2 <- '../../inst/extdata/DiabImmune/DiabImmune_Participant.txt'
    metadataFile3 <- '../../inst/extdata/DiabImmune/DiabImmune_Sample.txt'
    ontologyFile <- '../../inst/extdata/DiabImmune/DiabImmune_OntologyMetadata.txt'
    mbioDataset <- MbioDataset(list(dataFile1, dataFile2), list(metadataFile1, metadataFile2, metadataFile3), ontologyFile)

    # make sure metadata dont contain IRIs
    expect_equal(all(grepl('[',names(genus@sampleMetadata@data),fixed=T)), FALSE)

    correlationOutput <- microbiomeComputations::selfCorrelation(getCollection(mbioDataset, "16S Genus"), method='spearman', verbose=FALSE)
    correlationDT <- getComputeResult(correlationOutput, "data.table")

    # make sure continuousMetadataOnly flag works so we can do taxa X metadata correlations
    genus <- getCollection(mbioDataset, "16S Genus", continuousMetadataOnly = TRUE)
    correlationOutput <- microbiomeComputations::correlation(genus, method='spearman', verbose=FALSE)

    expect_equal(inherits(correlationDT, "data.table"), TRUE)
    expect_equal(all(c('data1', 'data2', 'correlationCoef', 'pValue') %in% names(correlationDT)), TRUE)

    correlationIGraph <- getComputeResult(correlationOutput, "igraph")
    expect_equal(inherits(correlationIGraph, "igraph"), TRUE)
})