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
ui <- dashboardPage(skin="green",
                    dashboardHeader(title="EcoCast 2.0 hindcast explorer"
                      ),
                    dashboardSidebar(
                      sidebarMenu(id = 'sidebarmenu',
                                  menuItem("Adjust parameter", tabName='parameters',icon=icon("sliders",lib='font-awesome')),
                                        div(style="background-color:black;",
                                        sliderInput("presence", "Presence threshold", 0,1,.5,step=.1),                          
                                        sliderInput("algorithm", "Algorithm threshold", -1,1,0,step=.1)
                                        )
                      )),

     dashboardBody(
       fluidRow(h3("Extreme LBST, neutral SWOR"),
         column(width=4,plotOutput("EcoRoms_1")),
         column(width=4,plotOutput("Marxan_1")),
         column(width=4,DTOutput("table_1"))),
         
       fluidRow(h3("Extreme LBST, moderate SWOR"),
          column(width=4,plotOutput("EcoRoms_2")),
          column(width=4,plotOutput("Marxan_2")),
          column(width=4,DTOutput("table_2"))),
                  
       fluidRow(h3("Extreme LBST, extreme SWOR"),
          column(width=4,plotOutput("EcoRoms_3")),
          column(width=4,plotOutput("Marxan_3")),
          column(width=4,DTOutput("table_3")))
            
       )
     )
            
            
#####


server <- shinyServer(function(input, output) {
  
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
  
})

# Run the application 
shinyApp(ui = ui, server = server)

