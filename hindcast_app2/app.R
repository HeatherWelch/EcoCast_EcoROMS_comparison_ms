#
# This is a Shiny web application. You can run the application by clicking

##### Defining global objects####
# source functions
source("2_load_libraries.R")
namesrisk<-c("Blue shark bycatch","Blue sharks","Sea lions","Leatherbacks","Swordfish")

# read in raw data 
run4_random=read.csv("data/species_predict_05.01.18_random_run4.csv") %>% .[1:1698,]
run5_random=read.csv("data/species_predict_05.01.18_random_run5.csv") %>% .[1:1698,]
run6_random=read.csv("data/species_predict_05.01.18_random_run6.csv") %>% .[1:1698,]

run4_random_scaling=read.csv("data/species_predict_05.02.18_random_scaled_unscaled_run4.csv") %>% .[1:1698,]
run5_random_scaling=read.csv("data/species_predict_05.02.18_random_scaled_unscaled_run5.csv") %>% .[1:1698,]
run6_random_scaling=read.csv("data/species_predict_05.02.18_random_scaled_unscaled_run6.csv") %>% .[1:1698,]

##### UI code

# Define UI for application ####
ui <- dashboardPage(skin="yellow",
                    dashboardHeader(title="EcoCast 2.0 hindcast explorer"
                      ),
                    dashboardSidebar(
                      sidebarMenu(id = 'sidebarmenu',
                                  
                                  ######
                                  menuItem("Set weightings by catch limits", tabName='limits',icon=icon("random",lib='font-awesome')),
                                  conditionalPanel("input.sidebarmenu==='limits'",
                                                   div(style="background-color:black;",
                                                       sliderInput("presenceLimits", "Presence threshold", 0,1,.5,step=.1),
                                                       selectInput(
                                                         "select",
                                                         label = "limit type",
                                                         choices = c("Avoided leatherback bycatch","Available swordfish catch"),
                                                         selected="Avoided leatherback bycatch"
                                                       )),
                                                       conditionalPanel("input.select=='Avoided leatherback bycatch'",
                                                         div(style="background-color:black;",
                                                         numericInput("avoided","% avoided",value = 50,min=0,max=100,step=10))),
                                                       conditionalPanel("input.select=='Available swordfish catch'",
                                                         div(style="background-color:black;",
                                                         numericInput("caught","% available to catch",value = 50,min=0,max=100,step=10)))
                                                       ),
                                  
                                  menuItem("Set weightings manually", tabName='random',icon=icon("random",lib='font-awesome')),
                                  conditionalPanel("input.sidebarmenu==='random'",
                                                   div(style="background-color:black;",
                                                       sliderInput("presence", "Presence threshold", 0,1,.5,step=.1),                          
                                                       sliderInput("algorithmE", "EcoCast algorithm threshold", -1,1,0,step=.1),
                                                       sliderInput("algorithmM", "Marxan algorithm threshold", -1,1,0,step=.1))),
                                  
                                  menuItem("Random data: swor vs lbst", tabName='random_ratio',icon=icon("random",lib='font-awesome')),
                                  conditionalPanel("input.sidebarmenu==='raw'"),
                                  

                                  menuItem("EcoROMS scaled and unscaled comparison", tabName='scaling',icon=icon("random",lib='font-awesome')),

                                  #####
                                  
                                  menuItem("EcoROMS scaled and unscaled", tabName='scaling',icon=icon("random",lib='font-awesome')),
                                  menuItem("EcoROMS scaled and unscaled", tabName='scaling',icon=icon("random",lib='font-awesome')),
                                  conditionalPanel("input.sidebarmenu==='scaling'",
                                                   div(style="background-color:black;",
                                                       sliderInput("presenceScaling", "Presence threshold", 0,1,.5,step=.1),
                                                       selectInput(
                                                         "selectScaling",
                                                         label = "limit type",
                                                         choices = c("Avoided leatherback bycatch","Available swordfish catch"),
                                                         selected="Avoided leatherback bycatch"
                                                       )),
                                                   conditionalPanel("input.selectScaling=='Avoided leatherback bycatch'",
                                                                    div(style="background-color:black;",
                                                                        numericInput("avoidedScaling","% avoided",value = 50,min=0,max=100,step=10))),
                                                   conditionalPanel("input.selectScaling=='Available swordfish catch'",
                                                                    div(style="background-color:black;",
                                                                        numericInput("caughtScaling","% available to catch",value = 50,min=0,max=100,step=10)))
                                  )
                                  
                      )),

     dashboardBody(
       tabItems(
       
         #####
         
       tabItem(tabName = "limits",h2("Weightings set by catch limits"),
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
       
       tabItem(tabName = "random",h2("Weightings set manually"),
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
       
       #####
       
       tabItem(tabName = "scaling",h2("EcoROMS scaled (original) and unscaled comparison"),
               fluidRow(h3("Extreme LBST, neutral SWOR"),
                        column(h4("EcoROMS scaled"),width=4,plotOutput("EcoRoms_1c")),
                        column(h4("EcoROMS unscaled"),width=4,plotOutput("Marxan_1c")),
                        column(h4("Quantitative comparison"),width=4,DTOutput("table_1c"))),
               
               fluidRow(h3("Extreme LBST, moderate SWOR"),
                        column(h4("EcoROMS scaled"),width=4,plotOutput("EcoRoms_2c")),
                        column(h4("EcoROMS unscaled"),width=4,plotOutput("Marxan_2c")),
                        column(h4("Quantitative comparison"),width=4,DTOutput("table_2c"))),
               
               fluidRow(h3("Extreme LBST, extreme SWOR"),
                        column(h4("EcoROMS scaled"),width=4,plotOutput("EcoRoms_3c")),
                        column(h4("EcoROMS unscaled"),width=4,plotOutput("Marxan_3c")),
                        column(h4("Quantitative comparison"),width=4,DTOutput("table_3c")))
       )
            
       ))
     )
            
            
#####


server <- shinyServer(function(input, output) {
  
  ## weightings set via limits ####  
  thresholdTurt=reactive(input$avoided/100)
  thresholdSwor=reactive(1-(input$caught/100))
  
  algorithm=reactive({
  if(input$select=="Avoided leatherback bycatch"){algorithm=thresholdTurt()}
  if(input$select=="Available swordfish catch"){algorithm=thresholdSwor()}
    return(algorithm)
  })
  
  bin_run4_EcoROMS=reactive({
    data=run4_random
    if(input$select=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
      }
    if(input$select=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run4_Marxan=reactive({
    data=run4_random
    if(input$select=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$Marxan_raw,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$select=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$Marxan_raw,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run5_EcoROMS=reactive({
    data=run5_random
    if(input$select=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$select=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run5_Marxan=reactive({
    data=run5_random
    if(input$select=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$Marxan_raw,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$select=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$Marxan_raw,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run6_EcoROMS=reactive({
    data=run6_random
    if(input$select=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$select=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run6_Marxan=reactive({
    data=run6_random
    if(input$select=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$Marxan_raw,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$select=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% filter(suitability>=input$presenceLimits) %>% spread(species,suitability) %>% select(EcoROMS_original,Marxan_raw,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$Marxan_raw,algorithm(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  
  output$EcoRoms_1a <- renderPlot({
    # get raw data organized
    data=run4_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
   
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presenceLimits
    master$algorithmVal=bin_run4_EcoROMS()
    
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
  output$Marxan_1a <-renderPlot({
    data=run4_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presenceLimits
    master$algorithmVal=bin_run4_Marxan()
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="Marxan_raw"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=Marxan_raw))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
    
  })
  output$table_1a <-renderDT({
    data=run4_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    # set up to plot
    
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceLimits) %>% filter(product_value>=bin_run4_EcoROMS()) %>% 
      filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceLimits) %>% filter(product_value>=bin_run4_Marxan()) %>%
      filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceLimits) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3)) %>% 
      mutate(E2Mratio=EcoROMS_original/Marxan_raw) %>% mutate(E2Mratio=round(E2Mratio,3)) %>% as.data.frame %>% add_row(species="Algorithm threshold",EcoROMS_original=round(bin_run4_EcoROMS(),3),Marxan_raw=round(bin_run4_Marxan(),3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                        
    
  })
  
  output$EcoRoms_2a <- renderPlot({
    # get raw data organized
    data=run5_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presenceLimits
    master$algorithmVal=bin_run5_EcoROMS()
    
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
  output$Marxan_2a <-renderPlot({
    data=run5_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presenceLimits
    master$algorithmVal=bin_run5_Marxan()
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="Marxan_raw"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=Marxan_raw))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
    
  })
  output$table_2a <-renderDT({
    data=run5_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    # set up to plot
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceLimits) %>% filter(product_value>=bin_run5_EcoROMS()) %>% 
      filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceLimits) %>% filter(product_value>=bin_run5_Marxan()) %>%
      filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceLimits) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3)) %>% 
      mutate(E2Mratio=EcoROMS_original/Marxan_raw) %>% mutate(E2Mratio=round(E2Mratio,3)) %>% as.data.frame %>% add_row(species="Algorithm threshold",EcoROMS_original=round(bin_run5_EcoROMS(),3),Marxan_raw=round(bin_run5_Marxan(),3))
    
    datatable(tabletotal,caption = "% of presences caught")    
  })
  
  output$EcoRoms_3a <- renderPlot({
    # get raw data organized
    data=run6_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presenceLimits
    master$algorithmVal=bin_run6_EcoROMS()
    
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
  output$Marxan_3a <-renderPlot({
    data=run6_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presenceLimits
    master$algorithmVal=bin_run6_Marxan()
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="Marxan_raw"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=Marxan_raw))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
    
  })
  output$table_3a <-renderDT({
    data=run6_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    # set up to plot
    
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceLimits) %>% filter(product_value>=bin_run6_EcoROMS()) %>% 
      filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceLimits) %>% filter(product_value>=bin_run6_Marxan()) %>%
      filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceLimits) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3)) %>% 
      mutate(E2Mratio=EcoROMS_original/Marxan_raw) %>% mutate(E2Mratio=round(E2Mratio,3)) %>% as.data.frame %>% add_row(species="Algorithm threshold",EcoROMS_original=round(bin_run6_EcoROMS(),3),Marxan_raw=round(bin_run6_Marxan(),3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                     
    
  })
  
  ## weightings set manually ####
  output$EcoRoms_1 <- renderPlot({
    # get raw data organized
    data=run4_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmE
    
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmM
    
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    # set up to plot
    
    # tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=presence) %>% filter(product_value>=algorithmE) %>% 
    #   filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    # 
    # tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=presence) %>% filter(product_value>=algorithmM) %>%
    #   filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    # 
    # tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=presence) %>%
    #   group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))
    
    
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% filter(product_value>=input$algorithmE) %>% 
      filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% filter(product_value>=input$algorithmM) %>%
      filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3)) %>% 
      mutate(E2Mratio=EcoROMS_original/Marxan_raw) %>% mutate(E2Mratio=round(E2Mratio,3))
    
    # 
    # tablecaught=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% filter(product_value>=input$algorithm) %>% 
    #   group_by(species,product) %>% summarise(num_presences_caught=n())
    # 
    # tabletotal=data %>% select(-c(X,lon,lat,dt,presenceVal,algorithmVal))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% 
    #   group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaught,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                  
    
  })
  
  output$EcoRoms_2 <- renderPlot({
    # get raw data organized
    data=run5_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmE
    
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmM
    
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    # set up to plot
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% filter(product_value>=input$algorithmE) %>% 
      filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% filter(product_value>=input$algorithmM) %>%
      filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3)) %>% 
      mutate(E2Mratio=EcoROMS_original/Marxan_raw) %>% mutate(E2Mratio=round(E2Mratio,3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                  
    
  })
  
  output$EcoRoms_3 <- renderPlot({
    # get raw data organized
    data=run6_random
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmE
    
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,Marxan_raw))
    master$presenceVal=input$presence
    master$algorithmVal=input$algorithmM
    
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    # set up to plot
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% filter(product_value>=input$algorithmE) %>% 
      filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>% filter(product_value>=input$algorithmM) %>%
      filter(product=="Marxan_raw")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,Marxan_raw)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presence) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(Marxan_raw=round(Marxan_raw,3)) %>% 
      mutate(E2Mratio=EcoROMS_original/Marxan_raw) %>% mutate(E2Mratio=round(E2Mratio,3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                  
    
  })
  
  
  ## randome ratio ####
  output$EcoRoms_1b <-renderPlot({
  data=run4_random
  ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
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
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
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

  
  ## EcoROMS scaled and unscaled comparison ####  
  thresholdTurtS=reactive(input$avoidedScaling/100)
  thresholdSworS=reactive(1-(input$caughtScaling/100))
  
  algorithmS=reactive({
    if(input$selectScaling=="Avoided leatherback bycatch"){algorithmS=thresholdTurtS()}
    if(input$selectScaling=="Available swordfish catch"){algorithmS=thresholdSworS()}
    return(algorithmS)
  })
  
  bin_run4_EcoROMSscaling=reactive({
    data=run4_random_scaling
    if(input$selectScaling=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$selectScaling=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run4_EcoROMSunscaling=reactive({
    data=run4_random_scaling
    if(input$selectScaling=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original_unscaled,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$selectScaling=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original_unscaled,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run5_EcoROMSscaling=reactive({
    data=run5_random_scaling
    if(input$selectScaling=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$selectScaling=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run5_EcoROMSunscaling=reactive({
    data=run5_random_scaling
    if(input$selectScaling=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original_unscaled,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$selectScaling=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original_unscaled,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run6_EcoROMSscaling=reactive({
    data=run6_random_scaling
    if(input$selectScaling=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$selectScaling=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  bin_run6_EcoROMSunscaling=reactive({
    data=run6_random_scaling
    if(input$selectScaling=="Avoided leatherback bycatch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,lbst) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original_unscaled,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    if(input$selectScaling=="Available swordfish catch"){
      binA=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% filter(suitability>=input$presenceScaling) %>% spread(species,suitability) %>% select(EcoROMS_original,EcoROMS_original_unscaled,swor) %>% .[complete.cases(.),]
      bin=quantile(binA$EcoROMS_original_unscaled,algorithmS(),na.rm = T) %>% as.data.frame() %>% .[,1]
    }
    return(bin)
  })
  
  output$EcoRoms_1c <- renderPlot({
    # get raw data organized
    data=run4_random_scaling
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,EcoROMS_original_unscaled))
    master$presenceVal=input$presenceScaling
    master$algorithmVal=bin_run4_EcoROMSscaling()
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="^EcoROMS_original$"
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
  output$Marxan_1c <-renderPlot({
    data=run4_random_scaling
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,EcoROMS_original_unscaled))
    master$presenceVal=input$presenceScaling
    master$algorithmVal=bin_run4_EcoROMSunscaling()
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="EcoROMS_original_unscaled"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original_unscaled))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
    
  })
  output$table_1c <-renderDT({
    data=run4_random_scaling
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.1)
    # set up to plot
    
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceScaling) %>% filter(product_value>=bin_run4_EcoROMSscaling()) %>% 
      filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceScaling) %>% filter(product_value>=bin_run4_EcoROMSunscaling()) %>%
      filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceScaling) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(EcoROMS_original_unscaled=round(EcoROMS_original_unscaled,3)) %>% 
      mutate(E2Mratio=EcoROMS_original/EcoROMS_original_unscaled) %>% mutate(E2Mratio=round(E2Mratio,3)) %>% as.data.frame %>% add_row(species="Algorithm threshold",EcoROMS_original=round(bin_run4_EcoROMSscaling(),3),EcoROMS_original_unscaled=round(bin_run4_EcoROMSunscaling(),3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                        
    
  })
  
  output$EcoRoms_2c <- renderPlot({
    # get raw data organized
    data=run5_random_scaling
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,EcoROMS_original_unscaled))
    master$presenceVal=input$presenceScaling
    master$algorithmVal=bin_run5_EcoROMSscaling()
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="^EcoROMS_original$"
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
  output$Marxan_2c <-renderPlot({
    data=run5_random_scaling
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,EcoROMS_original_unscaled))
    master$presenceVal=input$presenceScaling
    master$algorithmVal=bin_run5_EcoROMSunscaling()
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="EcoROMS_original_unscaled"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original_unscaled))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
    
  })
  output$table_2c <-renderDT({
    data=run5_random_scaling
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.2)
    # set up to plot
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceScaling) %>% filter(product_value>=bin_run5_EcoROMSscaling()) %>% 
      filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceScaling) %>% filter(product_value>=bin_run5_EcoROMSunscaling()) %>%
      filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceScaling) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(EcoROMS_original_unscaled=round(EcoROMS_original_unscaled,3)) %>% 
      mutate(E2Mratio=EcoROMS_original/EcoROMS_original_unscaled) %>% mutate(E2Mratio=round(E2Mratio,3)) %>% as.data.frame %>% add_row(species="Algorithm threshold",EcoROMS_original=round(bin_run5_EcoROMSscaling(),3),EcoROMS_original_unscaled=round(bin_run5_EcoROMSunscaling(),3))
    
    datatable(tabletotal,caption = "% of presences caught")    
  })
  
  output$EcoRoms_3c <- renderPlot({
    # get raw data organized
    data=run6_random_scaling
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,EcoROMS_original_unscaled))
    master$presenceVal=input$presenceScaling
    master$algorithmVal=bin_run6_EcoROMSscaling()
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="^EcoROMS_original$"
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
  output$Marxan_3c <-renderPlot({
    data=run6_random_scaling
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    
    master=data %>% gather(sp_name,value,-c(X,lon,lat,dt,EcoROMS_original,EcoROMS_original_unscaled))
    master$presenceVal=input$presenceScaling
    master$algorithmVal=bin_run6_EcoROMSunscaling()
    
    sworDat=master[master$sp_name=="swor",]
    caslDat=master[master$sp_name=="casl",]
    lbstDat=master[master$sp_name=="lbst",]
    blshobsDat=master[master$sp_name=="blshobs",]
    blshtrkDat=master[master$sp_name=="blshtrk",]
    
    algorithm="EcoROMS_original_unscaled"
    index=NULL
    index=grep(algorithm,names(master))
    subtitle=paste0(namesrisk[1],": ",ER_weightings[1],", ",namesrisk[2],": ",ER_weightings[2],", ",namesrisk[3],": ",ER_weightings[3],", ",namesrisk[4],": ",ER_weightings[4],", ",namesrisk[5],": ",ER_weightings[5])
    a=ggplot()+geom_point(data=sworDat,aes(x=value,y=sworDat[,index],color="SWOR"),size=.5,shape=1)
    a=a+geom_point(data=blshobsDat,aes(x=value,y=blshobsDat[,index],color="BLSH obs"),size=.5,shape=1)
    a=a+geom_point(data=blshtrkDat,aes(x=value,y=blshtrkDat[,index],color="BLSH trk"),size=.5,shape=1)
    a=a+geom_point(data=lbstDat,aes(x=value,y=lbstDat[,index],color="LBST"),size=.5,shape=1)
    a=a+geom_point(data=caslDat,aes(x=value,y=caslDat[,index],color="CASL"),size=.5,shape=1)
    a=a+geom_line(data=master,aes(x=value,y=algorithmVal))
    a=a+geom_line(data=master,aes(x=presenceVal,y=EcoROMS_original_unscaled))
    a=a+ggtitle(label = paste0("Relationship between species probability of presence and ",algorithm," predictions"),subtitle = subtitle)+labs(x="Probability of presence")+labs(y=paste0(algorithm," prediction"))+theme(panel.background = element_blank())+ theme(axis.line = element_line(colour = "black"))+ theme(text = element_text(size=8))
    a=a+scale_color_manual("",values=c("SWOR"="goldenrod","BLSH obs"="gray","BLSH trk"="gray47","LBST"="chartreuse4","CASL"="coral3"))
    a=a+guides(fill=guide_legend(title="Species"))+theme(legend.title = element_text(size=6),legend.position=c(.99,.45),legend.justification = c(.9,.9))+theme(legend.background = element_blank())+theme(legend.text=element_text(size=6),legend.box.background = element_rect(colour = "black"))+ theme(legend.key=element_blank()) +guides(color=guide_legend(override.aes = list(shape=c(1,1,1,1,1))))
    a
    
  })
  output$table_3c <-renderDT({
    data=run6_random_scaling
    ER_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    M_weightings<-c(-0.1,-0.1,-0.05,-0.4,0.4)
    # set up to plot
    
    tablecaughtE=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceScaling) %>% filter(product_value>=bin_run6_EcoROMSscaling()) %>% 
      filter(product=="EcoROMS_original")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) 
    
    tablecaughtM=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceScaling) %>% filter(product_value>=bin_run6_EcoROMSunscaling()) %>%
      filter(product=="EcoROMS_original_unscaled")%>% group_by(species,product) %>% summarise(num_presences_caught=n()) %>% rbind(.,tablecaughtE)
    
    tabletotal=data %>% select(-c(X,lon,lat,dt))%>% gather(species,suitability,-c(EcoROMS_original,EcoROMS_original_unscaled)) %>% gather(product,product_value,-c(species,suitability)) %>% filter(suitability>=input$presenceScaling) %>%
      group_by(species,product) %>% summarise(num_presences=n()) %>% left_join(tablecaughtM,.) %>% mutate(Percent_caught=num_presences_caught/num_presences*100) %>% select(-c(num_presences,num_presences_caught)) %>% spread(product,Percent_caught) %>% mutate(EcoROMS_original=round(EcoROMS_original,3))%>% mutate(EcoROMS_original_unscaled=round(EcoROMS_original_unscaled,3)) %>% 
      mutate(E2Mratio=EcoROMS_original/EcoROMS_original_unscaled) %>% mutate(E2Mratio=round(E2Mratio,3)) %>% as.data.frame %>% add_row(species="Algorithm threshold",EcoROMS_original=round(bin_run6_EcoROMSscaling(),3),EcoROMS_original_unscaled=round(bin_run6_EcoROMSunscaling(),3))
    
    datatable(tabletotal,caption = "% of presences caught")                                                                                                                                                                                                                     
    
  })
  
  
})

# Run the application 
shinyApp(ui = ui, server = server)

