app <- ShinyDriver$new("../")
app$snapshotInit("histo_factor")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "histogram")
app$setInputs(x = "color")
app$snapshot()
