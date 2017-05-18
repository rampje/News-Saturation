library(tidyverse)
library(tm)

source_files <- paste0(getwd(), "/news data/")

news <- read.csv(source_file, stringsAsFactors = FALSE)

news$processed_title <- gsub("\n", "", news$title)

news$title_wordcnt <- map_dbl(gregexpr("\\S+", news$processed_title), length)

news$remove <- news$title_wordcnt < 4

# manually find false title indeces
View(news[news$remove==FALSE,])
message("Sort by 'title_wordcnt' ascending when in View")

remove_indeces <- c(439,490,543,574:577,659,689,691,743,810,
                    1072,1093,1131,1132,1539,1634,1636,1640,
                    1728,1763,1830,1831,1988,2032,2034,2070,
                    2076,2077,2313,2314,2322,2328,2402,2549,
                    2550,2654,2957,2977,3198,3295,3332,3327,
                    3602,3808,3809,3810,3990,4283,4283,4399,
                    4464,4495,4570,4743,4758,4779,4780,4783,
                    4806,4817,4818,4824,4830,4879,4891,4931,
                    4941,4966,4974,4986,5009,5017,5021,5038,
                    5057,5074,5080,5093,5155,5159,5210,5257,
                    5436,462,858,976,982,1366,1656,1726,1742,
                    183,1838,1894,1942,1987,2005,2145,2196,2326,
                    2479,2542,2631,2766,2783,2899,2904,2907,3049,
                    3189,3192,3202,3335,3471,3609,3693,3694,3799,
                    3800,3801,3816,3825,3930,3946,4071,4177,4282,
                    4289,4291,4407,4525,4588,4620,4642,4744,4745,
                    4749,4820,4821,4829,4893,4894,4899,4901,4901,
                    4908,4971,4973,5016,5062,5121,5148,5158,5182,
                    5205,5213,5236,5445,5461,1155,2074,2185,2884,
                    3021,3023,3571,3876,4939,4521,4527,4572,4619,
                    4649,4750,4837,4900,5232,5238,200,922,1976,2668)


news$remove[remove_indeces] <- TRUE
                    
news %>% 
  filter(remove == TRUE) %>%
  write.csv("filter_frame_04032017.csv", row.names=F)

news$
  processed_title %>%
                tolower %>%
                removePunctuation %>%
                removeWords(stopwords("en")) ->
news$# sometimes R code can be structured weirdly...
  processed_title
                



