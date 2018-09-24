app <- ShinyDriver$new("../")
app$snapshotInit("load_example")

app$setInputs(example_data = TRUE)
app$snapshot()
