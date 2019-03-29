
library(IBrokers)
library(stringr)

ibConnection <- twsConnect(clientId = 1, host = 'localhost', 
                   port = 7496, verbose = TRUE, timeout = 5,
                   filename = NULL)

root_path <- "/Users/mark/Favourites/Investing/optionMaster/optionMaster"
#' DOW Vol-Arb Strategy
#' @param DB an initialized DB connection
#' @param ibConnection An ibConnection
#' @export 
dow_strategy <- function(DB=DB, ibConection=ibConnection){
  dow_symbols <- read.csv2(paste0(root_path,"/data/dow_index.csv"),sep="\t")[,"symbol"]
  # Add on DIA which is the ETF ðat is liquid
  dow_symbols <- c("DIA", as.character(dow_symbols))
  
  mylist <- vector("list", length( dow_symbols)) 
  names(mylist) <- dow_symbols
  
  STOCK_PRICES <- NA;
  for (s in 1:length(dow_symbols)){
    symbol <- names(mylist)[s]
    contract <- twsEquity(symbol = symbol,'SMART')
    #To avoid pacing violations
    Sys.sleep(10)
    d <- reqHistoricalData(ibConnection,contract, duration="51 W", barSize = "1 hour")  
    
    colnames(d) <-str_replace(colnames(d),paste0(symbol,"."),"")
    d <- data.frame(symbol=symbol,d)
    d$date <- row.names(d)
    if(s==1) {
      STOCK_PRICES <<- d
    } else {
      STOCK_PRICES <<- rbind(d,STOCK_PRICES)
    } 
    
  }
}



