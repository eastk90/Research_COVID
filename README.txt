Description on Files

outcome/api.covid19india.org_24th_Mar_2021.csv : URLs in API data. It will be used in 'IndiaAPR.R'

outcome/var_relevant_list.xlsx : list of relevant variables in API data.

outcome/var_relevant_state.csv : Values of the relevant variables from API data. Rows are states, and columns are relevant variables.
                         Created in R.

outcome/raw_data_combined.csv : Combined all raw datasets. ()

outcome/district_for_comparison.csv : Files for district comparison across Census and Covid19 districts. 7 states are randomly selected.

outcome/district_comparison_results.xlsx : The results of the comparision is saved in this file.

'1. beds and ventilators/hospital_capacity.csv' : hospital capacities table from 'State-wise-estimates-of-current-beds-and-ventilators_24Apr2020.pdf'
			In the second row from the last, 'Dadra and Nagar Haveli and Daman and Diu' was added because other state-level datasets combined the two states.
			The last row is assumptions for each variable.

'power calculation/power_cal_results.docx' : power calculation results.

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

-'hospital_capacity.csv' was generated from 'State-wise-estimates-of-current-beds-and-ventilators_24Apr2020.pdf'.
-Since this file is also state-level, its information was added to 'var_relevant_list.xlsx' and 'var_relevant_state.csv'.
-'Dadra and Nagar Haveli' and 'Daman and Diu' are separate columns in the original dataset. However, in the outcome dataset, they are one combined state.
 Therefore, I added a row whose state is 'Dadra and Nagar Haveli and Daman and Diu'.
-'var_relevant_state.csv' is updated using R code (IndiaAPI.R)
-New row was added to 'var_relevant_state.csv', which is assumption. The row indicates assumption for each variable.

Updates
05/12/2021
Re-organize file locations
-Three folders were generated : '1. beds and ventilators', '2. national health profile 2019', and 'powr calculation'
-Some files are moved to the corresponding locations.
-R code ('IndiaAPI.R') has been updated so that new location is correctly allocated.
-README.txt file was moved from 'Research_COVID/outcome' to 'Research_COVID'.


-'national_health_profile_state.csv' and 'national_health_profile_agegroup.csv' were generated from 'National Health provile 2019.pdf'.
	1. Ladakh is not listed at all in 'National Health provile 2019.pdf'.
	2. 'Dadra and Nagar Haveli' and 'Daman and Diu' are separate columns in the original dataset. 
	   However, in the outcome dataset, they are one combined state.
	   Therefore, I added a row whose state is 'Dadra and Nagar Haveli and Daman and Diu'.
	3. Summation or weighted average was used to combined data.
	   For the weighted average, '1.1.3 2018 projected population' by sex was used.
		-sum
		 numer of population
		 disease cases and deaths
		 4.1.4 public expenditure
		 4.1.5 Expendit ure on Health
		   : Per Capita Health Expenditure (Rs) is calculated as indicated in the table.

		-average
		  death rate
		  infant mortality rate
		  literacy rate
		  Maternity Care

-'var_relevant_list.xlsx was removed.' Instead, 'Variable list.xlsx' was generated, but still being updated...
