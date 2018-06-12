library(shinythemes)

filepanel <- tabPanel("File Upload",
    sidebarLayout(
        sidebarPanel(
            fileInput("file", "Choose CSV File",
                multiple = TRUE,
                accept = c("text/csv",
                    "text/comma-separated-values",
                    "text/plain",
                    ".csv")),

            tags$hr(),

            checkboxInput("header", "Header", TRUE),

            radioButtons("sep", "Separator",
                choices = c(Comma = ",",
                    Semicolon = ";",
                    Tab = "\t"),
                selected = ","),

            radioButtons("quote", "Quote",
                choices = c(None = "",
                    "Double Quote" = '"',
                    "Single Quote" = "'"),
                selected = '"')

            ),

        mainPanel(
            tableOutput("contents")
            )
        )
    )

plotpanel <- tabPanel("Plot",
    sidebarLayout(
        sidebarPanel(
            selectInput("plotselect", "Select Plot",
                choices = list(
                    "Scatter plot" = "point",
                    "Histogram" = "histogram")),

            tags$hr(),

            uiOutput("aes")
            ),

        mainPanel(
            plotOutput('plot'),
            downloadButton(
                outputId = "downPlot",
                label = "Download")
            )
        )
    )



ui <- navbarPage(title="ggShiny",
    theme = shinytheme("yeti"),
    filepanel,
    plotpanel)
