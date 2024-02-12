test_that("we can create a new Collection", {
    # an empty one
    collection <- Collection()
    expect_s4_class(collection, "Collection")

    # a manually populated one/ from a data frame
    collection <- Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id")
    expect_s4_class(collection, "Collection")

    # from a file
    fileName <- '../../inst/extdata/collection.tab'
    collection <- Collection("my collection", fileName, "entity.id")
    expect_s4_class(collection, "Collection")
})

test_that("Collection validation works", {
    # empty name fails
    expect_error(Collection("", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id"))

    # empty data fails
    expect_error(Collection("my collection", data.frame(), "entity.id"))

    # negative data values fail
    expect_error(Collection("my collection", data.frame(entity.id = 1, entity.collection_x = -1, entity.collection_y = 2), "entity.id"))

    # empty recordIdColumn fails
    expect_error(Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), ""))

    # recordIdColumn not in data fails
    expect_error(Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.z"))

    # ancestorIdColumns not in data fails
    expect_error(Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id", "entity.z"))

    # all column names start w the same prefix except id columns or fails
    expect_error(Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.y = 2), "entity.id", "ancestor.id"))
})

test_that("we can make Collections", {
    # an empty one
    Collections <- Collections()
    expect_s4_class(Collections, "Collections")

    # from a list of Collections
    Collections <- Collections(list(Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id")))
    expect_s4_class(Collections, "Collections")

    Collections <- Collections(Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id"))
    expect_s4_class(Collections, "Collections")

    # from a file
    file1 <- '../../inst/extdata/DiabImmune/DiabImmune_entity_16SRRNAV4Assay.txt'
    Collections <- Collections(file1)
    expect_s4_class(Collections, "Collections")
    # TODO check that things have reasonable names and id columns
    
    # from a data frame
    df <- data.table::fread(file1)
    Collections <- Collections(df)
    expect_s4_class(Collections, "Collections")
    # TODO check that things have reasonable names and id columns

    # from a list of files
    file2 <- '../../inst/extdata/DiabImmune/DiabImmune_MetagenomicSequencingAssay.txt'
    Collections <- Collections(list(file1, file2))
    expect_s4_class(Collections, "Collections")
    # TODO check that things have reasonable names and id columns

    # from a list of data frames
    df2 <- data.table::fread(file2)
    Collections <- Collections(list(df, df2))
    expect_s4_class(Collections, "Collections")
    # TODO check that things have reasonable names and id columns
})

test_that("Collection validation works", {
    # duplicate names fails
    expect_error(Collections(list(
        Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id"),
        Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id")
    )))

    # a collection w different ancestorIdColumns fails
    expect_error(Collections(list(
        Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id", "ancestor.y"),
        Collection("my collection", data.frame(entity.id = 1, entity.collection_x = 1, entity.collection_y = 2), "entity.id", "ancestor.z")
    )))
})