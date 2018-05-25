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

    output$aes <- renderUI({dispatch_aes_ui()})

    output$plot <- renderPlot({
        plot_base() + dispatch_geom_plot()
    })

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
                        value = 1, step = 0.1))

                    ))
    }

    observe({print(input$shape)})

    
    dispatch_geom_plot <- function() {
        return(switch(input$plotselect,
                "point" = geom_point(
                    aes(x = get(input$x),
                        y = get(input$y)),
                        shape = strtoi(input$shape),
                        size = input$size,
                        stroke = input$stroke)
                ))
    }
}
