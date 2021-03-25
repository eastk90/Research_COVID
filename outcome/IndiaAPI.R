#Download files
links <- read.csv("outcome/api.covid19india.org_24th_Mar_2021.csv")

location <- "outcome/downloads"
dir.create(location)

for (i in 1:nrow(links)){
  url <- links$Link[i]
  file <- paste0(location, "/",links$SheetName[i], ".csv")
  download.file(url, file, quiet = TRUE, mode = "wb") 
}

#Load the downloaded files
library(tidyverse)
library(janitor)

for (i in 1:nrow(links)){
  assign(links$SheetName[i],
         read.csv(paste0(location, "/",links$SheetName[i], ".csv")) %>%
           clean_names() %>% 
           mutate(sheet_name = links$SheetName[i],
                  description = links$Description[i])
  )
}


#Stack `raw_data{}` files.
names(raw_data1) == names(raw_data2)
names(raw_data2) == names(raw_data3)
names(raw_data3) == names(raw_data24) 
##`raw_data1` and `raw_data2` have different columns than others.

raw_data1$entry_id <- NA # make new column
raw_data2$entry_id <- NA # make new column
raw_data1 <- raw_data1[, -c(4, 20)] #remove Estimated Onset Date and Backup Notes
raw_data2 <- raw_data2[, -c(4, 20)] #remove Estimated Onset Date and Backup Notes

names(raw_data1) %in% names(raw_data20)
names(raw_data20) %in% names(raw_data1) 

reorder_idx <- match(names(raw_data3), names(raw_data1))
raw_data1 <- raw_data1[,reorder_idx]
raw_data2 <- raw_data2[,reorder_idx]

names(raw_data2) == names(raw_data3)

raw_data <- rbind(raw_data1, raw_data2, raw_data3, raw_data4, raw_data5, raw_data6, 
                  raw_data7, raw_data8, raw_data9, raw_data10, raw_data11, raw_data12,
                  raw_data13, raw_data14, raw_data15, raw_data16, raw_data17, raw_data18, 
                  raw_data19, raw_data20, raw_data21, raw_data22, raw_data23, raw_data24)

