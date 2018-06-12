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

    plot_full <- reactive({
        plot_base() + theme_linedraw() + dispatch_geom_plot()
    })

    output$contents <- renderTable({inputData()})

    output$aes <- renderUI({dispatch_aes_ui()})

    output$plot <- renderPlot({plot_full()})

    output$downPlot <- downloadHandler(
        filename = "plot.png",
        content = function(file) {
            plot_full()
            ggsave(file, device="png")
        },
        contentType = "image/png"
        )

    dispatch_aes_ui <- function() {
        return(switch(input$plotselect,

                "point" = tagList(
                    selectInput("x", "Select x",
                        choices = names(inputData())),
                    selectInput("y", "Select y",
                        choices = names(inputData())),
                    selectInput("shape","Shape",
                        choices = 0:25,
                        selected="19"),
                    sliderInput("size", "Size",
                        min = 0.1 , max = 5,
                        value = 1, step = 0.1),
                    sliderInput("stroke", "Stroke",
                        min = 0.1 , max = 5,
                        value = 1, step = 0.1)),

                "histogram" = tagList(
                    selectInput("x", "Select x",
                        choices = names(inputData()),
                        selected = input$x),

                    if(!is.factor(inputData()[[input$x]])) {
                        m <- max(inputData()[[input$x]])
                        sliderInput("binwidth", "Size of bins",
                            min = 0 , max = m,
                            value = m / 10, step = m / 100)
                        })

                    ))
    }

    
    dispatch_geom_plot <- function() {
        return(switch(input$plotselect,
                "point" = geom_point(
                    aes(x = get(input$x),
                        y = get(input$y)),
                        shape = strtoi(input$shape),
                        size = input$size,
                        stroke = input$stroke),

                "histogram" = geom_histogram(
                    aes(x = get(input$x)),
                    stat = if(is.factor(inputData()[[input$x]]))
                        { "count" } else { "bin"},
                    binwidth = input$binwidth)
                ))
    }
}
