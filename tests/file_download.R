app <- ShinyDriver$new("../")
app$snapshotInit("file_download")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$snapshotDownload("downPlot")
