library(shinythemes)
library(colourpicker)

filepanel <- tabPanel(
  "File Upload",
  sidebarLayout(
    sidebarPanel(
      checkboxInput("example_data", "Use Example", FALSE),
      fileInput("file", "Choose CSV File",
        multiple = TRUE,
        accept = c(
          "text/csv",
          "text/comma-separated-values",
          "text/plain",
          ".csv"
        )
      ),

      tags$hr(),

      checkboxInput("header", "Header", TRUE),

      radioButtons("sep", "Separator",
        choices = c(
          Comma = ",",
          Semicolon = ";",
          Tab = "\t"
        ),
        selected = ","
      ),

      radioButtons("quote", "Quote",
        choices = c(
          None = "",
          "Double Quote" = '"',
          "Single Quote" = "'"
        ),
        selected = '"'
      )
    ),

    mainPanel(
      tableOutput("contents")
    )
  )
)

plotpanel <- tabPanel(
  "Plot",
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(
        id = "settings",

        tabPanel(
          "Main Options",
          selectInput("plotselect", "Select Plot",
            choices = list(
              "Scatter plot" = "point",
              "Histogram" = "histogram",
              "Line Graph" = "line",
              "Boxplot" = "boxplot",
              "Heatmap" = "heatmap"
            )
          ),
          tags$hr(),
          uiOutput("aes")
        ),
        tabPanel(
          "Labeling and colour(s)",
          textInput("title",
            label = "Title:",
            value = "Title"
          ),
          textInput("xlab",
            label = "x-Label:",
            value = "x-Label"
          ),
          textInput("ylab",
            label = "y-Label:",
            value = "y-Label"
          ),
          checkboxInput("rotate_labels",
            label = "Rotate tick labels on x-axis",
            value = FALSE
          ),
          tags$hr(),
          selectInput("xgrid",
            label = "Vertical Grid Lines",
            choices = list(
              "All" = "all",
              "Only major" = "major",
              "None" = "none"
            )
          ),
          selectInput("ygrid",
            label = "Horizontal Grid Lines",
            choices = list(
              "All" = "all",
              "Only major" = "major",
              "None" = "none"
            )
          ),
          tags$hr(),
          colourInput("col1", "Select primary colour", "black"),
          colourInput("col2", "Select secondary colour (for some plots)", "white")
        ),
        tabPanel(
          "Reference Line",
          checkboxInput("draw_ref_line",
            label = "Draw reference line",
            value = FALSE
          ),
          selectInput("ref_line", "Select Reference Line",
            choices = list(
              "Vertical Line" = "vline",
              "Horizontal Line" = "hline",
              "AB-Line" = "abline"
            )
          ),
          numericInput("interc", label = "Intercept", value = 0),
          numericInput("slope", label = "Slope (for AB-line)", value = 0),
          selectInput("ref_linetype", "Linetype",
            choices = c(
              "solid", "dashed", "dotted",
              "dotdash", "longdash", "twodash"
            ),
            selected = "solid"
          ),
          sliderInput("refsize", "Size",
            min = 0.1, max = 5,
            value = 0.5, step = 0.1
          ),
          colourInput("refcol", "Color", "black")
        )
      )
    ),

    mainPanel(
      plotOutput("plot"),
      downloadButton(
        outputId = "downPlot",
        label = "Download"
      )
    )
  )
)



ui <- navbarPage(
  id = "main",
  title = "ggShiny",
  theme = shinytheme("yeti"),
  filepanel,
  plotpanel
)
