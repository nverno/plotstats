library(dplyr)
library(ggvis)
library(shiny)

app <- shinyApp(
    shinyUI(
        bootstrapPage(
            ggvisOutput('ggvis'),
            uiOutput('ggvisUI')
        )),
    shinyServer(function(input, output, session) {
        vals <- reactiveValues()
        
        click <- function(data, location, session) {
            cat(str(data))
        }

        ## With drop down list it doesn't work
        resize <- function(vis, ...) {
            vals$width <- plot_width(vis)
            vals$height <- plot_height(vis)
            cat(vals$width, "x", vals$height, "\n")
        }

        dat <- reactive({ mtcars })

        dat %>% ggvis(
            x = ~wt,
            y = input_select(c('mpg', 'hp'), map=as.name, selected='mpg', label='Variables'),
            fill = ~cyl
        ) %>%
          layer_points() %>%
          add_relative_scales() %>%
          handle_click(click) %>%
          add_legend('fill',
                     title='Cylinders',
                     properties = legend_props(
                         legend = list(
                             x = scaled_value("x_rel", 0.9),
                             y = scaled_value("y_rel", 1)
                         )
                     )) %>%
          bind_shiny('ggvis', 'ggvisUI')
                
        ## )
        ##   ggvis(x = ~wt, y = input_select(c("Miles per gallon" = "mpg", "Horse power" = "hp"),
        ##                      map = as.name, selected = "mpg",
        ##                      label = "Variables"), fill=~cyl) %>% 
        ##                        layer_points() %>% 
        ##                        add_relative_scales() %>%
        ##                        ## handle_click(click) %>%
        ##                        add_legend("fill", title = "Cylinders",
        ##                                   properties = legend_props(
        ##                                       legend = list(
        ##                                           x = scaled_value("x_rel", 0.8),
        ##                                           y = scaled_value("y_rel", 1)
        ##                                       ))) %>%
        ##                                         bind_shiny('ggvis')
        
    })
)

