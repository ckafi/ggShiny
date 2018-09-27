app <- ShinyDriver$new("../")
app$snapshotInit("heatmap_basic")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "heatmap")
app$snapshot()
