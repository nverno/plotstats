### controls.R --- 
## Filename: controls.R
## Description: Examples with brush and ggvis
## Author: Noah Peart
## Created: Tue Oct 20 21:58:02 2015 (-0400)
## Last-Updated: Wed Oct 21 01:11:51 2015 (-0400)
##           By: Noah Peart
######################################################################
require(ggvis)

## Load some data
cocaine <- cocaine[sample(1:nrow(cocaine), 500),]
cocaine$id <- seq_len(nrow(cocaine))

## Input
lb <- linked_brush(keys = cocaine$id, "red")

## Plot1
cocaine %>%
  ggvis(~weight, ~price, key := ~id) %>%
  layer_points(fill := lb$fill, fill.brush := 'red', opacity := 0.3) %>%
  lb$input() %>%  # the brush input
  set_options(width = 300, height = 300) %>%
  bind_shiny('plot1')

## Subset of the selected components
selected <- lb$selected
cocaine_selected <- reactive({
    cocaine[selected(),]
})

## Plot2
cocaine %>%
  ggvis(~potency) %>%
  layer_histograms(width = 5, boundary = 0) %>%
  add_data(cocaine_selected) %>%
  layer_histograms(width = 5, boundary = 0, fill := "#dd3333") %>%
  set_options(width = 300, height = 300) %>%
  bind_shiny('plot2')



