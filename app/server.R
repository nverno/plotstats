### server.R --- 
## Filename: server.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 20 22:15:39 2015 (-0400)
## Last-Updated: Wed Oct 21 03:29:03 2015 (-0400)
##           By: Noah Peart
######################################################################
## Testing out partials/controllers separation
## https://github.com/jcheng5/shiny-partials/blob/master/server.R

function(input, output, session) {
    values <- reactiveValues()
    
    output$container <- renderUI({
        if (is.null(input$level1) || is.null(input$level2))
            return( NULL )

        inp <- grep("^partial", names(session$input), value=TRUE)
        if (!length(inp))
            return( NULL )
        fname <- input[[inp]]
        
        ## Any security checks for bad paths
        ## Add path to reactiveValues as well
        projectPath <- file.path(input$level1, input$level2, "partials")
        values <- reactiveValues(projectPath = projectPath)

        ## Sources from projectPath/partials/<page>.R
        source(file.path(projectPath, paste0(fname, ".R")), local=TRUE)$value
    })

    ## source the controllers
    files <- findControllers()
    for (file in files) source(file, local=TRUE)

}
