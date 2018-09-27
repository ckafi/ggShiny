library(ggplot2)

server <- function(input, output) {
  writeLines("\n\n === Server restart ===")
  print(Sys.time())

  output$contents <- renderTable(
    {inputData()},
    striped = TRUE,
    hover = TRUE
  )

  output$aes <- renderUI({
    dispatch_aes_ui()
  })

  output$plot <- renderPlot({
    plot_()
  })

  output$downPlot <- downloadHandler(
    filename = reactive({
      paste(input$title, ".png", sep = "")
    }),
    content = function(file) {
      plot_() + theme(aspect.ratio = 0.5)
      ggsave(file, device = "png")
    },
    contentType = "image/png"
  )

  inputData <- reactive({
    if (input$example_data) {
      diamonds[1:1000,]
    } else {
      req(input$file)
      read.csv(input$file$datapath,
        header = input$header,
        sep = input$sep,
        quote = input$quote
      )
    }
  })


  plot_ <- reactive({
    ggplot(inputData(),
      aes(x = get(input$x), y = get(input$y))) +
      dispatch_geom_plot() +
      labs(title = input$title, # Add labels
           x = input$xlab,
           y = input$ylab) +
      reference_line() +
      theme_linedraw() + # ggplot theme 
      theme(legend.title=element_blank()) +
      theme_grid() +
      theme_ticklabels() +
      scale_fill_gradient(
        low = input$col1,
        high = input$col2
      ) # only for heatmap
  })

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
        checkboxInput("jitter", "Jitter",
          value = FALSE
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
      ),

      "line" = tagList(
        selectInput("x", "Select x",
          choices = names(inputData())
        ),
        selectInput("y", "Select y",
          choices = names(inputData())
        ),
        selectInput("group", "Group by",
          choices = c("None", names(inputData()))
        ),
        selectInput("linetype", "Linetype",
          choices = c(
            "solid", "dashed", "dotted",
            "dotdash", "longdash", "twodash"
          ),
          selected = "solid"
        ),
        sliderInput("size", "Size",
          min = 0.1, max = 5,
          value = 1, step = 0.1
        )
      ),

      "boxplot" = tagList(
        selectInput("x", "Select x",
          choices = names(inputData())
        ),
        selectInput("y", "Select y",
          choices = names(inputData())
        )
      ),

      "heatmap" = tagList(
        selectInput("x", "Select x",
          choices = names(inputData()),
          selected = input$x
        ),
        selectInput("y", "Select y",
          choices = names(inputData()),
          selected = input$y
        ),
        if (!is.factor(inputData()[[input$x]])) {
          m <- max(inputData()[[input$x]])
          sliderInput("binwidth_x", "Size of bins (x)",
            min = 0, max = m,
            value = m / 10, step = m / 100
          )
        },
        if (!is.factor(inputData()[[input$y]])) {
          m <- max(inputData()[[input$y]])
          sliderInput("binwidth_y", "Size of bins (y)",
            min = 0, max = m,
            value = m / 10, step = m / 100
          )
        }
      )
    ))
  }


  dispatch_geom_plot <- function() {
    g <- switch(input$plotselect,

      "point" = geom_point(
        shape = strtoi(input$shape),
        size = input$size,
        stroke = input$stroke,
        position = if(input$jitter) "jitter" else "identity"
      ),

      "histogram" = geom_histogram(
        # this is needed, so the 'y -> input$y' mapping is deleted
        inherit.aes = FALSE,
        aes(x = get(input$x)),
        stat = if (is.factor(inputData()[[input$x]])) "count" else "bin",
        binwidth = input$binwidth
      ),

      "line" = if (input$group == "None") {
        geom_line(linetype = input$linetype,
                  size = input$size)
      } else {
        geom_line(aes(linetype = get(input$group)),
                  size = input$size)
      },

      "boxplot" = geom_boxplot(
      ),

      "heatmap" = geom_bin2d(
        binwidth = c(
          input$binwidth_x,
          input$binwidth_y
        )
      )
    )

    if(input$plotselect != "heatmap") {
      g$aes_params$colour <- input$col1
      g$aes_params$fill <- input$col2
    }
    return(g)
  }


  reference_line <- function() {
    if (input$draw_ref_line) {
      refline <- switch(input$ref_line,
        "vline" = geom_vline(
          xintercept = input$interc
        ),
        "hline" = geom_hline(
          yintercept = input$interc
        ),
        "abline" = geom_abline(
          intercept = input$interc,
          slope = input$slope
        )
      )
      refline$aes_params$colour <- input$refcol
      refline$aes_params$linetype <- input$ref_linetype
      refline$aes_params$size <- input$refsize
      refline
    } else {
      NULL
    }
  }


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


  theme_ticklabels <- function() {
    if (input$rotate_labels) {
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
    } else {
      theme()
    }
  }
}
