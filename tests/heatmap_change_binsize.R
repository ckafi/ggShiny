app <- ShinyDriver$new("../")
app$snapshotInit("heatmap_change_binsize")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "heatmap")
app$setInputs(y = "price")
app$setInputs(binwidth_x = 0.2667)
app$setInputs(binwidth_y = 1333.08)
app$snapshot()
