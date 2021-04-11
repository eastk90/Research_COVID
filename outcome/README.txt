Description on Files

api.covid19india.org_24th_Mar_2021.csv : URLs in API data. It will be used in 'IndiaAPR.R'

var_relevant_list.xlsx : list of relevant variables in API data.

var_relevant_state.csv : Values of the relevant variables from API data. Rows are states, and columns are relevant variables.
                         Created in R.

raw_data_combined.csv : Combined all raw datasets. ()

district_for_comparison.csv : Files for district comparison across Census and Covid19 districts. 7 states are randomly selected.

district_comparison_results.xlsx : The results of the comparision is saved in this file.

hospital_capacity.csv : hospital capacities table from 'State-wise-estimates-of-current-beds-and-ventilators_24Apr2020.pdf'
			In the second row from the last, 'Dadra and Nagar Haveli and Daman and Diu' was added because other state-level datasets combined the two states.
			The last row is assumptions for each variable.

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

Updates
04/10/2021
-Goal : To compare the list of districts between Census and Covid19.
-For the comparison, districts from seven states(randomly selected) are used.
-Results are saved in district_comparison_results.xlsx.

-hospital_capacity.csv' was generated from 'State-wise-estimates-of-current-beds-and-ventilators_24Apr2020.pdf'.
-Since this file is also state-level, its information was added to 'var_relevant_list.xlsx' and 'var_relevant_state.csv'.
-'var_relevant_state.csv' is updated using R code (IndiaAPI.R)
-New row was added to 'var_relevant_state.csv', which is assumption. The row indicates assumption for each variable.