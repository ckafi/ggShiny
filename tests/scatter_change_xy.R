app <- ShinyDriver$new("../")
app$snapshotInit("scatter_change_xy")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(x = "cut")
app$setInputs(y = "color")
app$snapshot()
