app <- ShinyDriver$new("../")
app$snapshotInit("histo_basic")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "histogram")
app$snapshot()
