app <- ShinyDriver$new("../")
app$snapshotInit("scatter_basic")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$snapshot()
