#Server logic of Shiny app for ST558 Final Project (Fall 2020)

#Read in relevant packages
library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(plotly)
library(caret)

#Read in data & create 4 new variables
ffData <- read_csv(file="ff2019.csv")
ffData <- ffData %>% mutate(Opps = (RushAtt + Tgt + PassAtt)) %>% 
    mutate(Touches = (RushAtt + Rec + PassCmp)) %>% 
    mutate(QualPerTouch = ((RecYds + RushYds + PassYds)/(RushAtt + Rec + PassCmp)))
ffData <- na.exclude(ffData)

# Define server logic 
shinyServer(function(session, input, output) {
    
    #Create Scatterplots
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
    
    #Create dynamic title for Scatterplots
    output$PlotTitle <- renderUI({
        if(input$predictor=="Opportunities") {
            h4(strong("Scatterplot: Opportunities vs. Fantasy Points"))
        } else if (input$predictor=="Touches") {
            h4(strong("Scatterplot: Touches vs. Fantasy Points"))
        } else {h4(strong("Scatterplot: Quality Per Touch vs. Fantasy Points"))}
    })
    

})
