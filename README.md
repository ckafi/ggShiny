# ggShiny

A [Shiny](https://shiny.rstudio.com/) application that generates [ggPlot2](http://ggplot2.tidyverse.org/) plots.

## Installation
You'll need a R installation and a C/C++ compiler. Then install the necessary
packages:

```
$ R
> install.packages(c("ggplot2", "shiny", "shinythemes", "colourpicker"))
```

## Running
For a stand-alone Shiny app just run

```
$ R -e "shiny::runApp('./ggShiny')"
```

## Testing
To test the app install and load `shinytest`, then run `testApp()`.

For a multi-user capable solution you may consider [Shiny
Server](https://www.rstudio.com/products/shiny/shiny-server/) or
[ShinyApps](http://www.shinyapps.io/).
