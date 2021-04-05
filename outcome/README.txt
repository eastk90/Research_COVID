Description on Files

api.covid19india.org_24th_Mar_2021.csv : URLs in API data. It will be used in 'IndiaAPR.R'

var_relevant_list.xlsx : list of relevant variables in API data.

var_relevant_state.csv : Values of the relevant variables from API data. Rows are states, and columns are relevant variables.
                         Created in R.


Updates
04/04/2021
-Goal : To update R code so that raw_data sets are loaded automatically without updating 'api.covid19india.org_24th_Mar_2021.csv' at all.

1. Remove raw_data rows in 'api.covid19india.org_24th_Mar_2021.csv'

2. Update 'IndiaAPI.R'
	-From the webpage, https://api.covid19india.org, get all urls related to raw_data
	-Using the urls, make a dataframe whose structure is equivalent to 'api.covid19india.org_24th_Mar_2021.csv' except 'Description' column.
	-The new dataframe is named `links_rawdata`.
	-Using `links` and `links_rawdata`, download and load files.
	-`links` is still 'api.covid19india.org_24th_Mar_2021.csv'.

-Goal : To select necessary columns from `raw_data_combined` and save them.
'IndiaAPI.R' is updated and the new version of "outcome/raw_data_combined.csv" is saved.