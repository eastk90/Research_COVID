library(tidyverse)
raw_data_combined <- read_csv("outcome/raw_data_combined.csv")[,-1]
districts <- read_csv("outcome/downloads/districts.csv")
district_wise <- read_csv("outcome/downloads/district_wise.csv")[,-1]

states <- read_csv("outcome/downloads/states.csv")
state_wise <- read_csv("outcome/downloads/state_wise.csv")
state_wise_daily <- read_csv("outcome/downloads/state_wise_daily.csv")

#View(raw_data_combined)
raw_data_combined %>% filter(detected_state == "Telangana" ) %>% tail(100) %>% View()

district_c11 <- read_csv("3. census 2011/data_dist.csv")
lists <- read_csv("outcome/Indian-States-and-Districts-List.csv")
#lists %>% group_by(District) %>% summarise(n = n()) %>% filter(n > 1)
#------------------------------------------------------------------------------#
#  Check 0.
#------------------------------------------------------------------------------#

#In the 'raw_data_combined', I found by chance that the district name 'Hamirpur' is in two states, 
#  which are 'Himachal Pradesh' and  'Uttar Pradesh'.
#Let's check if there are more those district names.

#Get the list of those district names and the number of states that have the district.
raw_data_combined %>% group_by(detected_district, detected_state) %>% summarise(n = n()) %>%
  group_by(detected_district) %>% summarise(n = n()) %>% filter(n >1)

#Let's get the state names corresponding to districts
multiple_dist <- raw_data_combined %>% group_by(detected_district, detected_state) %>% summarise(n = n()) %>%
  group_by(detected_district) %>% summarise(n = n()) %>% filter(n >1)

multiple_dist$states <- NA
for (i in 1:nrow(multiple_dist)) {
  dist <- multiple_dist$detected_district[i]
  multiple_dist$states[i] <-
    raw_data_combined %>% group_by(detected_district, detected_state) %>% summarise(n = n()) %>%
    filter(detected_district == dist) %>% .$detected_state %>% list()# paste0(kk ,sep = " ", collapse="/ ")
}

View(multiple_dist)

#The following two state values(NA) are apparently error.
raw_data_combined %>% group_by(detected_district, detected_state) %>% summarise(n = n()) %>%
  filter(detected_district == "Amravati")

raw_data_combined %>% group_by(detected_district, detected_state) %>% summarise(n = n()) %>%
  filter(detected_district == "Changlang")

#Let's fill them.
raw_data_combined[raw_data_combined$detected_district == "Amravati" &
                    !(is.na(raw_data_combined$detected_district))& 
                    is.na(raw_data_combined$detected_state),]$detected_state <- "Maharashtra"

raw_data_combined[raw_data_combined$detected_district == "Changlang" &
                    !(is.na(raw_data_combined$detected_district))& 
                    is.na(raw_data_combined$detected_state),]$detected_state <- "Arunachal Pradesh"

#Let's get the district names in multiple states again.
multiple_dist <- raw_data_combined %>% group_by(detected_district, detected_state) %>% summarise(n = n()) %>%
  group_by(detected_district) %>% summarise(n = n()) %>% filter(n >1)

multiple_dist$states <- NA
for (i in 1:nrow(multiple_dist)) {
  dist <- multiple_dist$detected_district[i]
  multiple_dist$states[i] <-
    raw_data_combined %>% group_by(detected_district, detected_state) %>% summarise(n = n()) %>%
    filter(detected_district == dist) %>% .$detected_state %>% list()# paste0(kk ,sep = " ", collapse="/ ")
}

View(multiple_dist)
#------------------------------------------------------------------------------#
#  Check 1.
#    -Assuming 'raw_data's and 'raw_data_combined' are up-to-date and correct,
#     is 'districts.csv' up-to-date?
#    -Quick answer : almost YES
#    -However, the list of districts doesn't match between the two data sets.
#      : 'raw_data_combined' encompasses 'districts.csv'
#    -The cumulative cases of Confirmed, Recovered and Deceased from the 'raw_data_combined' and
#     the cases from 'districts.csv' are exactly the same for the 357 districts.
#    -The number of cases are slightly different for some reason.
#    -The differences are less than 200 except for "Jaipur", "Pune", and "Mumbai"
#------------------------------------------------------------------------------#

dr <- unique(raw_data_combined$detected_district) #list of districts in 'raw_data_combined' : 823 districts.
dd <- unique(districts$District) #list of districts in 'districts.csv' : 638 districts.
all(dd %in% dd) # list of districts in 'raw_data_combined' encompasses 'districts.csv'.

dist <- dd[639]
dist <- "Nainital"
raw_data_combined %>% filter(detected_district == dist) %>% group_by(current_status) %>% 
  summarise(cases = sum(num_cases))
districts %>% filter(District == dist) %>% tail(2) 

"Jaipur"
"Pune"
"Mumbai"

test <- data.frame(dd, rep(NA, length(dd)))
for (i in 2: nrow(test)){
  dist <- test[i,1]
  test[i,2] <- ifelse(dist %in% multiple_dist$detected_district,
                      "multiple district",
                      all(abs(districts %>% filter(District == dist) %>% tail(1) %>% .[,c(6,4,5)] - 
                            raw_data_combined %>% filter(detected_district == dist,
                                                         current_status %in% c("Deceased","Hospitalized","Recovered")) %>% 
                            group_by(current_status) %>% 
                            summarise(cases = sum(num_cases)) %>% .$cases)  == 0 ) # or ==0
  )
}


test[test[,2] == FALSE,] 

# "Raichur" : because of the last update added twice. -> district.csv > raw
# "Nainital" : 

raw_data_combined %>% filter(detected_district == dist , current_status == "Recovered",
                             num_cases <7) %>% View()
raw_data_combined %>% filter(detected_district == dist , current_status == "Recovered") %>% View()


#------------------------------------------------------------------------------#
#  Check 2.
#    -We saw that 'district.csv' is almost up-to-date even though it loses some districts.
#    -Is 'district_wise.csv' up-to-date under the assumption that 'district.csv' is up-to-date?
#    -Quick answer : Yes
#    -However, the list of districts doesn't match excatly between the two data sets.
#   
#------------------------------------------------------------------------------#
district_wise
ddw <- unique(district_wise$District) #list of districts in 'district_wise.csv' : 744 districts.
dr
dd
all(dd %in% ddw)
all(ddw %in% dr)

dd[!(dd %in% ddw)]
ddw[!(ddw %in% dr)]
dr[!(dr %in% ddw)]
View(district_wise)
district_wise %>% filter(!(is.na(District_Notes))) %>% View()
ddwn <- district_wise %>% filter(!(is.na(District_Notes))) %>% .$District
ddwn %in% dd
dist <- intersect(dd, ddw)[2]
dist

test <- data.frame(intersect(dd, ddw), rep(NA, length(intersect(dd, ddw))))
for (i in 2: nrow(test)){
  dist <- test[i,1]
  test[i,2] <- ifelse(dist %in% multiple_dist$detected_district,
                      "multiple district",
                      all(districts %>% filter(District == dist) %>% tail(1) %>% .[,4:6] == 
                            district_wise %>% filter(District == dist) %>% .[,c(5,7,8)] )
  )
}
test[test[,2] == FALSE,]


dist_list <- ddw[!(ddw %in% dr)]
district_wise %>% filter(District %in% dist_list) %>% .[,c(1:8, 14)]%>% View()

#For the intersecting district, "district_wise.csv" is up-to-date.

#About the "out-dated message" in the "district_wise.csv"
#The message can be found in Telangana, Andaman and Nicobar Islands, Delhi, and Goa.
#All districts in the states has the message.



## STATE LEVEL---------------------------------------------------------------------------------



all(test[,2] == FALSE)
dist



ifelse(dist %in% multiple_dist$detected_district,
       all(districts %>% filter(District == dist) %>% tail(2) %>% .[,4:6] == 
             district_wise %>% filter(District == dist) %>% .[,c(5,7,8)] ),
       all(districts %>% filter(District == dist) %>% tail(1) %>% .[,4:6] == 
             district_wise %>% filter(District == dist) %>% .[,c(5,7,8)] )
       )
multiple_dist$detected_district



all(districts %>% filter(District == dist) %>% tail(1) %>% .[,4:6] == 
      district_wise %>% filter(District == dist) %>% .[,c(5,7,8)] )

multiple_dist


i <-5
dist <- multiple_dist$detected_district[i]
raw_data_combined %>% group_by(detected_district, detected_state) %>% summarise(n = n()) %>%
  filter(detected_district == dist) %>% .$detected_state %>% list()

kk <- raw_data_combined %>% group_by(detected_district, detected_state) %>% summarise(n = n()) %>%
  filter(detected_district == dist) %>% .$detected_state 
class(kk)
paste0(kk ,collapse=" ")

