#User interface of Shiny app for ST558 Final Project (Fall 2020)


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # App title
    titlePanel(strong("Football Data Analysis")),
    
    # Sidebar with a slider input for number of bins
    tabsetPanel(type="pill",
                
                tabPanel("Introduction",
                         sidebarLayout(
                             sidebarPanel(
                                 h3(strong("About the Data")),
                                 h5(strong("Description:"), "The data used in this application 
                                 includes general NFL player statistics as well as their associated 
                                season-long Fantasy points for PPR scoring leagues."),
                                 h5(strong("Data Type(s):"), "Numeric, Categorical"),
                                 h5(strong("Variables:")), 
                                 h5("*Player: player's name"), 
                                 h5("*Tm: team name"),
                                 h5("*Pos: position played"),
                                 h5("*Age: player's age"),
                                 h5("*G: # games player played in"),
                                 h5("*GS: # game player started in"),
                                 h5("*PassCmp: # of passes completed"),
                                 h5("*PassAtt: # of passes attempted"),
                                 h5("*PassYds: # of passing yards"),
                                 h5("*IntThrown: # of interceptions thrown"),
                                 h5("*RushAtt: # of rushing attempts made"),
                                 h5("*RushYds: total rushing yards per player"),
                                 h5("*Tgts: # of targets"),
                                 h5("*Rec: total # of receptions per player"),
                                 h5("*RecYds: total receiving yards per player"),
                                 h5("*YdsPerRec: average yards per reception per player"),
                                 h5("*Fumbles: fumbles per player"),
                                 h5("*FumblesLost: # of fumbles not recovered by the player"),
                                 h5("*PassTD: # of passing touchdowns"),
                                 h5("*RushTD: # of rushing touchdowns"),
                                 h5("*RecTD: # of receiving touchdowns"),
                                 h5("*FantasyPoints: total # points accrued by player in Fantasy Football"),
                                 h5(em("*Opps: opportunities; sum of rushing attempts, passing attempts, & targets^")),
                                 h5(em("*Touches: sum of rushing attempts, receptions, & pass completions^")),
                                 h5(em("*QualPerTouch: quality per touch; sum of receiving, rushing, & passing yards 
                       divided by sum of rushing attempts, receptions, & pass completions^")),
                                 h5(strong("Year:")," 2019"),
                                 h5(strong("Source:"), a(href="https://www.fantasyfootballdatapros.com/csv_files", 
                                                         "Fantasy Football Data Pros")), br(),
                                 h6(em("^Note: The following variables were added by the programmer using data in the source data set:
                       Opps, Touches, & QualPerTouch"))
                             ),
                             mainPanel(h3(strong("About the App")),
                                       h4("The purpose of this application is to provide a simple point-and-click
                                       tool for conducting basic descriptive analysis of NFL player statistics
                                          & generating season-long Fantasy Football points predictions."),
                                       h3(strong("Navigating the App")),
                                       h4("In addition to this page, there are four additional sections 
                                          of this app. Descriptions of each are provided below."),
                                       h5(strong("*Data exploration:"), "This tab includes a graphical summary of 
                                          the relationship between a subset of predictors and the season-long
                                          Fantasy points variable. Additionally, there are some simple numerical
                                          summaries."),
                                       h5(strong("*Principal Components Analysis:"), "The purpose of Principal
                                          Components Analysis, or PCA, is to understand ovearching patterns in
                                          data by identifying a few components that account for the most variation
                                          in the dataset. This tab shows biplots generated from your variable
                                          selection in the left pane. These biplots will reveal how much each
                                          characteristic influences each principal component. The farther away
                                          from the anchor points of the PCs (i.e. imagine a line bisecting the
                                          graph, originating at 0 on both axes), the more that particular factor
                                          influences the PC."),
                                       h5(strong("*Modeling:"), "This tab incorporates two predictive models: 
                                          1) a Multiple Regression Model, and 2) a Random Forest Model. The former
                                          is a linear model that determines the best fit line for the data,
                                          thereby issuing predictions that fall somewhere on this line. The 
                                          latter is a ensemble, tree-based method with typically gives more
                                          precise predictions. You may select variables from the left pane and
                                          select the 'Make Predictions' box to generate projections. 
                                          Give it a try!"),
                                       h5(strong("*Download Data:"), "This section allows the user to
                                          download the based data used for this application. There are two 
                                          options: 1) the full dataset (this includes 26 variables) or 2) a
                                          modidied dataset (includes the 11 variables used throughout the
                                          application).")
                                       )
                         )
                ),
                
                tabPanel("Data Exploration",
                         sidebarLayout(
                             sidebarPanel(
                                 selectizeInput("predictor", "Select a Predictor:", selected = "Opportunities", 
                                                choices = c("Opportunities", "Touches", "Quality Per Touch")),
                                 checkboxInput("position", "Color code data by position?")
                             ),
                             mainPanel(
                                 uiOutput("PlotTitle"),
                                 plotlyOutput("ScatterPlot")
                             )
                         )
                ),
                
                tabPanel("Principal Components Analysis",
                    sidebarLayout(
                        sidebarPanel(
                            h5("Please select a variable below to compare against ", em("Quality Per Touch")),
                            selectizeInput("var", "Variables", selected = "Fumbles Lost", 
                                           choices=c("Fumbles Lost", "Opportunities"))
                    ),
                    mainPanel(
                        uiOutput("BiplotTitle"),
                        plotOutput("BiPlot")
                    ))
                ),
                
                tabPanel("Modeling",
                         sidebarLayout(
                             sidebarPanel(
                                 selectizeInput("pos", "Position:", choices = c("QB", "WR", "TE", "RB")),
                                 numericInput("age", "Player Age:", value = 26, min = 21, max=42),  
                                 numericInput("gamestart", "Game Starts:", value=5, min=1, max=16),
                                 numericInput("fumbles", "Fumbles Lost:", value=0, min=0, max=11),
                                 numericInput("passtd", "Passing Touchdowns:", value=0, min=0, max=36),
                                 numericInput("rushtd", "Rushing Touchdowns:", value=0, min=0, max=16), 
                                 numericInput("rectd", "Receiving Touchdowns:", value=0, min=0, max=11),
                                 sliderInput("opp", "Opportunities:", min=0, max=685, value=87, step=5),
                                 sliderInput("touch", "Touches:", min=0, max=450, value=64, step=25),
                                 sliderInput("quality", "Quality Per Touch:", min=0, max=38, value=9.5, step=2),
                                 actionButton("go", "Make predictions!")
                             ),
                            mainPanel("Sample Text")
                )
                ),
                
                tabPanel("Download Section",
                         sidebarLayout(
                             sidebarPanel(
                                 selectizeInput("dataset", "Select a dataset to download:", 
                                                choices = c("Full dataset", "Modified dataset")),
                                 radioButtons("filetype", "Choose a file format:", choices = c("csv", "tsv")),
                                 downloadButton("dl", "Download")
                             ),
                             mainPanel(
                                 tableOutput("DataTable")
                             )
                         )
    )
)))