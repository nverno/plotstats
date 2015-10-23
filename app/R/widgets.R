### widgets.R --- 
## Filename: widgets.R
## Description: Modified shiny widgets
## Author: Noah Peart
## Created: Mon Oct 12 13:11:02 2015 (-0400)
## Last-Updated: Thu Oct 22 21:53:44 2015 (-0400)
##           By: Noah Peart
######################################################################
## Spaces between buttons in input panel
buttonSeparator <- hr(style="margin-top: 0.2em; margin-bottom: 0.2em;")

## Make options appear inline with label
inlineLabel <- function(widget, sep)
    gsub("class=\"shiny-options-group\"",
         sprintf("style=\"display:inline;margin-left:%spx\"", sep), widget)

## https://github.com/ua-snap/shiny-apps/blob/master/plot3D/ui.R
headerPanel <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}

## Modified linked_brush to work with reactive data
## http://stackoverflow.com/questions/28491576/linked-brush-in-ggvis-cannot-work-in-shiny-when-data-change
mylinked_brush <- function(keys, fill = "red") {
    stopifnot(is.character(fill), length(fill) == 1)

    rv <- shiny::reactiveValues(under_brush = character(), keys = character())
    rv$keys <- isolate(keys)

    input <- function(vis) {
        handle_brush(vis, fill = fill, on_move = function(items, ...) {
            rv$under_brush <- items$key__
        })
    }

    set_keys <- function(keys) {
        rv$keys <- keys
    }

    set_brush <- function(ids) {
        rv$under_brush <- ids
    }

    selected_r <- reactive(rv$keys %in% rv$under_brush)
    fill_r <- reactive(c("black", fill)[selected_r() + 1])

    list(
        input = input,
        selected = create_broker(selected_r),
        fill = create_broker(fill_r),
        set_keys = set_keys,
        set_brush = set_brush
    )
}
