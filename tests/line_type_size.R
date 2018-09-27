app <- ShinyDriver$new("../")
app$snapshotInit("line_type_size")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "line")
app$setInputs(linetype = "dashed")
app$setInputs(size = 2.2)
app$snapshot()
