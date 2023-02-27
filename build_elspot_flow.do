gl main "Y:\Assistenter\Emma Gunnarsson 2021-\Elecricity_markets"
gl elspot "$main\Raw\Nord Pool\Elspot"
gl output "$main\Output"
gl data "$main\processed_data"
gl LOG "$main\Log\Elspot"


ssc install nrow

*Define time period:
local start_year				12
local latest_full_year			22
local years_with_53_weeks		20 15
local current_year 				23
local current_year_latest_week	3
local current_year_available_weeks	01 02 03  //Only runs if current_year_latest_week is below 9


*When adding data, redefine the locals above, then run the code. 
*When downloading more data, replace the very last week available in the old data with that week from the new data (in case the old data were downloaded in the middle of a week)
*Dont forget to create new folders for output when adding new years


*********************
**** Elspot Flow ****
*********************
//Start year - Latest current year
forvalues y = `start_year'(1)`latest_full_year' {
log using "$LOG\flow_20`y'_w0152.log", replace
numlist "10(1)52"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	
	display "Now working on Week `w'"
	import delimited "$elspot\Elspot_flow\20`y'\sflo`y'`w'.sdv", clear
	drop if v4==""
	drop if v3!="20`y'" & v3!="Year"
	nrow	
	
	capture ren v6 Date
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
foreach y of local years_with_53_weeks {	
log using "$LOG\flow_20`y'_w0153.log", replace
numlist "10(1)53"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	
	display "Now working on Week `w'"
	import delimited "$elspot\Elspot_flow\20`y'\sflo`y'`w'.sdv", clear
	drop if v4==""
	drop if v3!="20`y'" & v3!="Year"
	nrow	
	
	capture ren v6 Date
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


// Current Year
log using "$LOG\flow_20`current_year'_w01`current_year_latest_week'.log", replace

if `current_year_latest_week' > 9 {
	numlist "10(1)`current_year_latest_week'"
	local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local nums {	
		display "Now working on Week `w'"
		import delimited "$elspot\Elspot_flow\sflo`current_year'`w'.sdv", clear
		drop if v4==""
		drop if v3!="20`current_year'" & v3!="Year"
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
		
		save "$data\Flows\Hour_Data\20`current_year'\sflo`current_year'`w'.dta", replace
	}
	log close
}

if `current_year_latest_week' < 10 {
	foreach w of local current_year_available_weeks {		
		display "Now working on Week `w'"
		import delimited "$elspot\Elspot_flow\sflo`current_year'`w'.sdv", clear
		drop if v4==""
		drop if v3!="20`current_year'" & v3!="Year"
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
		
		save "$data\Flows\Hour_Data\20`current_year'\sflo`current_year'`w'.dta", replace
	}
	log close	
}




**All years (Hour data)
//Start year - Latest current year
forvalues y = `start_year'(1)`latest_full_year' {
		use "$data\Flows\Hour_Data\20`y'\sflo`y'01.dta", clear
		numlist "10(1)52"
		local weeks  02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\Flows\Hour_Data\20`y'\sflo`y'`w'.dta"
			}
		drop __Data_type Code
		save "$data\Flows\flow_`y'", replace
	}
foreach y of local years_with_53_weeks {	
		use "$data\Flows\Hour_Data\20`y'\sflo`y'01.dta", clear
		numlist "10(1)53"
		local weeks  02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\Flows\Hour_Data\20`y'\sflo`y'`w'.dta"
			}
		drop __Data_type Code
		save "$data\Flows\flow_`y'", replace
	}
	
//Current Year
if `current_year_latest_week' > 9 {
	use "$data\Flows\Hour_Data\20`current_year'\sflo`current_year'01.dta", clear
		numlist "10(1)`current_year_latest_week'"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\Flows\Hour_Data\20`current_year'\sflo`current_year'`w'.dta"
			}
		drop __Data_type Code
		save "$data\Flows\flow_`current_year'", replace
}
if `current_year_latest_week' < 10 {
		foreach w of local current_year_available_weeks {	
			if `w'==01 {
				use "$data\Flows\Hour_Data\20`current_year'\sflo`current_year'01.dta", clear
			}
			else {
				append using "$data\Flows\Hour_Data\20`current_year'\sflo`current_year'`w'.dta"
			}	
		}
		drop __Data_type Code
		save "$data\Flows\flow_`current_year'", replace
}


//Append years
	use "$data\Flows\flow_`start_year'", clear
	local app_start `=`start_year'+1' 
	forvalues y = `app_start'(1)`current_year' {
		append using "$data\Flows\flow_`y'.dta"
		erase "$data\Flows\flow_`y'.dta"
	}
		erase "$data\Flows\flow_`start_year'.dta"
	




//Correcting the Year-variable, sorting and more
	drop Sum
	reshape long Hour , i(Year Week Day Date Alias) j(Hourr) 
	rename Hour flow_mwh
	rename Hourr Hour
	destring Week, replace
	bys Year: sum Week
	gen true_year = yofd(daily(Date, "DMY"))
	gen edate= date(Date, "DMY")
	drop Year
	sort true_year edate Hour
	rename true_year Year
	order Year Week Day Date edate Hour Alias

	bys Year: sum Week
	
save "$data\Flows\Hour_Data\flows_y`start_year'_y`current_year'", replace














