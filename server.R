library(ggplot2)

server <- function(input, output) {
  output$contents <- renderTable({
    inputData()
  })

  output$aes <- renderUI({
    dispatch_aes_ui()
  })

  output$plot <- renderPlot({
    plot_()
  })

  output$downPlot <- downloadHandler(
    filename = function() {
      paste(
        if (input$title == "") {
          "plot"
        } else {
          input$title
        },
        ".png",
        sep = ""
      )
    },
    content = function(file) {
      plot_() + theme(aspect.ratio = 0.5)
      ggsave(file, device = "png")
    },
    contentType = "image/png"
  )

  inputData <- reactive({
    req(input$file)
    read.csv(input$file$datapath,
      header = input$header,
      sep = input$sep,
      quote = input$quote
    )
  })

  plot_ <- reactive({
    ggplot(inputData()) +
      labs(
        title = input$title,
        x = input$xlab,
        y = input$ylab
      ) +
      dispatch_geom_plot() +
      theme_linedraw() +
      theme_grid() +
      if (input$rotate_labels) {
        theme(axis.text.x = element_text(angle = 90, hjust = 1))
      } else {
        theme()
      }
  })

  theme_grid <- function() {
    return(
      switch(input$xgrid,
        "all" = theme(),
        "major" = theme(panel.grid.minor.x = element_blank()),
        "none" = theme(
          panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_blank()
        )
      ) +
        switch(input$ygrid,
          "all" = theme(),
          "major" = theme(panel.grid.minor.y = element_blank()),
          "none" = theme(
            panel.grid.minor.y = element_blank(),
            panel.grid.major.y = element_blank()
          )
        )
    )
  }


  dispatch_aes_ui <- function() {
    return(switch(input$plotselect,

      "point" = tagList(
        selectInput("x", "Select x",
          choices = names(inputData())
        ),
        selectInput("y", "Select y",
          choices = names(inputData())
        ),
        selectInput("shape", "Shape",
          choices = 0:25,
          selected = "19"
        ),
        sliderInput("size", "Size",
          min = 0.1, max = 5,
          value = 1, step = 0.1
        ),
        sliderInput("stroke", "Stroke",
          min = 0.1, max = 5,
          value = 1, step = 0.1
        )
      ),

      "histogram" = tagList(
        selectInput("x", "Select x",
          choices = names(inputData()),
          selected = input$x
        ),

        if (!is.factor(inputData()[[input$x]])) {
          m <- max(inputData()[[input$x]])
          sliderInput("binwidth", "Size of bins",
            min = 0, max = m,
            value = m / 10, step = m / 100
          )
        }
      )
    ))
  }


  dispatch_geom_plot <- function() {
    return(switch(input$plotselect,

      "point" = geom_point(
        aes(x = get(input$x), y = get(input$y)),
        shape = strtoi(input$shape),
        size = input$size,
        stroke = input$stroke
      ),

      "histogram" = geom_histogram(
        aes(x = get(input$x)),
        stat = if (is.factor(inputData()[[input$x]])) {
          "count"
        } else {
          "bin"
        },
        binwidth = input$binwidth
      )
    ))
  }
}
