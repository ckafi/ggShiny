# This file defines the interface of the app. It should only contain markup.
# Any logic should be put into server.R
# Shiny defines the interface through nested layout components ("panels" and
# "widgets). The root of this tree is the 'ui' variable, which can be found at
# the end of this file.

library(shinythemes)
library(colourpicker)

# The panel for file upload and data preview
filepanel <- tabPanel(
  title = "File Upload",
  # A sidebarLayout consists of a sidebar and a main area
  sidebarLayout(

    # The sidebar for file upload
    sidebarPanel(
      checkboxInput(
        inputId = "example_data",
        label   = "Use Example",
        value   = FALSE
      ),
      # fileInput only handles the _upload_ of the file; the interpretation of
      # its contents happens in server.R
      fileInput(
        inputId  = "file",
        label    = "Choose CSV File",
        multiple = TRUE,
        accept   = c("text/csv",
                     "text/comma-separated-values",
                     "text/plain",
                     ".csv")
      ),

      tags$hr(),

      checkboxInput(
        inputId = "header",
        label   = "Header",
        value   = TRUE
      ),

      radioButtons(
        inputId  = "sep",
        label    = "Separator",
        choices  = c(Comma     = ",",
                     Semicolon = ";",
                     Tab       = "\t"),
        selected = ","
      ),

      radioButtons(
        inputId  = "quote",
        label    = "Quote",
        choices  = c(None          = "",
                    "Double Quote" = '"',
                    "Single Quote" = "'"),
        selected = '"'
      )
    ),

    # the main area with the interpreted content of the uploaded file
    mainPanel(
      tableOutput(outputId = "contents")
    )
  )
)


# the panel for plot selection and display
plotpanel <- tabPanel(
  title = "Plot",
  # A sidebarLayout consists of a sidebar and a main area
  sidebarLayout(

    sidebarPanel(
      # the sidebar consists of multiple tabs (a "tabset")
      tabsetPanel(
        id = "settings", # id needed for testing

        # the panel for plot selection and plot options
        tabPanel(
          title = "Main Options",
          selectInput(
            inputId = "plotselect",
            label   = "Select Plot",
            choices = list("Scatter plot" = "point",
                           "Histogram"    = "histogram",
                           "Line Graph"   = "line",
                           "Boxplot"      = "boxplot",
                           "Heatmap"      = "heatmap")
          ),
          tags$hr(),
          # the UI elements for the plot options are dynamically created in
          # server.R
          uiOutput(outputId = "aes")
        ),

        # the panel for plot colors and labels
        tabPanel(
          title = "Labeling and colour(s)",
          textInput(
            inputId = "title",
            label   = "Title:",
            value   = "Title"
          ),
          textInput(
            inputId = "xlab",
            label   = "x-Label:",
            value   = "x-Label"
          ),
          textInput(
            inputId = "ylab",
            label = "y-Label:",
            value = "y-Label"
          ),
          checkboxInput(
            inputId = "rotate_labels",
            label   = "Rotate tick labels on x-axis",
            value   = FALSE
          ),
          tags$hr(),
          selectInput(
            inputId = "xgrid",
            label   = "Vertical Grid Lines",
            choices = list("All" = "all",
                           "Only major" = "major",
                           "None" = "none")
          ),
          selectInput(
            inputId = "ygrid",
            label   = "Horizontal Grid Lines",
            choices = list("All" = "all",
                           "Only major" = "major",
                           "None" = "none")
          ),
          tags$hr(),
          colourInput(
            inputId = "col1",
            label   = "Select primary colour",
            value   = "black"),
          colourInput(
            inputId = "col2",
            label   = "Select secondary colour (for some plots)",
            value   = "white")
        ),

        # the panel for the reference line
        tabPanel(
          title = "Reference Line",
          checkboxInput(
            inputId = "draw_ref_line",
            label   = "Draw reference line",
            value   = FALSE
          ),
          selectInput(
            inputId = "ref_line",
            label   = "Select Reference Line",
            choices = list("Vertical Line"   = "vline",
                           "Horizontal Line" = "hline",
                           "AB-Line"         = "abline")
          ),
          numericInput(
            inputId = "interc",
            label   = "Intercept",
            value   = 0
          ),
          numericInput(
            inputId = "slope",
            label   = "Slope (for AB-line)",
            value   = 0
          ),
          selectInput(
            inputId  = "ref_linetype",
            label    = "Linetype",
            choices  = c("solid", "dashed", "dotted",
                         "dotdash", "longdash", "twodash"),
            selected = "solid"
          ),
          sliderInput(
            inputId = "refsize",
            label   = "Size",
            value   = 0.5,
            min     = 0.1,
            max     = 5,
            step    = 0.1
          ),
          colourInput(
            inputId = "refcol",
            label   = "Color",
            value   = "black")
        )
      )
    ),

    # the main area with the generated plot
    # and the download button
    mainPanel(
      plotOutput("plot"),
      downloadButton(
        outputId = "downPlot",
        label = "Download"
      )
    )
  )
)


# This is the main entry point for the UI
# navbarPage creates a page with a top level navigation bar
ui <- navbarPage(
  id = "main", # the id is necessary for testing
  title = "ggShiny",
  theme = shinytheme("yeti"),
  # the panels
  filepanel,
  plotpanel
)
