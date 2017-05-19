library(httr)
library(jsonlite)
library(lubridate)
library(dplyr)
source("D:/Projects/creds.R")

# access News API (https://newsapi.org/) to get headline articles

<<<<<<< HEAD
sources <- c("associated-press","bbc-news","bloomberg","business-insider",
             "buzzfeed","cnbc","cnn","google-news","independent","reuters",
             "the-economist", "the-huffington-post","the-new-york-times",
             "the-wall-street-journal", "the-washington-post","time","usa-today")
=======
sources <- c("associated-press","al-jazeera-english","bbc-news","bloomberg",
             "business-insider","breitbart-news","cnbc","cnn","google-news",
             "independent","reuters","the-economist", "the-huffington-post",
             "newsweek","the-new-york-times","the-wall-street-journal", 
             "the-washington-post","time","usa-today")
>>>>>>> development

requestLinks <- paste0("https://newsapi.org/v1/articles?source=", 
                       sources,"&apiKey=", news.API.key) 
# for sorting: "&sortBy=latest"
<<<<<<< HEAD
allData <- vector("list", length(sources))
for(x in 1:length(sources)){
  news.source <- GET(requestLinks[x])
  news.source <- content(news.source)
  news.source <- fromJSON(toJSON(news.source))
  allData[[x]] <- news.source
  allData[[x]] <- data.frame(allData[[x]])
  allData[[x]] <- allData[[x]] %>%
                  select(-articles.author)
  allData[[x]]$articles.title <- allData[[x]]$articles.title %>% unlist
  #allData[[x]]$articles.description <- allData[[x]]$articles.description %>% unlist
  allData[[x]]$articles.url <- allData[[x]]$articles.urlToImage %>% unlist}
  #allData[[x]]$articles.publishedAt <- allData[[x]]$articles.publishedAt %>% unlist}
                  
=======

# loop to retrieve JSON news data into initialized list
allData <- vector("list", length(sources))
for(x in seq_along(sources)){
  news.source <- GET(requestLinks[x])
  news.source <- content(news.source)
  news.source <- fromJSON(toJSON(news.source))
  allData[[x]] <- news.source}


# convert list objects to dataframes
>>>>>>> development
