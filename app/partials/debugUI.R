### debugUI.R --- 
## Filename: debugUI.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 21 02:47:17 2015 (-0400)
## Last-Updated: Wed Oct 21 02:47:55 2015 (-0400)
##           By: Noah Peart
######################################################################

fluidRow(
    tagList(
        textInput('debugInput', "Debug input:", ''),
        actionButton('debug', 'Debug'),
        verbatimTextOutput('debugShiny')
    )
)
