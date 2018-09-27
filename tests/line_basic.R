app <- ShinyDriver$new("../")
app$snapshotInit("line_basic")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "line")
app$snapshot()
