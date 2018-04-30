#
# This is a Shiny web application. You can run the application by clicking

##### Defining global objects####
# source functions
source("2_load_libraries.R")
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

# read in raw data 
run4_real=read.csv("data/species_predict_04.13.18_run4.csv")
run4_random=read.csv("data/species_predict_04.13.18_random_run4.csv") %>% .[1:1649,]
run5_real=read.csv("data/species_predict_04.24.18_run5.csv")
run5_random=read.csv("data/species_predict_04.24.18_random_run5.csv") %>% .[1:1649,]
run6_real=read.csv("data/species_predict_04.25.18_run6.csv")
run6_random=read.csv("data/species_predict_04.25.18_random_run6.csv") %>% .[1:1649,]


##### UI code

# Define UI for application 
ui <- dashboardPage(skin="yellow",
                    dashboardHeader(title="EcoCast 2.0 hindcast explorer"
                      ),
                    dashboardSidebar(
                      sidebarMenu(id = 'sidebarmenu',
                                  menuItem("Random data", tabName='random',icon=icon("random",lib='font-awesome')),
                                  conditionalPanel("input.sidebarmenu==='random'",
                                        div(style="background-color:black;",
                                        sliderInput("presence", "Presence threshold", 0,1,.5,step=.1),                          
                                        sliderInput("algorithm", "Algorithm threshold", -1,1,0,step=.1))),
                                         
                                  menuItem("Raw data", tabName='raw',icon=icon("ship",lib='font-awesome')),
                                  conditionalPanel("input.sidebarmenu==='raw'",
                                      div(style="background-color:black;",
                                      sliderInput("algorithmraw", "Algorithm threshold", -1,1,0,step=.1))),
                                  
                                  menuItem("Random data: swor vs lbst", tabName='random_ratio',icon=icon("random",lib='font-awesome')),
                                  conditionalPanel("input.sidebarmenu==='raw'"),
                                  
                                  menuItem("Raw data: swor vs lbst", tabName='raw_ratio',icon=icon("ship",lib='font-awesome')),
                                  conditionalPanel("input.sidebarmenu==='raw'")
                      )),

     dashboardBody(
       tabItems(
         tabItem(tabName = "random",h2("Random data (n/species = 1700)"),
       fluidRow(h3("Extreme LBST, neutral SWOR"),
         column(h4("EcoROMS"),width=4,plotOutput("EcoRoms_1")),
         column(h4("Marxan"),width=4,plotOutput("Marxan_1")),
         column(h4("Quantitative comparison"),width=4,DTOutput("table_1"))),
         
       fluidRow(h3("Extreme LBST, moderate SWOR"),
          column(h4("EcoROMS"),width=4,plotOutput("EcoRoms_2")),
          column(h4("Marxan"),width=4,plotOutput("Marxan_2")),
          column(h4("Quantitative comparison"),width=4,DTOutput("table_2"))),
                  
       fluidRow(h3("Extreme LBST, extreme SWOR"),
          column(h4("EcoROMS"),width=4,plotOutput("EcoRoms_3")),
          column(h4("Marxan"),width=4,plotOutput("Marxan_3")),
          column(h4("Quantitative comparison"),width=4,DTOutput("table_3")))
         ),
       
       tabItem(tabName = "raw",h2("Raw data (n: blshobs - 378, blshtrk - 911, casltrk - 37146, lbstobs - 28, lbsttrk - 2688, sworobs - 448)"),
       fluidRow(h3("Extreme LBST, neutral SWOR"),
          column(h4("EcoROMS"),width=4,plotOutput("EcoRoms_1a")),
          column(h4("Marxan"),width=4,plotOutput("Marxan_1a")),
          column(h4("Quantitative comparison"),width=4,DTOutput("table_1a"))),
               
       fluidRow(h3("Extreme LBST, moderate SWOR"),
          column(h4("EcoROMS"),width=4,plotOutput("EcoRoms_2a")),
          column(h4("Marxan"),width=4,plotOutput("Marxan_2a")),
          column(h4("Quantitative comparison"),width=4,DTOutput("table_2a"))),
               
       fluidRow(h3("Extreme LBST, extreme SWOR"),
          column(h4("EcoROMS"),width=4,plotOutput("EcoRoms_3a")),
          column(h4("Marxan"),width=4,plotOutput("Marxan_3a")),
          column(h4("Quantitative comparison"),width=4,DTOutput("table_3a")))
       ),
       
       tabItem(tabName = "random_ratio",h2("Random data (n swor & lbst = 1700)"),
       fluidRow(h3("Extreme LBST, neutral SWOR"),
           column(h4("EcoROMS"),width=4,plotOutput("EcoRoms_1b")),
           column(h4("Marxan"),width=4,plotOutput("Marxan_1b"))),
               
       fluidRow(h3("Extreme LBST, moderate SWOR"),
           column(h4("EcoROMS"),width=4,plotOutput("EcoRoms_2b")),
           column(h4("Marxan"),width=4,plotOutput("Marxan_2b"))),
               
       fluidRow(h3("Extreme LBST, extreme SWOR"),
           column(h4("EcoROMS"),width=4,plotOutput("EcoRoms_3b")),
           column(h4("Marxan"),width=4,plotOutput("Marxan_3b")))
       ),
       
       tabItem(tabName = "raw_ratio",h2("Raw data (n: swor - 448 & lbst - 2716)"),
       fluidRow(h3("Extreme LBST, neutral SWOR"),
           column(h4("EcoROMS swor"),width=3,plotOutput("EcoRoms_swor1")),
           column(h4("EcoROMS lbst"),width=3,plotOutput("EcoRoms_lbst1")),
           column(h4("Marxan swor"),width=3,plotOutput("Marxan_swor1")),
           column(h4("Marxan lbst"),width=3,plotOutput("Marxan_lbst1"))),
               
       fluidRow(h3("Extreme LBST, moderate SWOR"),
                column(h4("EcoROMS swor"),width=3,plotOutput("EcoRoms_swor2")),
                column(h4("EcoROMS lbst"),width=3,plotOutput("EcoRoms_lbst2")),
                column(h4("Marxan swor"),width=3,plotOutput("Marxan_swor2")),
                column(h4("Marxan lbst"),width=3,plotOutput("Marxan_lbst2"))),
               
       fluidRow(h3("Extreme LBST, extreme SWOR"),
                column(h4("EcoROMS swor"),width=3,plotOutput("EcoRoms_swor3")),
                column(h4("EcoROMS lbst"),width=3,plotOutput("EcoRoms_lbst3")),
                column(h4("Marxan swor"),width=3,plotOutput("Marxan_swor3")),
                column(h4("Marxan lbst"),width=3,plotOutput("Marxan_lbst3")))
       )
            
       ))
     )
            
            
#####


server <- shinyServer(function(input, output) {
  
  ## random data ####
  output$EcoRoms_1 <- renderPlot({
    # get raw data organized
      data=run4_random
      ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
      M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
        
       master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
       master$presenceVal=input$presence
       master$algorithmVal=input$algorithm

        sworDat=master[master$sp_name=="swor",]
        caslDat=master[master$sp_name=="casl",]
        lbstDat=master[master$sp_name=="lbst",]
        blshobsDat=master[master$sp_name=="blshobs",]
        blshtrkDat=master[master$sp_name=="blshtrk",]
        
        algorithm="EcoROMS_original"
        index=NULL
        index=grep(algorithm,names(master))
        subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
        a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
        a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
        a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
        a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
        a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
        a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
        a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original))
        a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
        a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
        a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
        a
     })
  output$Marxan_1 <-renderPlot({
      data=run4_random
      ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
      M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
   
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithm
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="Marxan_raw"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$table_1 <-renderDT({
      data=run4_random
      ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
      M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    # set up to plot
    data$presenceVal=input$presence
    data$algorithmVal=input$algorithm
    
    # data$presenceVal=presence
    # data$algorithmVal=algorithm
    # tablecaught=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=presence) %>% filter(product_value>=algorithm) %>%
    #   group_by(species,product) %>% summarise(num_presences_caught=n()) #%>% mutate(Percent_caught=Percent_caught/1649*100) %>% spread(product,Percent_caught)
    # 
    # tabletotal=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=presence) %>%
    #   group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaught,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))
    # 

    
    tablecaught=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% filter(product_value>=input$algorithm) %>% 
      group_by(species,product) %>% summarise(num_presences_caught=n())
    
    tabletotal=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% 
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaught,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                  
                                                                                                                                                                                                                      
  })
  
  output$EcoRoms_2 <- renderPlot({
    # get raw data organized
      data=run5_random
      ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
      M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithm
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="EcoROMS_original"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$Marxan_2 <-renderPlot({
      data=run5_random
      ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
      M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithm
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="Marxan_raw"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$table_2 <-renderDT({
      data=run5_random
      ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
      M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    # set up to plot
    data$presenceVal=input$presence
    data$algorithmVal=input$algorithm
    # set up for table
    # tabledata=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=presence)%>% filter(product_value>=algorithm) %>% 
    #    group_by(species,product) %>% summarise(Percent_caught=n()) #%>% mutate(Percent_caught=Percent_caught/1649*100) %>% spread(product,Percent_caught)
    
    tablecaught=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence)%>% filter(product_value>=input$algorithm) %>% 
      group_by(species,product) %>% summarise(num_presences_caught=n()) #%>% mutate(Percent_caught=Percent_caught/1649*100) %>% spread(product,Percent_caught)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% 
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaught,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                  
    
  })
  
  output$EcoRoms_3 <- renderPlot({
    # get raw data organized
      data=run6_random
      ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
      M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithm
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="EcoROMS_original"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$Marxan_3 <-renderPlot({
      data=run6_random
      ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
      M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithm
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="Marxan_raw"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$table_3 <-renderDT({
      data=run6_random
      ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
      M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    # set up to plot
    data$presenceVal=input$presence
    data$algorithmVal=input$algorithm
    # set up for table
    # tabledata=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=presence)%>% filter(product_value>=algorithm) %>% 
    #    group_by(species,product) %>% summarise(Percent_caught=n()) #%>% mutate(Percent_caught=Percent_caught/1649*100) %>% spread(product,Percent_caught)
    
    tablecaught=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence)%>% filter(product_value>=input$algorithm) %>% 
      group_by(species,product) %>% summarise(num_presences_caught=n()) #%>% mutate(Percent_caught=Percent_caught/1649*100) %>% spread(product,Percent_caught)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% 
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaught,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                  
    
  })
  
  ## real data ####
  output$EcoRoms_1a <- renderPlot({
    # get raw data organized
    data=run4_real
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    master=data %>% as.data.frame()
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmraw
    
    sworDat=master[master$sp_name=="sworobs",]
    caslDat=master[master$sp_name=="casltrk",]
    lbstDat=master[master$sp=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="EcoROMS_original"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=blshobs,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=blshtrk,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=casl,y=algorithmVal))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
    
    
  })
  output$Marxan_1a <-renderPlot({
    data=run4_real
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    master=data %>% as.data.frame()
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmraw
    
    sworDat=master[master$sp_name=="sworobs",]
    caslDat=master[master$sp_name=="casltrk",]
    lbstDat=master[master$sp=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="Marxan_raw"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=blshobs,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=blshtrk,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=casl,y=algorithmVal))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$table_1a <-renderDT({
    data=run4_real
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    # set up to plot

    data$algorithmVal=input$algorithmraw
    
    # data$algorithmVal=algorithm
    # tablecaught=data %>% select(c(sp_name, EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-sp_name) %>% filter(product_value>=algorithm) %>%
    #   group_by(sp_name,product) %>% summarise(num_presences_caught=n()) 
    # 
    # tabletotal=data %>% select(c(sp_name, EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-sp_name) %>%
    #   group_by(sp_name,product) %>% summarise(num_presences=n()) %>% left_join(tablecaught,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))

    tablecaught=data %>% select(c(sp_name, EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-sp_name) %>% filter(product_value>=input$algorithmraw) %>%
      group_by(sp_name,product) %>% summarise(num_presences_caught=n()) 
    
    tabletotal=data %>% select(c(sp_name, EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-sp_name) %>%
      group_by(sp_name,product) %>% summarise(num_presences=n()) %>% left_join(tablecaught,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                  
    
  })
  
  output$EcoRoms_2a <- renderPlot({
    # get raw data organized
    data=run5_real
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% as.data.frame()
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmraw
    
    sworDat=master[master$sp_name=="sworobs",]
    caslDat=master[master$sp_name=="casltrk",]
    lbstDat=master[master$sp=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="EcoROMS_original"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=blshobs,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=blshtrk,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=casl,y=algorithmVal))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$Marxan_2a <-renderPlot({
    data=run5_real
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% as.data.frame()
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmraw
    
    sworDat=master[master$sp_name=="sworobs",]
    caslDat=master[master$sp_name=="casltrk",]
    lbstDat=master[master$sp=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="Marxan_raw"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=blshobs,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=blshtrk,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=casl,y=algorithmVal))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$table_2a <-renderDT({
    data=run5_real
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    # set up to plot

    data$algorithmVal=input$algorithmraw
    # set up for table
    tablecaught=data %>% select(c(sp_name, EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-sp_name) %>% filter(product_value>=input$algorithmraw) %>%
      group_by(sp_name,product) %>% summarise(num_presences_caught=n()) 
    
    tabletotal=data %>% select(c(sp_name, EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-sp_name) %>%
      group_by(sp_name,product) %>% summarise(num_presences=n()) %>% left_join(tablecaught,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                  
    
  })
  
  output$EcoRoms_3a <- renderPlot({
    # get raw data organized
    data=run6_real
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% as.data.frame()
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmraw
    
    sworDat=master[master$sp_name=="sworobs",]
    caslDat=master[master$sp_name=="casltrk",]
    lbstDat=master[master$sp=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="EcoROMS_original"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=blshobs,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=blshtrk,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=casl,y=algorithmVal))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$Marxan_3a <-renderPlot({
    data=run6_real
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% as.data.frame()
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmraw
    
    sworDat=master[master$sp_name=="sworobs",]
    caslDat=master[master$sp_name=="casltrk",]
    lbstDat=master[master$sp=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="Marxan_raw"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=blshobs,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=blshtrk,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=lbst,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=casl,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=casl,y=algorithmVal))
    #a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
  })
  output$table_3a <-renderDT({
    data=run6_real
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    # set up to plot
    
    data$algorithmVal=input$algorithmraw
    # set up for table
    tablecaught=data %>% select(c(sp_name, EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-sp_name) %>% filter(product_value>=input$algorithmraw) %>%
      group_by(sp_name,product) %>% summarise(num_presences_caught=n()) 
    
    tabletotal=data %>% select(c(sp_name, EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-sp_name) %>%
      group_by(sp_name,product) %>% summarise(num_presences=n()) %>% left_join(tablecaught,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                  
    
  })
  
  ## randome ratio ####
  output$EcoRoms_1b <-renderPlot({
  data=run4_random
  ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
  M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
  
  algorithm="EcoROMS_original"
  subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
  a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                  breaks=c(-.5,0,.5),
                                                                                                                  limits=c(-1,1))
  a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
  a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
  a
  })
  output$Marxan_1b <-renderPlot({
    data=run4_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    algorithm="Marxan_raw"
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                              breaks=c(-.5,0,.5),
                                                                                                              limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  
  output$EcoRoms_2b <-renderPlot({
    data=run5_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    algorithm="EcoROMS_original"
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                    breaks=c(-.5,0,.5),
                                                                                                                    limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$Marxan_2b <-renderPlot({
    data=run5_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    algorithm="Marxan_raw"
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                              breaks=c(-.5,0,.5),
                                                                                                              limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  
  output$EcoRoms_3b <-renderPlot({
    data=run6_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    algorithm="EcoROMS_original"
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                    breaks=c(-.5,0,.5),
                                                                                                                    limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$Marxan_3b <-renderPlot({
    data=run6_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    algorithm="Marxan_raw"
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=data,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                              breaks=c(-.5,0,.5),
                                                                                                              limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })

  
  ## real ratio ####
  output$EcoRoms_swor1 <-renderPlot({
    data=run4_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    algorithm="EcoROMS_original"
    species="swordfish"
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                       breaks=c(-.5,0,.5),
                                                                                                                       limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$EcoRoms_lbst1 <-renderPlot({
    data=run4_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    algorithm="EcoROMS_original"
    species="leatherback"
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                       breaks=c(-.5,0,.5),
                                                                                                                       limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$Marxan_swor1 <-renderPlot({
    data=run4_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    algorithm="Marxan_raw"
    species="swordfish"
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                 breaks=c(-.5,0,.5),
                                                                                                                 limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$Marxan_lbst1 <-renderPlot({
    data=run4_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    algorithm="Marxan_raw"
    species="leatherback"
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                 breaks=c(-.5,0,.5),
                                                                                                                 limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  
  output$EcoRoms_swor2 <-renderPlot({
    data=run5_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    algorithm="EcoROMS_original"
    species="swordfish"
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                       breaks=c(-.5,0,.5),
                                                                                                                       limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$EcoRoms_lbst2 <-renderPlot({
    data=run5_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    algorithm="EcoROMS_original"
    species="leatherback"
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                       breaks=c(-.5,0,.5),
                                                                                                                       limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$Marxan_swor2 <-renderPlot({
    data=run5_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    algorithm="Marxan_raw"
    species="swordfish"
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                 breaks=c(-.5,0,.5),
                                                                                                                 limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$Marxan_lbst2 <-renderPlot({
    data=run5_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,1.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    algorithm="Marxan_raw"
    species="leatherback"
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                 breaks=c(-.5,0,.5),
                                                                                                                 limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  
  output$EcoRoms_swor3 <-renderPlot({
    data=run6_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    algorithm="EcoROMS_original"
    species="swordfish"
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                       breaks=c(-.5,0,.5),
                                                                                                                       limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$EcoRoms_lbst3 <-renderPlot({
    data=run6_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    algorithm="EcoROMS_original"
    species="leatherback"
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=EcoROMS_original),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                       breaks=c(-.5,0,.5),
                                                                                                                       limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$Marxan_swor3 <-renderPlot({
    data=run6_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    algorithm="Marxan_raw"
    species="swordfish"
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                 breaks=c(-.5,0,.5),
                                                                                                                 limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  output$Marxan_lbst3 <-renderPlot({
    data=run6_real
    sworDat=data[data$sp=="swor",]
    lbstDat=data[data$sp=="lbst",]
    
    ER_weightings<-c(-0.1,-0.1,-0.05,-2.5,2.5)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    algorithm="Marxan_raw"
    species="leatherback"
    subtitle=paste0(namesrisk[1],": ",M_weightings[1],", ",namesrisk[2],": ",M_weightings[2],", ",namesrisk[3],": ",M_weightings[3],", ",namesrisk[4],": ",M_weightings[4],", ",namesrisk[5],": ",M_weightings[5])
    a=ggplot()+geom_point(data=lbstDat,aes(x=swor,y=lbst,color=Marxan_raw),size=1,shape=1)+scale_color_gradientn(colours=rainbow(7),na.value = "transparent",
                                                                                                                 breaks=c(-.5,0,.5),
                                                                                                                 limits=c(-1,1))
    a=a+ggtitle(label = paste0("Relationship between swor and lbst probability of presence and ",algorithm," predictions: ",species," data"),subtitle = subtitle)+labs(x="Swordfish probability of presence")+labs(y=paste0("Leatherback probability of presence"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) 
    a
  })
  
  
})

# Run the application 
shinyApp(ui = ui, server = server)

