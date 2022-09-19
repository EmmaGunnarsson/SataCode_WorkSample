gl main "Y:\Emma Gunnarsson 2021-\Nord Pool Data"
gl elspot "$main\Raw\Elspot"
gl output "$main\Output"
gl data "$main\processed_data"
gl LOG "$main\Log"


ssc install nrow

*When adding data, increase the max number in the relevant numlists. 
*When downloading more data, replace the very last week available in the old data with that week from the new data (in case the old data were downloaded in the middle of a week)

*********************
**** Elspot Flow ****
*********************

//year 2012 - 2021
forvalues y = 12(1)21  {	

log using "$LOG\flow_20`y'_w0152.log", replace
numlist "10(1)52"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	
	display "Now working on Week `w'"
	import delimited "$elspot\Elspot_flow\20`y'\sflo`y'`w'.sdv", clear
	drop if v4==""
	drop if v3!="20`y'" & v3!="Year"
	nrow	
	
	ren v6 Date

	capture drop Hour3B
	capture rename Hour3A Hour3
	keep if Code=="D" 
	replace Code="Day ahead flow" if Code=="D"
	replace __Data_type="Day-ahead flow (MWh/h)" if __Data_type=="FE"

	keep if  strpos(Alias,  "SE") 	//Keep only those flows including Sweden
	
	tab Alias
	tab Day
	
	forvalues H=1/24 {
		destring Hour`H' , replace dpcomma
	}
	destring Sum, replace dpcomma
	
	replace Day="Mon" if Day=="1"
	replace Day="Tue" if Day=="2"
	replace Day="Wed" if Day=="3"
	replace Day="Thur" if Day=="4"
	replace Day="Fri" if Day=="5"
	replace Day="Sat" if Day=="6"
	replace Day="Sun" if Day=="7"
	
	destring Year, replace
	
	save "$data\Flows\Hour_Data\20`y'\sflo`y'`w'.dta", replace
}
log close
}
// 2022
log using "$LOG\flow_2022_w0135.log", replace
numlist "10(1)37"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	
	display "Now working on Week `w'"
	import delimited "$elspot\Elspot_flow\sflo22`w'.sdv", clear
	drop if v4==""
	drop if v3!="2022" & v3!="Year"
	nrow	
	
	ren v6 Date

	capture drop Hour3B
	capture rename Hour3A Hour3
	keep if Code=="D" 
	replace Code="Day ahead flow" if Code=="D"
	replace __Data_type="Day-ahead flow (MWh/h)" if __Data_type=="FE"

	keep if  strpos(Alias,  "SE") 	//Keep only those flows including Sweden
	
	tab Alias
	tab Day
	
	forvalues H=1/24 {
		destring Hour`H' , replace dpcomma
	}
	destring Sum, replace dpcomma
	
	replace Day="Mon" if Day=="1"
	replace Day="Tue" if Day=="2"
	replace Day="Wed" if Day=="3"
	replace Day="Thur" if Day=="4"
	replace Day="Fri" if Day=="5"
	replace Day="Sat" if Day=="6"
	replace Day="Sun" if Day=="7"
	
	destring Year, replace
	
	save "$data\Flows\Hour_Data\2022\sflo22`w'.dta", replace
}
log close

**All years (Hour data)
//2012 - 2021
	forvalues y = 12(1)21 {
		use "$data\Flows\Hour_Data\20`y'\sflo`y'01.dta", clear
		numlist "10(1)52"
		local weeks  02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\Flows\Hour_Data\20`y'\sflo`y'`w'.dta"
			}
		drop __Data_type Code
		save "$data\Flows\flow_`y'", replace
	}
//2022
use "$data\Flows\Hour_Data\2022\sflo2201.dta", clear
		numlist "10(1)37"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\Flows\Hour_Data\2022\sflo22`w'.dta"
			}
		drop __Data_type Code
		save "$data\Flows\flow_22", replace
//Append years
	use "$data\Flows\flow_12", clear
	forvalues y = 13(1)22 {
	append using "$data\Flows\flow_`y'.dta"
	erase "$data\Flows\flow_`y'.dta"
	}
	erase "$data\Flows\flow_12.dta"
	
	drop Sum
	
	reshape long Hour , i(Year Week Day Date Alias) j(Hourr) 
	rename Hour flow_mwh
	rename Hourr Hour

	save "$data\Flows\Hour_Data\flows_y12_y22", replace





















