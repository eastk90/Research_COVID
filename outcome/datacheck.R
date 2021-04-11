##---------------------##
## District Level      ##
##---------------------##

#Check 'district_wise' matches 'district'
library(tidyverse)
district_wise <- read_csv("outcome/downloads/district_wise.csv")
districts <- read_csv("outcome/downloads/districts.csv")

max(districts$Date)
districts %>% filter(Date < "2020-04-28") #Works!
#It looks like Confirmed	Recovered	Deceased	Other	Tested are cumulative in `districts`!
#Therefore, the row with the recent day should match `district_wise`

districts_latest <- districts %>% filter(Date == max(Date)) #saves rows with the lastest date into `districts_latest`.
View(districts_latest)
district_wise %>% filter(District == "Prakasam")

districts_latest %>% filter(District == "Central Delhi")
districts %>% filter(District == "New Delhi") 

##-----------------------------------------------------------------------------
#Check which districts are in 'districts.csv' and 'district_wise.csv'.
## 1. district_wise.csv
#'district_for_comparision.csv' is from Office of the Registrar General & Census Commissioner, India
districts_comparision <- read_csv('outcome/district_for_comparision.csv')
districts_comparision
nrow(districts_comparision)
##First, check if state names are the same.
districts_comparision %>% filter(State %in% district_wise$State) %>% nrow()
districts_comparision %>% filter(!(State %in% district_wise$State)) %>% nrow()
districts_comparision %>% filter(!(State %in% district_wise$State)) 
#It looks like there are distinct states in India, 'Daman & Diu' and 'Dadra & Nagar Haveli UT'
#In the census data, they are coded as above.
#In the 'district_wise.csv', they are combined as 'Dadra and Nagar Haveli and Daman and Diu'.

districts_comparision %>% filter(!(District %in% district_wise$District))
district_wise %>% filter(State %in% unique(districts_comparision$State)) %>%
  filter(!(District %in% districts_comparision$District)) %>%
  View()
#//Haryana
#Mewat ->
#Gurgaon -> Gurugram
#// Punjab
#Muktsar -> Sri Muktsar Sahib
#Sahibzada Ajit Singh Nagar -> S.A.S. Nagar
#// Maharashtra
#Ahmadnagar -> Ahmednagar 
#Buldana -> Buldhana
#Gondiya -> Gondia
#Bid -> Beed
#//Uttarakhand
#Hardwar -> Haridwar
#Garhwal -> Pauri Garhwal #Not sure.
unique(districts_comparision$State)
district_wise %>% filter(State %in% unique(districts_comparision$State))
##---------------------------------------------------------------------
## 2. districts.csv
##First, check if state names are the same.
districts_comparision %>% filter(State %in% districts$State) %>% nrow()
districts_comparision %>% filter(!(State %in% districts$State)) %>% nrow()
districts_comparision %>% filter(!(State %in% districts$State)) 

districts_comparision %>% filter(!(District %in% districts$District))
#Mumbai Suburban            Maharashtra
#North Goa                  Goa        
#South Goa                  Goa  
districts %>% filter(State %in% unique(districts_comparision$State)) %>%
  filter(!(District %in% districts_comparision$District)) %>%
  group_by(District) %>%
  summarise(n = n()) %>%
  View()

##---------------------------------------------------------------------
unique(district_wise$District)
unique(districts$District)

unique(districts$District)[!(unique(districts$District) %in% unique(district_wise$District))]
#Capital Complex

district_wise %>% filter(!(District %in% unique(districts$District))) %>% View()
district_wise %>% filter(!(District %in% unique(districts$District))) %>% 
  filter(District_Notes == "District-wise numbers are out-dated as cumulative counts for each district are not reported in bulletin")
#22
district_wise %>% 
  filter(District_Notes == "District-wise numbers are out-dated as cumulative counts for each district are not reported in bulletin")
#23
#**Except Goa	GA_Other State	Other State, all districts with the message are included in district_wise only.
#**However, there are a lot more districts that are included in district_wise only but do not come with the message.


unique(district_wise$District_Notes)
View(district_wise)

##------------------##
## State Level      ##
##------------------##
state_wise <- read_csv("outcome/downloads/state_wise.csv")
state_wise_daily <- read_csv("outcome/downloads/state_wise_daily.csv")
states <- read_csv("outcome/downloads/states.csv")
statewise_tested_numbers_data <- read_csv("outcome/downloads/statewise_tested_numbers_data.csv")
vaccine_doses_administered_statewise <- read_csv("outcome/downloads/vaccine_doses_administered_statewise.csv")

district_wise <- read_csv("outcome/downloads/district_wise.csv")
districts <- read_csv("outcome/downloads/districts.csv")


state_wise$State
state_wise$State_code
names(state_wise_daily)[4:42]
unique(states$State)
unique(statewise_tested_numbers_data$State)
vaccine_doses_administered_statewise$State

unique(district_wise$State)
unique(district_wise$State_Code)
unique(districts$State)
#

test1 <- read.csv("test.csv")

