app <- ShinyDriver$new("../")
app$snapshotInit("histo_change_binsize")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "histogram")
app$setInputs(binwidth = 0.4953)
app$snapshot()
