app <- ShinyDriver$new("../", seed = 123456)
app$snapshotInit("scatter_jitter")

app$setInputs(example_data = TRUE)
app$setInputs(main = "Plot")
app$setInputs(jitter = TRUE)
app$snapshot()
