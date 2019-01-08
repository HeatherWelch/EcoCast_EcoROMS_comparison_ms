### Benioff to display blue whale predictions from two years

##### Defining global objects####
# source functions
#source("load_functions.R")
library(shiny)
library(shinydashboard)
library(shinyjs)
library(magick)

ui <- dashboardPage(skin="blue",
                    dashboardHeader(
                      title = "EcoCast and Marxan animations",
                      titleWidth = 420
                    ),
                    dashboardSidebar(),

                    dashboardBody(
                      fluidRow(
                        column(width=12,
                        div(style="text-align:center",tags$div(img(
                          src="combo.gif",
                          width = 1200,
                          height = 700,
                          style = "margin:10px 10px"
                        ))))
                      )
                    ))

server <- shinyServer(function(input, output) {
  addClass(selector = "body", class = "sidebar-collapse")
  # output$EcoCast=renderImage({
  #   list(src=paste0("data/ecocast.gif"),
  #                     contentType = 'image/gif',
  #        width = 600,
  #        height = 700
  #                     # alt = "This is alternate text"
  # )
  #   },deleteFile = F)
  
  # output$Marxan=renderImage({
  #   list(src=paste0("data/marxan.gif"),
  #        contentType = 'image/gif',
  #        width = 600,
  #        height = 700
  #        # alt = "This is alternate text"
  #   )
  #   },deleteFile = F)

  
  })


shinyApp(ui = ui, server = server)