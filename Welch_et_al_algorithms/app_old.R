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
                    dashboardSidebar(
                      sidebarMenu(id='sidebarmenu',
                                  menuItem("Start animations",tabName="animations",icon=icon("clock-o",lib='font-awesome')),
                                  actionButton("Start","Start animations")
                                  
                                  )
                    ),
                    dashboardBody(
                      fluidRow(
                        column(width=6,imageOutput("EcoCast")),
                        column(width=6,imageOutput("Marxan"))
                      )
                    ))

server <- shinyServer(function(input, output) {

  eventReactive(input$Start,{
    
  
  output$EcoCast=renderImage({
    list(src=paste0("data/ecocast.gif"),
                      contentType = 'image/gif',
         width = 600,
         height = 700
                      # alt = "This is alternate text"
  )
    },deleteFile = F)

  output$Marxan=renderImage({
    list(src=paste0("data/marxan.gif"),
         contentType = 'image/gif',
         width = 600,
         height = 700
         # alt = "This is alternate text"
    )
    },deleteFile = F)
  
  })
  
  })


shinyApp(ui = ui, server = server)