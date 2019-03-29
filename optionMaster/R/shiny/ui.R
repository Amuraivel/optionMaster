#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
navbarPage("optionMaster",
           tabPanel(
             # Give the page a title
             titlePanel("Asset Forecast"),
             
             # Generate a row with a sidebar
             sidebarLayout(
               # Define the sidebar with one input
               sidebarPanel(
                 helpText("Joint Bayesian forecast of all major option-tradable assets."),
                 hr(),
                 selectInput("asset", "Asset:",
                             choices = tradableAssets)
               ),
               
               # Create a spot for the barplot
               mainPanel(
                 # Output: Header + summary of distribution ----
                 h4("Price Forecast"),
                 plotOutput("assetPlot"),
                 # Output: Header + table of distribution ----
                 h4("Volatility Forecast"),
                 plotOutput("assetDensityPlot"),
                 h4("Distribution of Returns")
               )
             )
           ),
           tabPanel(
             titlePanel("Capital Efficiency"),
             
              mainPanel(
               h4("Margin/theta")
              )

           ),
           tabPanel(
             titlePanel("Risk Management"),
             mainPanel(
               h4("Factor estimated exposure")
             )
           ),
           tabPanel(
             titlePanel("Trades"),
             mainPanel(
              h4("Free Trades"),
              h4("Index Volatility Arbitrage")
             )
           ),
           tabPanel(
             titlePanel("Command Center"),
             mainPanel(
               actionButton("button", "Initialize Database"),
               actionButton("button", "Refresh Asset Data")
             )
           ),
           tabPanel(
             titlePanel("Client Accounts"),
             mainPanel(
               h4("Action")
             )
           )
          
           
  )
