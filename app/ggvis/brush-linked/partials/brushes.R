### brushes.R --- 
## Filename: brushes.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 20 22:03:07 2015 (-0400)
## Last-Updated: Wed Oct 21 01:19:04 2015 (-0400)
##           By: Noah Peart
######################################################################
library(ggvis)

## ## Input: cant source input from ggvis?
## lb <- linked_brush(keys = cocaine$id, "red")
bootstrapPage(
    ggvisOutput('plot1'),
    ggvisOutput('plot2')
)
