app <- ShinyDriver$new("../")
app$snapshotInit("boxplot_change_xy")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "boxplot")
app$setInputs(x = "cut")
app$snapshot()
