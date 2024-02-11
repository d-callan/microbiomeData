test_that("we can create a new Collection", {
    # an empty one

    # a manually populated one

    # from a data frame

    # from a file
})

test_that("Collection validation works", {
    # empty name fails

    # empty data fails

    # negative data values fail

    # empty recordIdColumn fails

    # recordIdColumn not in data fails

    # ancestorIdColumns not in data fails

    # all column names start w the same prefix except ancestorIdColumns or fails
})

test_that("we can make Collections", {
    # an empty one

    # from a list of Collections

    # from a list of data frames

    # from a list of files
    
    # from a data frame
    
    # from a file
})

test_that("Collection validation works", {
    # duplicate names fails

    # a collection w different ancestorIdColumns fails
})