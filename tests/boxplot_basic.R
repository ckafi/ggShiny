app <- ShinyDriver$new("../")
app$snapshotInit("boxplot_basic")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(plotselect = "boxplot")
app$snapshot()
