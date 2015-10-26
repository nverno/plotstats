### test.R --- 
## Filename: test.R
## Description: Change background color for specific range 
## Author: Noah Peart
## Created: Mon Oct 26 14:11:46 2015 (-0400)
## Last-Updated: Mon Oct 26 14:16:57 2015 (-0400)
##           By: Noah Peart
######################################################################
## http://stackoverflow.com/questions/33349513/r-how-to-change-plot-background-color-for-a-specific-range-in-ggvis-shiny-app

library(shiny)
library(ggvis)

df <- data.frame(Student = c("a","a","a","a","a","b","b","b","b","b","c","c","c","c"),
                 year = c(seq(2001,2005,1),seq(2010,2014,1),seq(2012,2015,1)),
                 score = runif(14,min = 50,max = 100), stringsAsFactors=F)

ui = (fluidPage(
    sidebarLayout(
        sidebarPanel(
            selectInput("stu","Choose Student",
                        choice = unique(df$Student))
        ),
        mainPanel(ggvisOutput("plot"))
    )
)
      )
