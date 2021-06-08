#Source : https://www.census2011.co.in/district.php
library(rvest) 
library(tidyverse)
setwd("C:/Users/samsung/Desktop/BIOS/Research_Covid/git/Research_COVID/3. census 2011") #Directory containing 'distirct_link.csv'

distirct_link <- read_csv('distirct_link.csv')
distirct_link$`Area(km2)` <- NA


# html <- read_html('https://www.census2011.co.in/district.php')
# tbls_ls <- html %>%
#   html_nodes("table") %>%
#   .[1] %>%
#   html_table(header = TRUE, fill = TRUE)
# tbls_ls[[1]]$District
# 
# distirct_link <- filter(District %in% tbls_ls[[1]]$District)
# 
# distirct_link <-
# distirct_link[distirct_link$District %in% tbls_ls[[1]]$District,]

for (i in 1:nrow(distirct_link)) {
  print(i)
  html <- read_html(distirct_link$Link[i])
  
  tbls_ls <- html %>%
    html_nodes("table") %>%
    .[1] %>%
    html_table(header = TRUE, fill = TRUE)
  
  num_area <- which(tbls_ls[[1]]$Description == 'Area Sq. Km')
  distirct_link$`Area(km2)`[i] <- tbls_ls[[1]]$`2011`[num_area]
  
}

write.csv(distirct_link[,2:3], "Area_km2_District.csv")
