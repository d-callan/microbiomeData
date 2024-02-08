setGeneric("Collection", function(name, data, recordIdColumn) standardGeneric("Collection"))
setMethod("Collection", signature("character", "data.frame", "character"), function(name, data, recordIdColumn) {
    new("Collection", name, data, recordIdColumn)
})

setMethod("Collection", signature("character", "missing", "missing"), function(name, data, recordIdColumn) {
    new("Collection", name)
})

setMethod("Collection", signature("character", "data.frame", "missing"), function(name, data, recordIdColumn) {
    # TODO find recordIdColumn, maybe an arg to say if the first column is the record id
    new("Collection", name, data)
})

setMethod("Collection", signature("character", "character", "missing"), function(name, data, recordIdColumn) {
    # TODO read from file
    # TODO find recordIdColumn, maybe an arg to say if the first column is the record id
    new("Collection", name, data)
})


setGeneric("Collections", function(collections) standardGeneric("Collections"))

setMethod("Collections", signature("missing"), function(collections) {
    new("Collections")
})

setMethod("Collections", signature("list"), function(collections) {
    # TODO make Collections from a list of files
    new("Collections", collections)
})

setMethod("Collections", signature("data.frame"), function(collections) {
    # TODO make Collections from a data frame
    new("Collections", collections)
})

setMethod("Collections", signature("Collection"), function(collections) {
    new("Collections", list(collections))
})

setMethod("Collections", signature("character"), function(collections) {
    # TODO make Collections from a file
    new("Collections", list(Collection(collections)))
})


setGeneric("mbioDataset", function(collections, metadata) standardGeneric("mbioDataset"))

setMethod("mbioDataset", signature("missing", "missing"), function(collections, metadata) {
    new("mbioDataset")
})

setMethod("mbioDataset", signature("Collections", "data.frame"), function(collections, metadata) {
    new("mbioDataset", collections = collections, metadata = SampleMetadata(metadata))
})

setMethod("mbioDataset", signature("Collections", "missing"), function(collections, metadata) {
    new("mbioDataset", collections = collections)
})

setMethod("mbioDataset", signature("Collection", "data.frame"), function(collections, metadata) {
    new("mbioDataset", collections = Collections(collections), metadata = SampleMetadata(metadata))
})

setMethod("mbioDataset", signature("Collection", "missing"), function(collections, metadata) {
    new("mbioDataset", collections = Collections(collections))
})

setMethod("mbioDataset", signature("list", "data.frame"), function(collections, metadata) {
    # TODO make Collections from a list of files containing data
    new("mbioDataset", collections = Collections(collections), metadata = SampleMetadata(metadata))
})

setMethod("mbioDataset", signature("list", "missing"), function(collections, metadata) {
    # TODO make Collections from a list of files containing data
    new("mbioDataset", collections = Collections(collections))
})

setMethod("mbioDataset", signature("list", "list"), function(collections, metadata) {
    # TODO make Collections and SampleMetadata from a list of files containing data
    new("mbioDataset", collections = Collections(collections), metadata = SampleMetadata(metadata))
})

setMethod("mbioDataset", signature("data.frame", "missing"), function(collections, metadata) {
    # TODO parse data frame into Collections
    new("mbioDataset", collections = Collections(collections))
})

setMethod("mbioDataset", signature("data.frame", "data.frame"), function(collections, metadata) {
    # TODO parse data frame into Collections
    new("mbioDataset", collections = Collections(collections), metadata = SampleMetadata(metadata))
})