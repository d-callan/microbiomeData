test_that("we can create a new MbioDataset", {
    # an empty one
    mbioDataset <- MbioDataset()
    expect_that(mbioDataset, is_a("MbioDataset"))
    
    # a manually populated one
    mbioDataset <- MbioDataset(
        Collections("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id"), 
        SampleMetadata()
    )
    expect_that(mbioDataset, is_a("MbioDataset"))   

    # from a Collection object and SampleMetadata
    mbioDataset <- MbioDataset(
        Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id"), 
        SampleMetadata()
    )
    expect_that(mbioDataset, is_a("MbioDataset"))
    
    # from a file of collections and sample metadata
    dataFile1 <- '../../inst/extdata/DiabImmune/DiabImmune_entity_16SRRNAV4Assay.txt'
    metadataFile1 <- '../../inst/extdata/DiabImmune/DiabImmune_ParticipantRepeatedMeasure.txt'
    mbioDataset <- MbioDataset(dataFile1, metadataFile1)
    expect_that(mbioDataset, is_a("MbioDataset"))
    # TODO check that things have reasonable names and id columns

    # from a data frame of collections and sample metadata
    df <- data.table::fread(dataFile1)
    metadata <- data.table::fread(metadataFile1)
    mbioDataset <- MbioDataset(df, metadata)
    expect_that(mbioDataset, is_a("MbioDataset"))
    # TODO check that things have reasonable names and id columns

    # from a list of files of collections and sample metadata
    dataFile2 <- '../../inst/extdata/DiabImmune/DiabImmune_MetagenomicSequencingAssay.txt'
    metadataFile2 <- '../../inst/extdata/DiabImmune/DiabImmune_Participant.txt'
    metadataFile3 <- '../../inst/extdata/DiabImmune/DiabImmune_Sample.txt'
    mbioDataset <- MbioDataset(list(dataFile1, dataFile2), list(metadataFile1, metadataFile2, metadataFile3))
    expect_that(mbioDataset, is_a("MbioDataset"))
    # TODO check that things have reasonable names and id columns

    # from a list of collections and sample metadata data frames
    df2 <- data.table::fread(dataFile2)
    metadata2 <- data.table::fread(metadataFile2)
    metadata3 <- data.table::fread(metadataFile3)
    mbioDataset <- MbioDataset(list(df, df2), list(metadata, metadata2, metadata3))
    expect_that(mbioDataset, is_a("MbioDataset"))
    # TODO check that things have reasonable names and id columns
})