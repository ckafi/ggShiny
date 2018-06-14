library(shinythemes)

filepanel <- tabPanel(
  "File Upload",
  sidebarLayout(
    sidebarPanel(
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
        tabPanel(
          "Main Options",
          selectInput("plotselect", "Select Plot",
            choices = list(
              "Scatter plot" = "point",
              "Histogram" = "histogram"
            )
          ),
          tags$hr(),
          uiOutput("aes")
        ),
        tabPanel(
          "Labeling",
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
          )
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
  title = "ggShiny",
  theme = shinytheme("yeti"),
  filepanel,
  plotpanel
)
