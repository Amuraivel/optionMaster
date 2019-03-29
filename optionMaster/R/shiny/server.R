#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
site_colors <- list(red="#FF0000",orange="orange",yellow="goldenrod",green="green",blue="blue",indigo="#4b0082",violet="purple")
tradableAssets <<-  c("OIL","GAS","GOLD","SILVER","CORN","SOY","WHEAT","CATTLE","HOGS","COCOA",
                      "COFFEE","ORANGE","SUGAR","COTTON","SP500","NIKKEI225","ESTX50",
                      "AP200","FTSE100","EEM","BONDS","BUNDS","JGBS","VIX","AUD","CAD","CHF","EUR","GBP","JPY","MXN")
tradableAssets <<- tradableAssets[order(tradableAssets)]

library(shiny)
library(tidyverse)
library(dbplyr)
library(dplyr)


# Define server logic required to draw a histogram
shinyServer(
  # Define a server for the Shiny app
  function(input, output) {
    DB <- dplyr::src_mysql("MARKET_DATA",
                           host = "localhost",
                           port = 3306,
                           user = "trade_master",
                           password = "jan27")
    db_table <- tbl(DB$con,"arete_forecast") %>%
      filter(asset %in% tradableAssets)



    # Fill in the spot we created for a plot
    output$assetPlot <- renderPlot({
      tmp <- db_table %>%
        filter(asset==input$asset) %>%
        select(-asset) %>%
        select(1,5) %>%
        transform(date = as.Date(date)) %>%
        as.data.frame()

      # plot.ts(tmp$date- Sys.Date(),tmp$X50.,
      #         main=input$asset,
      #         ylab="Price",
      #         xlab=paste0("Forecast date=",tmp$date[1],"+ t"))
      ggplot(tmp, aes(date,X50.)) +
        geom_point() +
        labs(title =input$asset, x = "Time", y = "Price") +
        geom_smooth(method ="lm", color="green") +
        #geom_rug(sides = "l")+
        scale_color_gradient()
    })

     output$assetDensityPlot <- renderPlot({
       tmp <- db_table %>%
         filter(asset==input$asset) %>%
         select(-asset) %>%
         select(1,5) %>%
         transform(date = as.Date(date)) %>%
         as.data.frame()

    # # Fill in
     plot(density(tmp$X50.),
          main=input$asset,
          ylab="Forecasted PDF",
          xlab="Price")
       abline(v=quantile(tmp$X50.,.16),col=site_colors$orange)
       abline(v=quantile(tmp$X50.,.5),col=site_colors$green)
       abline(v=quantile(tmp$X50.,1-.16),col=site_colors$blue)
       legend("topright",legend=c("-1 sd","median","+1 sd"),col=c(site_colors$orange,site_colors$green,site_colors$blue),lty=1)
       })
     
     output$assetForecastDensityPlot <- renderPlot({
       tmp <- db_table %>%
         filter(asset=="OIL") %>%
         select(-asset) %>%
         select(1,5) %>%
         transform(date = as.Date(date)) %>%
         as.data.frame()
        
       
        library(xts)
       series <- xts(tmp$X50., order.by = tmp$date)
        tmp$X50. <- log(tmp$X50.)
        
        plot(density(diff(tmp$X50.)))
       
       })
     


      

  }


)


