#Server logic of Shiny app for ST558 Final Project (Fall 2020)

#Read in relevant packages
library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(plotly)
library(caret)

#Read in data, create new variables, complete other data cleaning/segmentation tasks
ffData <- read_csv(file="ff2019.csv")
ffData <- ffData %>% mutate(Opps = (RushAtt + Tgt + PassAtt)) %>% 
    mutate(Touches = (RushAtt + Rec + PassCmp)) %>% 
    mutate(QualPerTouch = ((RecYds + RushYds + PassYds)/(RushAtt + Rec + PassCmp)))
ffData <- na.exclude(ffData)

PC1 <- prcomp(select(ffData, QualPerTouch, FumblesLost), scale= TRUE)
PC2 <- prcomp(select(ffData, QualPerTouch, Opps), scale= TRUE)

FullData <- ffData
ModifiedData <- ffData %>% select(Player, Pos, Age, GS, FumblesLost, PassTD, 
                                  RushTD, RecTD, Opps, Touches, QualPerTouch)

# Define server logic 
shinyServer(function(session, input, output) {
    
    #Create Scatterplots, DATA EXPLORATION TAB
    output$ScatterPlot <- renderPlotly({
        if(input$predictor=="Opportunities" & input$position==0) {
            plot_ly(data=ffData, x=~FantasyPoints, y=~Opps)
        } else if (input$predictor=="Opportunities" & input$position==1) {
            plot_ly(data=ffData, x=~FantasyPoints, y=~Opps, color = ~Pos)
        } else if(input$predictor=="Touches" & input$position==0) {
            plot_ly(data=ffData, x=~FantasyPoints, y=~Touches)
        } else if(input$predictor=="Touches" & input$position==1) {
            plot_ly(data=ffData, x=~FantasyPoints, y=~Touches, color = ~Pos)
        } else if(input$predictor=="Quality Per Touch" & input$position==0) {
            plot_ly(data=ffData, x=~FantasyPoints, y=~QualPerTouch)
        } else {plot_ly(data=ffData, x=~FantasyPoints, y=~QualPerTouch, color = ~Pos)
        }
    })
    
    #Create dynamic title for Scatterplots, DATA EXPLORATION TAB
    output$PlotTitle <- renderUI({
        if(input$predictor=="Opportunities") {
            h4(strong("Scatterplot: Opportunities vs. Fantasy Points"))
        } else if (input$predictor=="Touches") {
            h4(strong("Scatterplot: Touches vs. Fantasy Points"))
        } else {h4(strong("Scatterplot: Quality Per Touch vs. Fantasy Points"))}
    })
    
    #Create Numeric Summaries, DATA EXPLORATION TAB
    output$NumSumm <- renderPrint({
        if (input$predictor=="Opportunities") {
            summary(ffData$Opps)
        } else if (input$predictor=="Touches") {
            summary(ffData$Touches)
        } else {summary(ffData$QualPerTouch)}
    })
    
    #Create biplots for PCA TAB
    output$BiPlot <- renderPlot({
        if (input$var=="Fumbles Lost") {
            biplot(PC1, cex = 1.1, xlabs=rep(".", nrow(ffData)))
        } else {biplot(PC2, cex=1.1, xlabs=rep(".", nrow(ffData)))}
    })
    
    #Create dynamic title for Biplots, PCA TAB
    output$BiplotTitle <- renderUI({
        if(input$var=="Fumbles Lost") {
            h4(strong("Biplot: Fumbles Lost & Quality Per Touch"))
        } else {h4(strong("Biplot: Opportunities & Quality Per Touch"))}
    })
    
    # Create logic for DATA DOWNLOAD Tab
    datasetInput <- reactive({
        switch(input$dataset,
               "Full dataset" = FullData,
               "Modified dataset" = ModifiedData)
    })
    
    output$DataTable <- renderTable({
        datasetInput()
    })
    
    output$dl <- downloadHandler(
        filename = function() {
            paste(input$dataset, input$filetype, sep=".")},
        content = function(file) {
            part <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
        write.table(datasetInput(), file, sep = part,
                        row.names = FALSE)
        }
    )
    
    #### MODELING TAB  
    TrainIndex <- createDataPartition(ffData$FantasyPoints, p=0.7, list=FALSE)
    TrainData <- ffData[TrainIndex, ]
    TestData <- ffData[-TrainIndex, ]
    
    
    # Model 1 – Multiple Linear Regression, MODELING TAB
    observeEvent(input$go, {
        userinput <- data.frame(Pos=input$pos,
                                Age=input$age,
                                GS=input$gamestart,
                                FumblesLost=input$fumbles,
                                PassTD=input$passtd,
                                RushTD=input$rushtd,
                                RecTD=input$rectd,
                                Opps=input$opp,
                                Touches=input$touch,
                                QualPerTouch=input$quality)
        
        
        LMFit <- train(FantasyPoints ~ Pos + Age + GS + FumblesLost + PassTD + RushTD + RecTD +
                           Opps + Touches + QualPerTouch,
                       data=TrainData,
                       method="lm",
                       preProcess=c("center", "scale"),
                       trControl = trainControl(method="cv", number = 10))
        
        
        LMPredict <- predict(LMFit, newdata = userinput)
        
    })
    
    output$ModelLM <- renderText({
        paste(LMPredict())
    })
    
    
    # Model 2 - Random Forest, MODELING TAB
    
    observeEvent(input$go, {
        
        userinput <- data.frame(Pos=input$pos,
                                Age=input$age,
                                GS=input$gamestart,
                                FumblesLost=input$fumbles,
                                PassTD=input$passtd,
                                RushTD=input$rushtd,
                                RecTD=input$rectd,
                                Opps=input$opp,
                                Touches=input$touch,
                                QualPerTouch=input$quality)
        
        RFFit <- train(FantasyPoints ~ Pos + Age + GS + FumblesLost + PassTD + RushTD + RecTD +
                           Opps + Touches + QualPerTouch,
                       data=TrainData,
                       method="rf",
                       trControl=trainControl(method="cv", number = 10))
        
        RFPredict <- predict(RFFit, newdata=userinput)
        
    })
    
    output$ModelRF <- renderText({
       paste(RFPredict())
    })
    

})
