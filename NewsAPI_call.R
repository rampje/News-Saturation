library(httr)
library(jsonlite)
library(lubridate)
library(tidyverse)
library(plyr)
library(RODBC)
library(RODBCext)
library(RSQLite)
source("D:/Projects/creds.R")
  

# function to  write results to database
writeNews_sqlExpress <- function(df, db_connection){
    
    ##sets SQL server connection
    myServer <- odbcDriverConnect(db_connection)
    
    #calls current database table 
    oldTable <- sqlFetch(db, "top_news_full")
    
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
allData <- ldply(allData, data.frame)
  
# further processing of data for database
allData <- allData %>%
           ldply(function(x) as.character(x)) %>% 
           t %>% data.frame
  
  
names(allData) <- unlist(allData[1,])
allData <- allData[-1,]

allData$retrieval.time <- rep(Sys.time(), nrow(allData))
  
row.names(allData) <- NULL
allData$status <- NULL
allData$sortBy <- NULL
  
# need to properly process time stamps
allData$articles.publishedAt <- as.character(allData$articles.publishedAt)
allData$articles.publishedAt <- gsub("T", " ",allData$articles.publishedAt)
allData$articles.publishedAt[allData$articles.publishedAt=="list()"] <- NA
allData$articles.publishedAt <- allData$articles.publishedAt %>% 
                                as.POSIXct %>% as.character
  
# -------------------------
# sqlite database setup
  
# initialize database
db <- dbConnect(RSQLite::SQLite(), dbname="news_saturation.sqlite")
#allData %>% dbWriteTable(conn = db, name = "top_news", overwrite = T) 
 
# database refresh
old_table <- dbGetQuery(db, "SELECT * FROM top_news")

# make columns character instead of numeric
old_table$articles.publishedAt <- as.character(old_table$articles.publishedAt)
old_table$retrieval.time <- as.character(old_table$retrieval.time)

# make time stamps character so db doesnt make them numeric
allData$articles.publishedAt <- as.character(allData$articles.publishedAt)
allData$retrieval.time <- as.character(allData$retrieval.time)

# join tables
new_table <- full_join(old_table, allData)

# overwrite db table with new table
new_table %>% dbWriteTable(conn = db, name = "top_news", overwrite=T)
dbDisconnect(db)



# -----------------------------
# sebs sql server express setup


# update DB
#writeNews_sqlExpress(allData)
  
# intialize table before using function 
#myServer <- odbcDriverConnect(db_connection)
#sqlSave(myServer,myFrames,tablename = "top_news_full" , rownames=FALSE)
  
  
  
  
