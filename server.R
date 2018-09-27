# This file contains the logic of the app. Shiny apps are reactive. This means
# that each code block 'subscribes' to one or multiple input$* variables, which
# are set in the UI. If one of these variables changes, each subscribed block is
# automatically rerun.

library(ggplot2)

server <- function(input, output) {
  writeLines("\n\n === Server restart ===")
  print(Sys.time())


  # Load the example data or read the uploaded file
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


  # Assemble the plot
  plot_ <- reactive({
    # Load data and map x and y
    ggplot(
      data    = inputData(),
      mapping = aes(x = get(input$x), y = get(input$y))) +
    # Add the assembled geom
    geom() +
    # Add labels
    labs(
      title = input$title,
      x = input$xlab,
      y = input$ylab
    ) +
    reference_line() +
    # Apply ggplot theme
    theme_linedraw() +
    # Remove title from legend. Most of the time this will
    # show something like 'get(input$group)'
    theme(legend.title=element_blank()) +
    # Add gridlines
    theme_grid() +
    # Add ticklabels
    theme_ticklabels() +
    # Define color gradient for heatmap.
    # This has no effect on other geoms
    scale_fill_gradient(
      low = input$col1,
      high = input$col2
    )
  })


  # Assemble geom
  geom <- reactive( {
    g <- switch(input$plotselect,

      "point" = geom_point(
        shape = strtoi(input$shape),
        size = input$size,
        stroke = input$stroke,
        position = if(input$jitter) "jitter" else "identity"
      ),

      "histogram" = geom_histogram(
        # This is needed, so the 'y -> input$y' mapping is deleted
        inherit.aes = FALSE,
        aes(x = get(input$x)),
        # Use bins if x is continous
        stat = if (is.factor(inputData()[[input$x]])) "count" else "bin",
        binwidth = input$binwidth
      ),

      "line" = if (input$group == "None") {
        # This line geom will use input$linetype to
        # draw a single line
        geom_line(
          linetype = input$linetype,
          size = input$size
        )
      } else {
        # This line geom draws multiple lines, based on
        # input$group. The set of linetypes is predefined.
        geom_line(
          mapping = aes(linetype = get(input$group)),
          size = input$size
        )
      },

      "boxplot" = geom_boxplot(),

      "heatmap" = geom_bin2d(
        binwidth = c(
          input$binwidth_x,
          input$binwidth_y
        )
      )
    )

    # Add color to geom.
    # For heatmap, the color gradient is added 
    # when final plot is assembled
    if(input$plotselect != "heatmap") {
      g$aes_params$colour <- input$col1
      g$aes_params$fill <- input$col2
    }
    g
  })


  # Assemble reference line
  reference_line <- reactive({
    if (input$draw_ref_line) {
      refline <- switch(input$ref_line,
        # Vertical line
        "vline" = geom_vline(
          xintercept = input$interc
        ),
        # Horizontal line
        "hline" = geom_hline(
          yintercept = input$interc
        ),
        # Sloped line
        "abline" = geom_abline(
          intercept = input$interc,
          slope = input$slope
        )
      )
      # Apply color, type and size
      refline$aes_params$colour <- input$refcol
      refline$aes_params$linetype <- input$ref_linetype
      refline$aes_params$size <- input$refsize
      refline
    }
  })


  # Disable major/minor grid labels
  theme_grid <- reactive({
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
  })


  # Rotate the ticklables, if asked for
  theme_ticklabels <- reactive({
    if (input$rotate_labels) {
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
    } else {
      theme()
    }
  })


  # Create UI elements for the plot options based on the plotselect
  # drop-down-menu.
  # This is the largest code block and should probably be refactored into
  # smaller pieces
  plot_ui <- reactive({
    switch(input$plotselect,

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
        # if x is continous, show slider for binsize
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
        # if x is continous, show slider for binsize
        if (!is.factor(inputData()[[input$x]])) {
          m <- max(inputData()[[input$x]])
          sliderInput("binwidth_x", "Size of bins (x)",
            min = 0, max = m,
            value = m / 10, step = m / 100
          )
        },
        # if y is continous, show slider for binsize
        if (!is.factor(inputData()[[input$y]])) {
          m <- max(inputData()[[input$y]])
          sliderInput("binwidth_y", "Size of bins (y)",
            min = 0, max = m,
            value = m / 10, step = m / 100
          )
        }
      )
    )
  })


  # Push read csv file (or example) to UI
  output$contents <- renderTable(
    expr    = {inputData()},
    striped = TRUE,
    hover   = TRUE
  )

  # Push UI for plot options to UI
  output$aes <- renderUI({
    plot_ui()
  })

  # Push plot to UI
  output$plot <- renderPlot({
    plot_()
  })

  # Save plot to file and serve for browser
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
}
