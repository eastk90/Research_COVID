##------------------------------------------------------------------------##
#  Required files to run this code :

#'3. census 2011/census2011_link.csv'
#'3. census 2011/Area_km2.csv'
#'3. census 2011/Area_km2_District.csv'
#'3. census 2011/census2011_religion_link.csv'
##------------------------------------------------------------------------##

#Load packages and set working directory.
library(readxl)
library(tidyverse)
setwd("C:/Users/samsung/Desktop/BIOS/Research_Covid/git/Research_COVID/3. census 2011") #Directory containing "census2011_link.csv"

#Read links to download the data needed.
links_census = read_csv("census2011_link.csv")

#Set a location for the files to be downloaded.
location <- "downloads"
dir.create(location)

##------------------------------------------------------------------------##
# #First, organize dataset for C-13.
##------------------------------------------------------------------------##

dat <- links_census %>% filter(Caste == 'C-13')

#Make empty data frames for pop by state, district and age.
data_state <- data.frame()
data_dist <- data.frame()
data_state_age <- data.frame()
data_dist_age <- data.frame()

#Download files
for (i in 2:nrow(dat)){
  url <- unlist(dat[i,]$Link) #url of the i th state.
  state <- dat[i,]$State #i th state
  state_file <- paste0(location, "/", state,".xls") # the location of the i th state.
  download.file(url, state_file, quiet = TRUE, mode = "wb") #download corresponding file.
}

#Generate data sets for all states.
for (i in 2:nrow(dat)){
  state <- dat[i,]$State #i th state
  state_file <- paste0(location, "/", state,".xls") # the location of the i th state.
  
  file0 <- read_excel(state_file) #read the files downloaded above.
  row_start <- 7 #Since the rows from 1st to 6th are column names, remove them and
                 #assign new column names in the following code
  file <- file0[row_start:nrow(file0),]
  names(file) <- c("state_name",	"state_code",	"dist_code",	"Area", "Age", 
                   "Total",  "TotalMales", "TotalFemales",
                   "RuralPersons", "RuralMales", "RuralFemales",
                   "UrbanPersons", "UrbanMales", "UrbanFemales")
  file$state_name <- state
  #The columns from 6th to 14th are number of people. Save them as numeric.
  file[,6:14] <- sapply(file[,6:14], as.numeric)
  file[file$Age == "100+",]$Age <- "100" #For the age column, change "100+" to "100"
  file[file$Age == "Age not stated",]$Age <- "999" #For the age column, change "Age not stated" to "999"
  
  file <- file %>% mutate("% Male"=round(TotalMales/Total *100, 2), #Calculate % of Male
                          "% Rural"=round(RuralPersons/Total*100, 2)) #Calculate % of Rural
  
  #Get relevant data for the i th state.
  data_state_ <- file %>% filter(dist_code == '000', Age == 'All ages')
  data_dist_ <-  file %>% filter(dist_code != '000', Age == 'All ages')
  data_state_age_ <- file %>% filter(dist_code == '000', Age != 'All ages')
  data_dist_age_  <- file %>% filter(dist_code != '000', Age != 'All ages')
  
  #Combine the rows for the ith state obtained above and the dataset across all states.
  data_state <- rbind(data_state, data_state_)
  data_dist <- rbind(data_dist, data_dist_)
  data_state_age <- rbind(data_state_age, data_state_age_)
  data_dist_age <- rbind(data_dist_age, data_dist_age_)
}

View(data_state)
View(data_dist)
View(data_state_age)
View(data_dist_age)

#Make 'dist_name' column from 'Area' column of `data_dist` and `data_dist_age`
Area_sub <- sub("\\s\\(\\d\\d\\)", "", substr(data_dist$Area, 12, 100))
Area_sub <- sub("\\s$", "", Area_sub)
Area_sub <- sub("\\s$", "", Area_sub)
Area_sub <- sub("\\s$", "", Area_sub)
Area_sub <- sub("\\s\\s", " ", Area_sub)
data_dist$dist_name <- Area_sub

#Also, duplicate district names were found. Let's change their values.
length(Area_sub)
unique(Area_sub)
n_occur <- data.frame(table(Area_sub))
n_occur[n_occur$Freq > 1,]
n_occur$Area_sub[n_occur$Freq > 1]

data_dist %>% filter(dist_name %in% n_occur$Area_sub[n_occur$Freq > 1]) %>% 
  select(state_name, state_code, dist_code, Area, dist_name) %>% View()

data_dist[data_dist$state_code == 10 & data_dist$dist_code ==  235,]$dist_name <- "Aurangabad (Bihar)"
data_dist[data_dist$state_code == 22 & data_dist$dist_code ==  403,]$dist_name <- "Raigarh (Chhattisgarh)"
data_dist[data_dist$state_code == 22 & data_dist$dist_code ==  406,]$dist_name <- "Bilaspur (Chhattisgarh)"
data_dist[data_dist$state_code == 22 & data_dist$dist_code ==  417,]$dist_name <- "Bijapur (Chhattisgarh)"

data_dist[data_dist$state_code == '02' & data_dist$dist_code ==  '028',]$dist_name <- "Hamirpur (Himachal Pradesh)"
data_dist[data_dist$state_code == '02' & data_dist$dist_code ==  '030',]$dist_name <- "Bilaspur (Himachal Pradesh)"
data_dist[data_dist$state_code == 29 & data_dist$dist_code ==  557,]$dist_name <- "Bijapur (Karnataka)"
data_dist[data_dist$state_code == 27 & data_dist$dist_code ==  515,]$dist_name <- "Aurangabad (Maharashtra)"

data_dist[data_dist$state_code == 27 & data_dist$dist_code ==  520,]$dist_name <- "Raigarh (Maharashtra)"
data_dist[data_dist$state_code == '08' & data_dist$dist_code ==  131,]$dist_name <- "Pratapgarh (Rajasthan)"
data_dist[data_dist$state_code == '09' & data_dist$dist_code ==  168,]$dist_name <- "Hamirpur (Uttar Pradesh)"
data_dist[data_dist$state_code == '09' & data_dist$dist_code ==  173,]$dist_name <- "Pratapgarh (Uttar Pradesh)"

#All duplicate names were change. Thereby, theres is no duplicate names anymore in `data_dist`
data_dist %>% filter(dist_name %in% n_occur$Area_sub[n_occur$Freq > 1]) %>% 
  select(state_name, state_code, dist_code, Area, dist_name)

#There are more dist_names should be changed.
data_dist[data_dist$state_code == '07' & data_dist$dist_code ==  '090',]$dist_name <- "North West Delhi"
data_dist[data_dist$state_code == '07' & data_dist$dist_code ==  '091',]$dist_name <- "North Delhi"
data_dist[data_dist$state_code == '07' & data_dist$dist_code ==  '092',]$dist_name <- "North East Delhi"
data_dist[data_dist$state_code == '07' & data_dist$dist_code ==  '093',]$dist_name <- "East Delhi"
data_dist[data_dist$state_code == '07' & data_dist$dist_code ==  '095',]$dist_name <- "Central Delhi"
data_dist[data_dist$state_code == '07' & data_dist$dist_code ==  '096',]$dist_name <- "West Delhi"
data_dist[data_dist$state_code == '07' & data_dist$dist_code ==  '097',]$dist_name <- "South West Delhi"
data_dist[data_dist$state_code == '07' & data_dist$dist_code ==  '098',]$dist_name <- "South Delhi"

data_dist[data_dist$state_code == '11' & data_dist$dist_code ==  '241',]$dist_name <- "North Sikkim"
data_dist[data_dist$state_code == '11' & data_dist$dist_code ==  '242',]$dist_name <- "West Sikkim"
data_dist[data_dist$state_code == '11' & data_dist$dist_code ==  '243',]$dist_name <- "South Sikkim"
data_dist[data_dist$state_code == '11' & data_dist$dist_code ==  '244',]$dist_name <- "East Sikkim"

data_dist[data_dist$state_code == '10' & data_dist$dist_code ==  '204',]$dist_name <- "Purbi Champaran"
data_dist[data_dist$state_code == '10' & data_dist$dist_code ==  '233',]$dist_name <- "Kaimur"
data_dist[data_dist$state_code == '22' & data_dist$dist_code ==  '405',]$dist_name <- "Janjgir Champa"
data_dist[data_dist$state_code == '20' & data_dist$dist_code ==  '369',]$dist_name <- "Saraikela Kharsawan"
data_dist[data_dist$state_code == '05' & data_dist$dist_code ==  '061',]$dist_name <- "Pauri Garhwal"

#Repeat the same work for `data_dist_age`
Area_sub <- sub("\\s\\(\\d\\d\\)", "", substr(data_dist_age$Area, 12, 100))
Area_sub <- sub("\\s$", "", Area_sub)
Area_sub <- sub("\\s$", "", Area_sub)
Area_sub <- sub("\\s$", "", Area_sub)
Area_sub <- sub("\\s\\s", " ", Area_sub)
data_dist_age$dist_name <- Area_sub

data_dist_age[data_dist_age$state_code == 10 & data_dist_age$dist_code ==  235,]$dist_name <- "Aurangabad (Bihar)"
data_dist_age[data_dist_age$state_code == 22 & data_dist_age$dist_code ==  403,]$dist_name <- "Raigarh (Chhattisgarh)"
data_dist_age[data_dist_age$state_code == 22 & data_dist_age$dist_code ==  406,]$dist_name <- "Bilaspur (Chhattisgarh)"
data_dist_age[data_dist_age$state_code == 22 & data_dist_age$dist_code ==  417,]$dist_name <- "Bijapur (Chhattisgarh)"

data_dist_age[data_dist_age$state_code == '02' & data_dist_age$dist_code ==  '028',]$dist_name <- "Hamirpur (Himachal Pradesh)"
data_dist_age[data_dist_age$state_code == '02' & data_dist_age$dist_code ==  '030',]$dist_name <- "Bilaspur (Himachal Pradesh)"
data_dist_age[data_dist_age$state_code == 29 & data_dist_age$dist_code ==  557,]$dist_name <- "Bijapur (Karnataka)"
data_dist_age[data_dist_age$state_code == 27 & data_dist_age$dist_code ==  515,]$dist_name <- "Aurangabad (Maharashtra)"

data_dist_age[data_dist_age$state_code == 27 & data_dist_age$dist_code ==  520,]$dist_name <- "Raigarh (Maharashtra)"
data_dist_age[data_dist_age$state_code == '08' & data_dist_age$dist_code ==  131,]$dist_name <- "Pratapgarh (Rajasthan)"
data_dist_age[data_dist_age$state_code == '09' & data_dist_age$dist_code ==  168,]$dist_name <- "Hamirpur (Uttar Pradesh)"
data_dist_age[data_dist_age$state_code == '09' & data_dist_age$dist_code ==  173,]$dist_name <- "Pratapgarh (Uttar Pradesh)"

#There are more dist_names should be changed.
data_dist_age[data_dist_age$state_code == '07' & data_dist_age$dist_code ==  '090',]$dist_name <- "North West Delhi"
data_dist_age[data_dist_age$state_code == '07' & data_dist_age$dist_code ==  '091',]$dist_name <- "North Delhi"
data_dist_age[data_dist_age$state_code == '07' & data_dist_age$dist_code ==  '092',]$dist_name <- "North East Delhi"
data_dist_age[data_dist_age$state_code == '07' & data_dist_age$dist_code ==  '093',]$dist_name <- "East Delhi"
data_dist_age[data_dist_age$state_code == '07' & data_dist_age$dist_code ==  '095',]$dist_name <- "Central Delhi"
data_dist_age[data_dist_age$state_code == '07' & data_dist_age$dist_code ==  '096',]$dist_name <- "West Delhi"
data_dist_age[data_dist_age$state_code == '07' & data_dist_age$dist_code ==  '097',]$dist_name <- "South West Delhi"
data_dist_age[data_dist_age$state_code == '07' & data_dist_age$dist_code ==  '098',]$dist_name <- "South Delhi"

data_dist_age[data_dist_age$state_code == '11' & data_dist_age$dist_code ==  '241',]$dist_name <- "North Sikkim"
data_dist_age[data_dist_age$state_code == '11' & data_dist_age$dist_code ==  '242',]$dist_name <- "West Sikkim"
data_dist_age[data_dist_age$state_code == '11' & data_dist_age$dist_code ==  '243',]$dist_name <- "South Sikkim"
data_dist_age[data_dist_age$state_code == '11' & data_dist_age$dist_code ==  '244',]$dist_name <- "East Sikkim"

data_dist_age[data_dist_age$state_code == '10' & data_dist_age$dist_code ==  '204',]$dist_name <- "Purbi Champaran"
data_dist_age[data_dist_age$state_code == '10' & data_dist_age$dist_code ==  '233',]$dist_name <- "Kaimur"
data_dist_age[data_dist_age$state_code == '22' & data_dist_age$dist_code ==  '405',]$dist_name <- "Janjgir Champa"
data_dist_age[data_dist_age$state_code == '20' & data_dist_age$dist_code ==  '369',]$dist_name <- "Saraikela Kharsawan"
data_dist_age[data_dist_age$state_code == '05' & data_dist_age$dist_code ==  '061',]$dist_name <- "Pauri Garhwal"



#Add 'Dadra and Nagar Haveli and Daman and Diu' row.
a <- data_state %>% filter(state_name == "Dadra & Nagar Haveli UT")
b <- data_state %>% filter(state_name == "Daman & Diu UT")
colSums(rbind(a,b)[,6:14])

newrow <- cbind(
  data.frame("Dadra and Nagar Haveli and Daman and Diu", NA, '000', NA, 'All ages'),
  t(matrix(colSums(rbind(a,b)[,6:14]))))
names(newrow) <- names(data_state)[1:14]
newrow <- newrow %>% mutate("% Male"=round(TotalMales/Total *100, 2), #Calculate % of Male
                            "% Rural"=round(RuralPersons/Total*100, 2)) #Calculate % of Rural

data_state <- rbind(data_state, newrow)

#Remove rows with "Dadra & Nagar Haveli UT" or "Daman & Diu UT"
data_state <- data_state[!(data_state$state_name %in% c("Dadra & Nagar Haveli UT", "Daman & Diu UT")), ]

#read "Area_km2.csv" to calculate pop by area of state
Area_km2 <- read_csv("Area_km2.csv")[,2:3]
Area_km2$state_name[!(Area_km2$state_name %in% data_state$state_name)]
data_state$state_name[!(data_state$state_name %in% Area_km2$state_name)]

data_state <- left_join(data_state, Area_km2, by=c('state_name'='state_name'))
data_state <- data_state %>% mutate('pop/km2' = Total/`Area(km2)`)


#read "Area_km2_District.csv" to calculate pop by area of district
Area_km2_District <- read_csv("Area_km2_District.csv")[,2:3]

Area_km2_District$District[!(Area_km2_District$District %in% data_dist$dist_name)]
data_dist$dist_name[!(data_dist$dist_name %in% Area_km2_District$District)]

data_dist <- left_join(data_dist, Area_km2_District, by=c('dist_name'='District'))
data_dist <- data_dist %>% mutate('pop/km2' = Total/`Area(km2)`)

View(data_dist)
##------------------------------------------------------------------------##
# #Second, organize dataset for C-13 SC.
# The purpose of this job is to add SC population ratio to 
# `data_state` and `data_dist`.

# Note that Census 2011 doesn't have SC data for 
# 1. Andaman & Nicobar Islands UT
# 2. Arunachal Pradesh
# 3. Lakshadweep UT
# 4. Nagaland
##------------------------------------------------------------------------##

dat <- links_census %>% filter(Caste == 'C-13 SC')

#Make empty data frames for pop by state, district and age.
data_stateSC <- data.frame()
data_distSC <- data.frame()
data_state_ageSC <- data.frame()
data_dist_ageSC <- data.frame()

#Download files
for (i in 2:nrow(dat)){
  url <- unlist(dat[i,]$Link) #url of the i th state.
  state <- dat[i,]$State #i th state
  state_file <- paste0(location, "/", state,"SC.xls") # the location of the i th state.
  download.file(url, state_file, quiet = TRUE, mode = "wb") #download corresponding file.
}

#Generate data sets for all states.
for (i in 2:nrow(dat)){
  state <- dat[i,]$State #i th state
  state_file <- paste0(location, "/", state,"SC.xls") # the location of the i th state.
  
  file0 <- read_excel(state_file) #read the files downloaded above.
  row_start <- 7 #Since the rows from 1st to 6th are column names, remove them and
  #assign new column names in the following code
  file <- file0[row_start:nrow(file0),]
  names(file) <- c("state_name",	"state_code",	"dist_code",	"Area", "Age", 
                   "Total",  "TotalMales", "TotalFemales",
                   "RuralPersons", "RuralMales", "RuralFemales",
                   "UrbanPersons", "UrbanMales", "UrbanFemales")
  file$state_name <- state
  #The columns from 6th to 14th are number of people. Save them as numeric.
  file[,6:14] <- sapply(file[,6:14], as.numeric)
  file[file$Age == "100+",]$Age <- "100" #For the age column, change "100+" to "100"
  file[file$Age == "Age not stated",]$Age <- "999" #For the age column, change "Age not stated" to "999"
  
  file <- file %>% mutate("% Male"=round(TotalMales/Total *100, 2), #Calculate % of Male
                          "% Rural"=round(RuralPersons/Total*100, 2)) #Calculate % of Rural
  
  #Get relevant data for the i th state.
  data_stateSC_ <- file %>% filter(dist_code == '000', Age == 'All ages')
  data_distSC_ <-  file %>% filter(dist_code != '000', Age == 'All ages')
  data_state_ageSC_ <- file %>% filter(dist_code == '000', Age != 'All ages')
  data_dist_ageSC_  <- file %>% filter(dist_code != '000', Age != 'All ages')
  
  #Combine the rows for the ith state obtained above and the dataset across all states.
  data_stateSC <- rbind(data_stateSC, data_stateSC_)
  data_distSC <- rbind(data_distSC, data_distSC_)
  data_state_ageSC <- rbind(data_state_ageSC, data_state_ageSC_)
  data_dist_ageSC <- rbind(data_dist_ageSC, data_dist_ageSC_)
}


#Add 'Dadra and Nagar Haveli and Daman and Diu' row.
a <- data_stateSC %>% filter(state_name == "Dadra & Nagar Haveli UT")
b <- data_stateSC %>% filter(state_name == "Daman & Diu UT")
colSums(rbind(a,b)[,6:14])

newrow <- cbind(
  data.frame("Dadra and Nagar Haveli and Daman and Diu", NA, '000', NA, 'All ages'),
  t(matrix(colSums(rbind(a,b)[,6:14]))))
names(newrow) <- names(data_stateSC)[1:14]
newrow <- newrow %>% mutate("% Male"=round(TotalMales/Total *100, 2), #Calculate % of Male
                            "% Rural"=round(RuralPersons/Total*100, 2)) #Calculate % of Rural

data_stateSC <- rbind(data_stateSC, newrow)

#Remove rows with "Dadra & Nagar Haveli UT" or "Daman & Diu UT"
data_stateSC <- data_stateSC[!(data_stateSC$state_name %in% c("Dadra & Nagar Haveli UT", "Daman & Diu UT")), ]

#
stateSC_pop <- data_stateSC %>% mutate(Total_SC = Total) %>% select(state_name, Total_SC)
distSC_pop <-  data_distSC  %>% mutate(Total_SC = Total) %>% select(Area, Total_SC)

data_state <- left_join(data_state, stateSC_pop, by=c('state_name'='state_name')) 
data_dist <- left_join(data_dist, distSC_pop, by=c('Area'='Area'))


#Generate SC population ratio variable.
data_state <- data_state %>% mutate('% SC'=round(Total_SC/Total*100, 2))
data_dist <- data_dist  %>% mutate('% SC'=round(Total_SC/Total*100, 2))





##------------------------------------------------------------------------##
# #Third, organize dataset for C-13 ST.

# The purpose of this job is to add ST population ratio to 
# `data_state` and `data_dist`.

# Note that Census 2011 doesn't have ST data for 
# 1. Chandigarh UT
# 2. NCT of Delhi
# 3. Haryana
# 4. Punjab
# 5. Puducherry UT
##------------------------------------------------------------------------##

dat <- links_census %>% filter(Caste == 'C-13 ST')

#Make empty data frames for pop by state, district and age.
data_stateST <- data.frame()
data_distST <- data.frame()
data_state_ageST <- data.frame()
data_dist_ageST <- data.frame()

#Download files
for (i in 2:nrow(dat)){
  url <- unlist(dat[i,]$Link) #url of the i th state.
  state <- dat[i,]$State #i th state
  state_file <- paste0(location, "/", state,"ST.xls") # the location of the i th state.
  download.file(url, state_file, quiet = TRUE, mode = "wb") #download corresponding file.
}

#Generate data sets for all states.
for (i in 2:nrow(dat)){
  state <- dat[i,]$State #i th state
  state_file <- paste0(location, "/", state,"ST.xls") # the location of the i th state.
  
  file0 <- read_excel(state_file) #read the files downloaded above.
  row_start <- 7 #Since the rows from 1st to 6th are column names, remove them and
  #assign new column names in the following code
  file <- file0[row_start:nrow(file0),]
  names(file) <- c("state_name",	"state_code",	"dist_code",	"Area", "Age", 
                   "Total",  "TotalMales", "TotalFemales",
                   "RuralPersons", "RuralMales", "RuralFemales",
                   "UrbanPersons", "UrbanMales", "UrbanFemales")
  file$state_name <- state
  #The columns from 6th to 14th are number of people. Save them as numeric.
  file[,6:14] <- sapply(file[,6:14], as.numeric)
  file[file$Age == "100+",]$Age <- "100" #For the age column, change "100+" to "100"
  file[file$Age == "Age not stated",]$Age <- "999" #For the age column, change "Age not stated" to "999"
  
  file <- file %>% mutate("% Male"=round(TotalMales/Total *100, 2), #Calculate % of Male
                          "% Rural"=round(RuralPersons/Total*100, 2)) #Calculate % of Rural
  
  #Get relevant data for the i th state.
  data_stateST_ <- file %>% filter(dist_code == '000', Age == 'All ages')
  data_distST_ <-  file %>% filter(dist_code != '000', Age == 'All ages')
  data_state_ageST_ <- file %>% filter(dist_code == '000', Age != 'All ages')
  data_dist_ageST_  <- file %>% filter(dist_code != '000', Age != 'All ages')
  
  #Combine the rows for the ith state obtained above and the dataset across all states.
  data_stateST <- rbind(data_stateST, data_stateST_)
  data_distST <- rbind(data_distST, data_distST_)
  data_state_ageST <- rbind(data_state_ageST, data_state_ageST_)
  data_dist_ageST <- rbind(data_dist_ageST, data_dist_ageST_)
}


#Add 'Dadra and Nagar Haveli and Daman and Diu' row.
a <- data_stateST %>% filter(state_name == "Dadra & Nagar Haveli UT")
b <- data_stateST %>% filter(state_name == "Daman & Diu UT")
colSums(rbind(a,b)[,6:14])

newrow <- cbind(
  data.frame("Dadra and Nagar Haveli and Daman and Diu", NA, '000', NA, 'All ages'),
  t(matrix(colSums(rbind(a,b)[,6:14]))))
names(newrow) <- names(data_stateST)[1:14]
newrow <- newrow %>% mutate("% Male"=round(TotalMales/Total *100, 2), #Calculate % of Male
                            "% Rural"=round(RuralPersons/Total*100, 2)) #Calculate % of Rural

data_stateST <- rbind(data_stateST, newrow)

#Remove rows with "Dadra & Nagar Haveli UT" or "Daman & Diu UT"
data_stateST <- data_stateST[!(data_stateST$state_name %in% c("Dadra & Nagar Haveli UT", "Daman & Diu UT")), ]

#
stateST_pop <- data_stateST %>% mutate(Total_ST = Total) %>% select(state_name, Total_ST)
distST_pop <-  data_distST  %>% mutate(Total_ST = Total) %>% select(Area, Total_ST)

data_state <- left_join(data_state, stateST_pop, by=c('state_name'='state_name')) 
data_dist <- left_join(data_dist, distST_pop, by=c('Area'='Area')) 

#Generate ST population ratio variable.
data_state <- data_state %>% mutate('% ST'=round(Total_ST/Total*100, 2))
data_dist <- data_dist  %>% mutate('% ST'=round(Total_ST/Total*100, 2))

# write.csv(data_state, "data_state.csv")
# write.csv(data_dist, "data_dist.csv")

# View(data_state)

##------------------------------------------------------------------------##
# Dataset for population by religion.
##------------------------------------------------------------------------##


#Read links to download the data needed.
links_religion = read_csv("census2011_religion_link.csv")

#Set a location for the files to be downloaded.
location <- "downloads"
dir.create(location)


dat <- links_religion 

#Make empty data frames for pop by state, district and age.
data_state_religion <- data.frame()
data_dist_religion <- data.frame()


#Download files
for (i in 2:nrow(dat)){
  url <- unlist(dat[i,]$Link) #url of the i th state.
  state <- dat[i,]$State #i th state
  state_file <- paste0(location, "/", state,"_religion.xls") # the location of the i th state.
  download.file(url, state_file, quiet = TRUE, mode = "wb") #download corresponding file.
}

#Generate data sets for all states.
for (i in 2:nrow(dat)){
  state <- dat[i,]$State #i th state
  state_file <- paste0(location, "/", state,"_religion.xls") # the location of the i th state.
  
  file0 <- read_excel(state_file) #read the files downloaded above.
  row_start <- 7 #Since the rows from 1st to 6th are column names, remove them and
  #assign new column names in the following code
  file <- file0[row_start:nrow(file0), c(1:4, 6, 7, 11, 14, 17, 20, 23, 26, 29, 32)]
  names(file) <- c("state_name",	"state_code",	"dist_code", "Tehsil_code",	"Area", "R/U", 
                   "Hindu",	"Muslim", "Christian",	"Sikh", 
                   "Buddhist", "Jain",  "religion_Others", "religion_Notstated")
  
  file$state_name <- state
  #The columns from 6th to 14th are number of people. Save them as numeric.
  file[,7:14] <- sapply(file[,7:14], as.numeric)
  
  #Get relevant data for the i th state.
  file <- file %>% filter(Tehsil_code == '00000' & `R/U` == "Total")
  data_state_religion_ <- file %>% filter(dist_code == '000')
  data_dist_religion_ <-  file %>% filter(dist_code != '000')
  
  #Combine the rows for the ith state obtained above and the dataset across all states.
  data_state_religion <- rbind(data_state_religion, data_state_religion_)
  data_dist_religion <- rbind(data_dist_religion, data_dist_religion_)
}

View(data_state_religion)
View(data_dist_religion)

#Add 'Dadra and Nagar Haveli and Daman and Diu' row.
a <- data_state_religion %>% filter(state_name == "Dadra & Nagar Haveli UT")
b <- data_state_religion %>% filter(state_name == "Daman & Diu UT")
colSums(rbind(a,b)[,7:14])
names(a)
newrow <- cbind(
  data.frame("Dadra and Nagar Haveli and Daman and Diu", NA, '000', NA, NA, NA),
  t(matrix(colSums(rbind(a,b)[,7:14]))))

names(newrow) <- names(data_state_religion)[1:14]

data_state_religion <- rbind(data_state_religion, newrow)

#Remove rows with "Dadra & Nagar Haveli UT" or "Daman & Diu UT"
data_state_religion <- data_state_religion[!(data_state_religion$state_name %in% c("Dadra & Nagar Haveli UT", "Daman & Diu UT")), ]


#Generate religion variables.
data_state <- left_join(data_state, data_state_religion[,-c(2:6)], 
                        by=c('state_name'='state_name'))
data_dist <- left_join(data_dist, data_dist_religion[,-c(1,4,5,6)], 
                       by=c('state_code'='state_code', 'dist_code'='dist_code'))

View(data_state)


##------------------------------------------------------------------------##
# Make age group variable from data_state_age and data_dist_age.
##------------------------------------------------------------------------##

##First, make age variables of 'data_state'  ------------------------------

#Make age variable as numeric so that age group varialbes can be easily made.
data_state_age$Age <- as.numeric(data_state_age$Age)
data_dist_age$Age <- as.numeric(data_dist_age$Age)

#Make 'AgeGroup' variable
data_state_AgeGroup_ <- data_state_age %>% 
  mutate(AgeGroup = cut(Age,
                        breaks = c(-Inf,4,9,14,19,24,29,34,39,44,49,54,59,64,69,74,79,84,100,999),
                        labels = c('0-4', '5-9', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', '40-44', '45-49', 
                                   '50-54', '55-59', '60-64', '65-69', '70-74', '75-79', '80-84', '85+', 'Notstated'))) %>%
  select(state_name, Age, AgeGroup, Total) %>%
  group_by(state_name, AgeGroup) %>%
  summarise(Total = sum(Total)) %>%
  spread (key = AgeGroup, value = Total)
#View(data_state_AgeGroup_)

#Split age by 60.
data_state_AgeGroup_2 <- data_state_age %>% 
  mutate(above60 = cut(Age, breaks = c(-Inf, 60, 100, 999), labels = c('0-60','>60','Notstated_'))) %>%
  select(state_name, Age, above60, Total) %>%
  group_by(state_name, above60) %>%
  summarise(tt = sum(Total))  %>% 
  spread (key = above60, value = tt)
#View(data_state_AgeGroup_2)

#Define a new function that spreads multiple columns of data frame.
multi_spread <- function(df, key, value) {
  # quote key
  keyq <- rlang::enquo(key)
  # break value vector into quotes
  valueq <- rlang::enquo(value)
  s <- rlang::quos(!!valueq)
  df %>% gather(variable, value, !!!s) %>%
    unite(temp, !!keyq, variable) %>%
    spread(temp, value)
}

#Make population variables by age(below vs above 60), gender, and urban
data_state_AgeGroup_3 <- data_state_age %>% 
  mutate(above60 = cut(Age, breaks = c(-Inf, 60, 100, 999), labels = c('0-60','>60','Notstated_'))) %>%  
  #select(state_name, Age, above60, Total) %>%
  group_by(state_name, above60) %>%
  summarise(TotalMales=sum(TotalMales), 
            TotalFemales=sum(TotalFemales),
            RuralPersons=sum(RuralPersons), 
            RuralMales=sum(RuralMales),
            RuralFemales=sum(RuralFemales),
            UrbanPersons=sum(UrbanPersons),
            UrbanMales=sum(UrbanMales),
            UrbanFemales=sum(UrbanFemales)) %>%
  filter(above60 != 'Notstated_') %>%
  multi_spread(key = above60, value = c(TotalMales, TotalFemales, RuralPersons, RuralMales,
                                        RuralFemales, UrbanPersons, UrbanMales, UrbanFemales)) 
#View(data_state_AgeGroup_3)

#Check every 'state_name' values are the same between newly defined data frames.
all(data_state_AgeGroup_$state_name == data_state_AgeGroup_3$state_name)

#Combine all newly defined data frames.
data_state_AgeGroup <- left_join(data_state_AgeGroup_, data_state_AgeGroup_2, 
                                 by = c('state_name'='state_name')) %>% 
  left_join(data_state_AgeGroup_3, by = c('state_name'='state_name')) %>%
  select(-Notstated_) 

#add 'age_' to the age variables.
names(data_state_AgeGroup)[2:38] <- paste0('age_', names(data_state_AgeGroup)[2:38])


#Add 'Dadra and Nagar Haveli and Daman and Diu' row.
a <- data_state_AgeGroup %>% filter(state_name == "Dadra & Nagar Haveli UT")
b <- data_state_AgeGroup %>% filter(state_name == "Daman & Diu UT")

colSums(rbind(a,b)[,2:38])

newrow <- cbind(
  data.frame("Dadra and Nagar Haveli and Daman and Diu"),
  t(matrix(colSums(rbind(a,b)[,2:38]))))

names(newrow) <- names(data_state_AgeGroup)

data_state_AgeGroup <- rbind(data_state_AgeGroup, newrow)

#Remove rows with "Dadra & Nagar Haveli UT" or "Daman & Diu UT"
data_state_AgeGroup <- data_state_AgeGroup[!(data_state_AgeGroup$state_name %in% c("Dadra & Nagar Haveli UT", "Daman & Diu UT")), ]

#Add newly defined age variables to 'data_state'
data_state <- left_join(data_state, data_state_AgeGroup, by = c('state_name'='state_name'))

names(data_state)


##Second, make age variables of 'data_dist'  ------------------------------

#Make 'AgeGroup' variable
data_dist_AgeGroup_ <- data_dist_age %>% 
  mutate(AgeGroup = cut(Age,
                        breaks = c(-Inf,4,9,14,19,24,29,34,39,44,49,54,59,64,69,74,79,84,100,999),
                        labels = c('0-4', '5-9', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', '40-44', '45-49', 
                                   '50-54', '55-59', '60-64', '65-69', '70-74', '75-79', '80-84', '85+', 'Notstated'))) %>%
  select(Area, Age, AgeGroup, Total) %>%
  group_by(Area, AgeGroup) %>%
  summarise(Total = sum(Total)) %>%
  spread (key = AgeGroup, value = Total)
#View(data_dist_AgeGroup_)

#Split age by 60.
data_dist_AgeGroup_2 <- data_dist_age %>% 
  mutate(above60 = cut(Age, breaks = c(-Inf, 60, 100, 999), labels = c('0-60','>60','Notstated_'))) %>%
  select(Area, Age, above60, Total) %>%
  group_by(Area, above60) %>%
  summarise(tt = sum(Total))  %>% 
  spread (key = above60, value = tt)
#View(data_dist_AgeGroup_2)

#Define a new function that spreads multiple columns of data frame.
multi_spread <- function(df, key, value) {
  # quote key
  keyq <- rlang::enquo(key)
  # break value vector into quotes
  valueq <- rlang::enquo(value)
  s <- rlang::quos(!!valueq)
  df %>% gather(variable, value, !!!s) %>%
    unite(temp, !!keyq, variable) %>%
    spread(temp, value)
}

#Make population variables by age(below vs above 60), gender, and urban
data_dist_AgeGroup_3 <- data_dist_age %>% 
  mutate(above60 = cut(Age, breaks = c(-Inf, 60, 100, 999), labels = c('0-60','>60','Notstated_'))) %>%  
  #select(Area, Age, above60, Total) %>%
  group_by(Area, above60) %>%
  summarise(TotalMales=sum(TotalMales), 
            TotalFemales=sum(TotalFemales),
            RuralPersons=sum(RuralPersons), 
            RuralMales=sum(RuralMales),
            RuralFemales=sum(RuralFemales),
            UrbanPersons=sum(UrbanPersons),
            UrbanMales=sum(UrbanMales),
            UrbanFemales=sum(UrbanFemales)) %>%
  filter(above60 != 'Notstated_') %>%
  multi_spread(key = above60, value = c(TotalMales, TotalFemales, RuralPersons, RuralMales,
                                        RuralFemales, UrbanPersons, UrbanMales, UrbanFemales))
#View(data_dist_AgeGroup_3)

#Check every values of 'Area' are the same for every newly defined data frames.
all(data_dist_AgeGroup_$Area == data_dist_AgeGroup_2$Area)

#Combine all newly defined data frames.
data_dist_AgeGroup <- left_join(data_dist_AgeGroup_, data_dist_AgeGroup_2, 
                                by = c('Area'='Area')) %>% 
  left_join(data_dist_AgeGroup_3, by = c('Area'='Area')) %>%
  select(-Notstated_) 

#add 'age_' to the age variables.
names(data_dist_AgeGroup)[2:38] <- paste0('age_', names(data_dist_AgeGroup)[2:38])

#Add newly defined variables to 'data_dist'
data_dist <- left_join(data_dist, data_dist_AgeGroup, by = c('Area'='Area'))

#Reorder columns of data_dist
names(data_dist)[c(17, 1:16, 18:68)]
data_dist <- data_dist[,c(17, 1:16, 18:68)]

#Before saving the final outputs, match state names of 'data_state' and 'data_dist'
#    to states of var_relevant_state.csv

# Andaman & Nicobar Islands UT -> "Andaman and Nicobar Islands"
# Chandigarh UT -> "Chandigarh"
# NCT of Delhi -> Delhi
# Jammu & Kashmir -> "Jammu and Kashmir"
# Lakshadweep UT -> "Lakshadweep"
# Puducherry UT -> "Puducherry"

#Update 'data_state' fist
data_state[data_state$state_name =="Andaman & Nicobar Islands UT",]$state_name <- 
  "Andaman and Nicobar Islands"
data_state[data_state$state_name =="Chandigarh UT",]$state_name <- 
  "Chandigarh"
data_state[data_state$state_name =="NCT of Delhi",]$state_name <- 
  "Delhi"
data_state[data_state$state_name =="Jammu & Kashmir",]$state_name <- 
  "Jammu and Kashmir"
data_state[data_state$state_name =="Lakshadweep UT",]$state_name <- 
  "Lakshadweep"
data_state[data_state$state_name =="Puducherry UT",]$state_name <- 
  "Puducherry"

#Next, update 'data_dist'.
data_dist[data_dist$state_name =="Andaman & Nicobar Islands UT",]$state_name <- 
  "Andaman and Nicobar Islands"
data_dist[data_dist$state_name =="Chandigarh UT",]$state_name <- 
  "Chandigarh"
data_dist[data_dist$state_name =="NCT of Delhi",]$state_name <- 
  "Delhi"
data_dist[data_dist$state_name =="Jammu & Kashmir",]$state_name <- 
  "Jammu and Kashmir"
data_dist[data_dist$state_name =="Lakshadweep UT",]$state_name <- 
  "Lakshadweep"
data_dist[data_dist$state_name =="Puducherry UT",]$state_name <- 
  "Puducherry"



#Save the final outputs in '3. census 2011' directory.

write.csv(data_state, "data_state.csv")
write.csv(data_dist, "data_dist.csv")
