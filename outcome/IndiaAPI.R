#Load or make list of URL's ---------------------------------------------------
library(rvest)     
library(tidyverse)
links <- read.csv("outcome/api.covid19india.org_24th_Mar_2021.csv")
  ##`links` have information on datasets except raw_data. We need to make `links_rawdata`.

page <- read_html("https://api.covid19india.org")
page_p <- page %>% html_nodes("p") %>%  html_text() #save html text in the node "p" into `page_p`
page_p <- page_p[4] #save only the 4th string.
page_split <- str_split(page_p, " | ")[[1]] #split the string by a pattern " | "
index <- page_split %>% str_detect("csv$") #find urls using that urls ends with ".csv"
raw_data_links <- page_split[index]

links_rawdata <- data.frame(str_match(raw_data_links, "https://api.covid19india.org/csv/latest/\\s*(.*?)\\s*.csv"))
names(links_rawdata) <- c("Link", "SheetName")
links_rawdata
  #`links_rawdata` and `links` have the same structure except the column 'Description'

#Download files ---------------------------------------------------
location <- "outcome/downloads"
dir.create(location)

  ##files except raw datasets
for (i in 1:nrow(links)){
  url <- links$Link[i]
  file <- paste0(location, "/",links$SheetName[i], ".csv")
  download.file(url, file, quiet = TRUE, mode = "wb") 
}
  ##raw datasets
for (i in 1:nrow(links_rawdata)){
  url <- links_rawdata$Link[i]
  file <- paste0(location, "/",links_rawdata$SheetName[i], ".csv")
  download.file(url, file, quiet = TRUE, mode = "wb") 
}

#Load the downloaded files ---------------------------------------------------
library(janitor)

for (i in 1:nrow(links)){
  assign(links$SheetName[i],
         read.csv(paste0(location, "/",links$SheetName[i], ".csv")) %>%
           clean_names() %>% 
           mutate(sheet_name = links$SheetName[i],
                  description = links$Description[i])
  )
}


for (i in 1:nrow(links_rawdata)){
  assign(links_rawdata$SheetName[i],
         read.csv(paste0(location, "/",links_rawdata$SheetName[i], ".csv")) %>%
           clean_names() %>% 
           mutate(sheet_name = links_rawdata$SheetName[i])
  )
}

raw_data1

#Stack `raw_data{}` files. ----------------------------------------------------------
names(raw_data1) == names(raw_data2)
names(raw_data2) == names(raw_data3) #will return warning.
names(raw_data3) == names(raw_data24) 
  ##`raw_data1` and `raw_data2` have different columns than others.

raw_data1$entry_id <- NA # make new column
raw_data2$entry_id <- NA # make new column
raw_data1 <- raw_data1[, -c(4, 20)] #remove Estimated Onset Date and Backup Notes
raw_data2 <- raw_data2[, -c(4, 20)] #remove Estimated Onset Date and Backup Notes

names(raw_data1) %in% names(raw_data20) #All True, which means all columns in raw_data1 are in raw_data20 regardless of the order
names(raw_data20) %in% names(raw_data1) #All True, which means all columns in raw_data20 are in raw_data1 regardless of the order

  #Let's match the orders of columns.
reorder_idx <- match(names(raw_data3), names(raw_data1))
raw_data1 <- raw_data1[,reorder_idx]
raw_data2 <- raw_data2[,reorder_idx]

names(raw_data2) == names(raw_data3)

raw_data_combined <- rbind(raw_data1, raw_data2, raw_data3, raw_data4, raw_data5, raw_data6,
                           raw_data7, raw_data8, raw_data9, raw_data10, raw_data11, raw_data12,
                           raw_data13, raw_data14, raw_data15, raw_data16, raw_data17, raw_data18,
                           raw_data19, raw_data20, raw_data21, raw_data22, raw_data23, raw_data24)
names(raw_data_combined) # column names of `raw_data_combined`, but we need only some of them.
  ## select only necessary columns and save them.
raw_data_combined <-
raw_data_combined %>% 
  select(entry_id, patient_number, date_announced, age_bracket, gender, 
         detected_city, detected_district, detected_state,
         state_code, num_cases, current_status, contracted_from_which_patient_suspected, notes)

write.csv(raw_data_combined, "outcome/raw_data_combined.csv")

#relevant variables in state level. For time series variable, median is used.
var_relevant_state<-
  statewise_tested_numbers_data %>% group_by(state) %>%
  summarise(total_tested=median(total_tested, na.rm = TRUE),
            total_num_icu_beds=median(total_num_icu_beds, na.rm = TRUE),
            total_num_ventilators=median(total_num_ventilators, na.rm = TRUE),
            total_num_of_o2_beds=median(total_num_of_o2_beds, na.rm = TRUE),
            total_num_beds_normal_isolation=median(total_num_beds_normal_isolation, na.rm = TRUE),
            total_ppe=median(total_ppe, na.rm = TRUE),
            total_n95_masks=median(total_n95_masks, na.rm = TRUE),
            covid_enquiry_calls=median(covid_enquiry_calls, na.rm = TRUE),
            number_of_containment_zones=median(number_of_containment_zones, na.rm = TRUE)
            )

vrs2 <- #Other relevant variables in state level.
  cowin_vaccine_data_statewise %>% group_by(state) %>%
  summarise(total_covaxin_administered=median(total_covaxin_administered, na.rm=TRUE),
            total_covi_shield_administered=median(total_covi_shield_administered, na.rm=TRUE),
            total_doses_administered=median(total_doses_administered, na.rm=TRUE)
            )
#update `var_relevant_state`
var_relevant_state <- inner_join(var_relevant_state, vrs2, by="state")

write.csv(var_relevant_state, "outcome/var_relevant_state.csv")
#Idea : Using 'state_wise_daily.csv', ratio variables can be made, e.g.,
#       median of icu beds/total confirmed by state.

View(var_relevant_state)



