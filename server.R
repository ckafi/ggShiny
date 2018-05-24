library(ggplot2)

server <- function(input, output) {

    inputData <- reactive({
        req(input$file)
        read.csv(input$file$datapath,
            header = input$header,
            sep = input$sep,
            quote = input$quote)
    })



    plot_base <- reactive({
        ggplot(inputData())
    })

    output$contents <- renderTable({inputData()})

    output$aes <- renderUI({
        tagList(
        selectInput("x", "Select x",
            choices = names(inputData())),
        selectInput("y", "Select y",
            choices = names(inputData())))
    })

    output$plot <- renderPlot({
        plot_base() + geom_point(
            mapping = aes(x = get(input$x),
                          y = get(input$y)))
    })
}
