## a simple placeholder test for DiabImmune
## we can expand this if we would like, but for now
## we just want to make sure that DiabImmune is
## a MbioDataset object and has reasonable collections
test_that("DiabImmune is sane", {
    expect_s4_class(microbiomeData::DiabImmune, "MbioDataset")
    expect_true(length(microbiomeData::DiabImmune@collections) > 0)
})