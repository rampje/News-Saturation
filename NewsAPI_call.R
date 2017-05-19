library(httr)
library(jsonlite)
library(lubridate)
library(tidyverse)
library(plyr)
library(RODBC)
library(RODBCext)
#source("D:/Projects/creds.R")

# function to  write results to database


writeNews <- function(df){
  
  ##sets SQL server connection
  
  myServer <- odbcDriverConnect('driver={SQL Server};server=USINTERN13\\SQLEXPRESS;database=rwunderground;trusted_connection=true')
  
  
  #calls current database table 
  
  oldTable <- sqlFetch(myServer, "top_news_full")
  
  
  # column names must align for joining
  
  frameNames <- colnames(oldTable)
  colnames(df)<- frameNames
  
  #prepares table for merge, sets classes to be the same
  
  oldTable[] <- lapply(oldTable, function(x) as.character(x))
  df[] <- lapply(df, function(x) as.character(x))
  
  #updates tables where PKs match then creates intermediary table with non matching PKs
  
  #alternative method of using table of shite that is dif
  
  #intermediateTable<-anti_join(df,oldTable, by=  "articlestitle" )
  
  
  finalTable <- rbind(oldTable,df, make.row.names=FALSE)
  finalTable <- finalTable[with(finalTable, order(source,articlesauthor)),]
  
  
  finalTable<- finalTable[!duplicated(finalTable$articlestitle),]
  
  
  
  sqlDrop(myServer,"top_news_full")
  sqlSave(myServer,finalTable,tablename = "top_news_full", rownames=FALSE)
  
  #close out connections 
  odbcClose(myServer)
}


#api key
news.API.key <- "3ea7ac10835f464bafa4852873b21408"



# access News API (https://newsapi.org/) to get headline articles
sources <- c("associated-press","al-jazeera-english","bbc-news","bloomberg",
             "business-insider","breitbart-news","cnbc","cnn","google-news",
             "independent","reuters","the-economist", "the-huffington-post",
             "newsweek","the-new-york-times","the-wall-street-journal", 
             "the-washington-post","time","usa-today")

requestLinks <- paste0("https://newsapi.org/v1/articles?source=", 
                       sources,"&apiKey=", news.API.key) 
# for sorting: "&sortBy=latest"
allData <- vector("list", length(sources))

# loop to retrieve JSON news data into initialized list
allData <- vector("list", length(sources))
for(x in seq_along(sources)){
  news.source <- GET(requestLinks[x])
  news.source <- content(news.source)
  news.source <- fromJSON(toJSON(news.source))
  allData[[x]] <- news.source}

# convert list objects to dataframes

myFrames <- ldply(allData, data.frame)

# update DB

writeNews(myFrames)


# intialize table before using function 

#myServer <- odbcDriverConnect('driver={SQL Server};server=USINTERN13\\SQLEXPRESS;database=rwunderground;trusted_connection=true')
#sqlSave(myServer,myFrames,tablename = "top_news_full" , rownames=FALSE)




