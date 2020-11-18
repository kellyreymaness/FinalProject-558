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
                             mainPanel(h3("Some other text about the app goes here"))
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
                
                tabPanel("Principal Components Analysis"),
                
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
                
                tabPanel("User Section")
    )
))