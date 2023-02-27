gl main "Y:\Assistenter\Emma Gunnarsson 2021-\Elecricity_markets"
gl elspot "$main\Raw\Nord Pool\Elspot"
gl OP "$main\Raw\Nord Pool\Operating_data\Sweden"
gl output "$main\Output"
gl data "$main\processed_data"
gl LOG "$main\Log\Operating_data"

ssc install nrow


*Define time period:
local start_year				10
local latest_full_year			22
local years_with_53_weeks		20 15
local current_year 				23
local current_year_latest_week	3 		
local current_year_available_weeks	01 02 03  //Only runs if current_year_latest_week is below 9

*When adding data, redefine the locals above, then run the code. 
*When downloading more data, replace the very last week available in the old data with that week from the new data (in case the old data were downloaded in the middle of a week)
*Dont forget to create new folders for output when adding new years


********************************
**** Operating Data, Sweden ****
********************************
//Start year - Latest current year
forvalues y = `start_year'(1)`latest_full_year' {
log using "$LOG\pose_20`y'_w0152.log", replace
numlist "10(1)52"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	

	import delimited "$OP\20`y'\pose`y'`w'.sdv", clear
	drop if v4==""
	
	forvalues v = 1/7 {
		capture replace v`v'= "Code" if v`v'== "Kode"
		capture replace v`v'= "Year" if v`v'== "Aar"
		capture replace v`v'= "Week" if v`v'== "Uke"
		capture replace v`v'= "Date" if v`v'== "Dato"
		capture replace v`v'= "Day" if v`v'== "Dag"
		capture replace v`v'= "__Data_type" if v`v'== "# Datatype"
	}
	
	drop if v3!="20`y'" & v3!="Year"
	nrow	

	capture ren v6 Date
	capture rename v34 Total
	capture drop Total
	capture drop Sum
	capture rename Time* Hour*
	capture drop Hour3B
	capture rename Hour3A Hour3
	
	tab Code
	keep if Code=="WS" | Code=="WE" //Only interested in wind power
	
	tab Alias
	tab Day
	
	forvalues H=1/24 {
		destring Hour`H' , replace dpcomma
	}
	
	replace Day="Mon" if Day=="1"
	replace Day="Tue" if Day=="2"
	replace Day="Wed" if Day=="3"
	replace Day="Thur" if Day=="4"
	replace Day="Fri" if Day=="5"
	replace Day="Sat" if Day=="6"
	replace Day="Sun" if Day=="7"
	
	destring Year, replace
	save "$data\Operating_Data\Hour_Data\20`y'\pose`y'`w'.dta", replace
}	
log close
}
foreach y of local years_with_53_weeks {	
log using "$LOG\pose_20`y'_w0153.log", replace
numlist "10(1)53"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	

	import delimited "$OP\20`y'\pose`y'`w'.sdv", clear
	drop if v4==""
	
	forvalues v = 1/7 {
		capture replace v`v'= "Code" if v`v'== "Kode"
		capture replace v`v'= "Year" if v`v'== "Aar"
		capture replace v`v'= "Week" if v`v'== "Uke"
		capture replace v`v'= "Date" if v`v'== "Dato"
		capture replace v`v'= "Day" if v`v'== "Dag"
		capture replace v`v'= "__Data_type" if v`v'== "# Datatype"
	}
	
	drop if v3!="20`y'" & v3!="Year"
	nrow	

	capture ren v6 Date
	capture rename v34 Total
	capture drop Total
	capture drop Sum
	capture rename Time* Hour*
	capture drop Hour3B
	capture rename Hour3A Hour3
	
	tab Code
	keep if Code=="WS" | Code=="WE" //Only interested in wind power
	
	tab Alias
	tab Day
	
	forvalues H=1/24 {
		destring Hour`H' , replace dpcomma
	}
	
	replace Day="Mon" if Day=="1"
	replace Day="Tue" if Day=="2"
	replace Day="Wed" if Day=="3"
	replace Day="Thur" if Day=="4"
	replace Day="Fri" if Day=="5"
	replace Day="Sat" if Day=="6"
	replace Day="Sun" if Day=="7"
	
	destring Year, replace
	save "$data\Operating_Data\Hour_Data\20`y'\pose`y'`w'.dta", replace
}	
log close
}




// Current Year
log using "$LOG\pose_20`current_year'_w01`current_year_latest_week'.log", replace

if `current_year_latest_week' > 9 {
	numlist "10(1)`current_year_latest_week'"
	local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local nums {	
		display "Now working on Week `w'"
		import delimited "$OP\pose`current_year'`w'.sdv", clear
		drop if v4==""
		
		forvalues v = 1/7 {
			capture replace v`v'= "Code" if v`v'== "Kode"
			capture replace v`v'= "Year" if v`v'== "Aar"
			capture replace v`v'= "Week" if v`v'== "Uke"
			capture replace v`v'= "Date" if v`v'== "Dato"
			capture replace v`v'= "Day" if v`v'== "Dag"
			capture replace v`v'= "__Data_type" if v`v'== "# Datatype"
		}
		
		drop if v3!="20`current_year'" & v3!="Year"
		nrow	

		capture ren v6 Date
		capture rename v34 Total
		capture drop Total
		capture drop Sum
		capture rename Time* Hour*
		capture drop Hour3B
		capture rename Hour3A Hour3
		
		tab Code
		keep if Code=="WS" | Code=="WE" //Only interested in wind power
		
		tab Alias
		tab Day
		
		forvalues H=1/24 {
			destring Hour`H' , replace dpcomma
		}
		
		replace Day="Mon" if Day=="1"
		replace Day="Tue" if Day=="2"
		replace Day="Wed" if Day=="3"
		replace Day="Thur" if Day=="4"
		replace Day="Fri" if Day=="5"
		replace Day="Sat" if Day=="6"
		replace Day="Sun" if Day=="7"
		
		destring Year, replace
		save "$data\Operating_Data\Hour_Data\20`current_year'\pose`current_year_latest_week'`w'.dta", replace
}	
log close	
} 

if `current_year_latest_week' < 10 {
	foreach w of local current_year_available_weeks {	
		display "Now working on Week `w'"
		import delimited "$OP\pose`current_year'`w'.sdv", clear
		drop if v4==""
		
		forvalues v = 1/7 {
			capture replace v`v'= "Code" if v`v'== "Kode"
			capture replace v`v'= "Year" if v`v'== "Aar"
			capture replace v`v'= "Week" if v`v'== "Uke"
			capture replace v`v'= "Date" if v`v'== "Dato"
			capture replace v`v'= "Day" if v`v'== "Dag"
			capture replace v`v'= "__Data_type" if v`v'== "# Datatype"
		}
		
		drop if v3!="20`current_year'" & v3!="Year"
		nrow	

		capture ren v6 Date
		capture rename v34 Total
		capture drop Total
		capture drop Sum
		capture rename Time* Hour*
		capture drop Hour3B
		capture rename Hour3A Hour3
		
		tab Code
		keep if Code=="WS" | Code=="WE" //Only interested in wind power
		
		tab Alias
		tab Day
		
		forvalues H=1/24 {
			destring Hour`H' , replace dpcomma
		}
		
		replace Day="Mon" if Day=="1"
		replace Day="Tue" if Day=="2"
		replace Day="Wed" if Day=="3"
		replace Day="Thur" if Day=="4"
		replace Day="Fri" if Day=="5"
		replace Day="Sat" if Day=="6"
		replace Day="Sun" if Day=="7"
		
		destring Year, replace
		save "$data\Operating_Data\Hour_Data\20`current_year'\pose`current_year'`w'.dta", replace
}	
log close		
}


* All years (Hour data)
//Start year - Latest full year
	forvalues y = `start_year'(1)`latest_full_year' {
		use "$data\Operating_Data\Hour_Data\20`y'\pose`y'01.dta", clear
		numlist "10(1)52"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\Operating_Data\Hour_Data\20`y'\pose`y'`w'.dta"
			}
		drop __Data_type
		save "$data\Operating_Data\pose_`y'", replace
	}
	foreach y of local years_with_53_weeks {	
		use "$data\Operating_Data\Hour_Data\20`y'\pose`y'01.dta", clear
		numlist "10(1)53"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\Operating_Data\Hour_Data\20`y'\pose`y'`w'.dta"
			}
		drop __Data_type 
		save "$data\Operating_Data\pose_`y'", replace
	}
//Current year
if `current_year_latest_week' > 9 {
	use "$data\Operating_Data\Hour_Data\20`current_year'\pose`current_year'01.dta", clear
		numlist "10(1)`current_year_latest_week'"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\Operating_Data\Hour_Data\20`current_year'\pose`current_year'`w'.dta"
			}
		drop __Data_type 
		save "$data\Operating_Data\pose_`current_year'", replace
}
if `current_year_latest_week' < 10 {
		foreach w of local current_year_available_weeks {		
			if `w'==01 {
				use "$data\Operating_Data\Hour_Data\20`current_year'\pose`current_year'01.dta", clear
			}
			else {
				append using "$data\Operating_Data\Hour_Data\20`current_year'\pose`current_year'`w'.dta"
			}	
		}
		drop __Data_type 
		save "$data\Operating_Data\pose_`current_year'", replace	
}



//Append years
	use "$data\Operating_Data\pose_`start_year'", clear
	local app_start `=`start_year'+1' 
	forvalues y = `app_start'(1)`current_year' {
		append using "$data\Operating_Data\pose_`y'.dta"
		erase "$data\Operating_Data\pose_`y'.dta"
	}
		erase "$data\Operating_Data\pose_`start_year'.dta"

		
	reshape long Hour , i(Code Year Week Day Date Alias) j(Hourr) 
		rename Hour pose
		rename Hourr Hour
	reshape wide pose, i(Year Week Day Date Alias Hour) j(Code) string
	rename poseWE wind_prognos_prod
	rename poseWS wind_settled_prod

	
//Correcting the Year-variable, sorting and more
	destring Week, replace
	bys Year: sum Week
	gen true_year = yofd(daily(Date, "DMY"))
	gen edate= date(Date, "DMY")
	drop Year
	rename true_year Year
	order Year Week Day Date edate Hour Alias
	sort Year Alias edate Hour

	bys Year: sum Week	
	bys Year: tab Alias
	sum Hour
	tab Date if Year==2014
	tab Date if Year==2019
	tab Date if Year==2023
	
	save "$data\Operating_Data\Hour_Data\pose_y`start_year'_y`current_year'", replace










 