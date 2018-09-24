app <- ShinyDriver$new("../")
app$snapshotInit("scatter_change_points")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(shape = "24")
app$setInputs(size = 1.6)
app$setInputs(stroke = 0.7)
app$snapshot()
