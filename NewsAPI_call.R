library(httr)
library(jsonlite)
library(lubridate)
library(dplyr)
source("D:/Projects/creds.R")

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
