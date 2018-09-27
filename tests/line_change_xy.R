app <- ShinyDriver$new("../")
app$snapshotInit("line_change_xy")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "line")
app$setInputs(y = "price")
app$snapshot()
