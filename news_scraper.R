library(RSQLite)
library(tidyverse)
library(tm)
library("XML") 
library("rvest") 

db <- dbConnect(RSQLite::SQLite(), dbname="news_saturation (research).sqlite")
news <- dbGetQuery(db, "SELECT * FROM top_news")

sources <- c("associated-press","al-jazeera-english","bbc-news","bloomberg",
             "business-insider","breitbart-news","cnbc","cnn","google-news",
             "independent","reuters","the-economist", "the-huffington-post",
             "newsweek","the-new-york-times","the-wall-street-journal", 
             "the-washington-post","time","usa-today")

# News scraping function
scrape_news <- function(news_source, news_url){
  
  page <- xml2::read_html(news_url)
  
  if(news_source=="associated-press"){
    # get particular content from page 
    content <- rvest::html_nodes(page, "p") 
    #convert to words
    text <- rvest::html_text(content)
    # remove photo and link captions from beginning
    text <- text[substr(text, 0, 1) != "\n"]
    # remove authors/credits from end
    cutoff <- grep("___",  text)[1] - 1
    if(!is.na(cutoff)){
      text <- text[1:cutoff]}
    # collapse vector into one string
    text <- paste0(text, collapse = " | ")
    # remove city from beginning of article
    text <- gsub(".*(AP)) ", "", text)}
  
  text
}


# ----------------
# Associated Press
# ----------------
# get all articles in vector
ap <- news$articles.url[news$source=="associated-press"]

text_col <- character()
for(x in ap){
  text_col <- c(text_col, scrape_news("associated-press", x))}


ap_text <- data.frame("articles.url"=ap,
                      "text"=text_col)



ap_text %>% dbWriteTable(conn = db, name = "ap_text")
dbDisconnect(db)



