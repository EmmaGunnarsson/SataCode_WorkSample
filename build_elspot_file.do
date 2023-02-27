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
**** Elspot File ****
*********************
//Start year - Latest current year
forvalues y = `start_year'(1)`latest_full_year' {
log using "$LOG\spot_20`y'_w0152.log", replace
numlist "10(1)52"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	
	display "Now working on Week `w'"
	import delimited "$elspot\Elspot_file\20`y'\spot`y'`w'.sdv", clear
	drop if v4==""
	drop if v3!="20`y'" & v3!="Year"
	nrow	


	capture ren v6 Date
	capture rename v34 Total
	drop Total
	capture drop Hour3B
	capture rename Hour3A Hour3
	
	tab Unit
	keep if Unit == "SEK" | Unit== "EUR" | Unit== "MWh/h"
	tab Code
	
	tab Alias

	drop if Code=="SF" //Preliminary exchange rate (finns inte i början av tisperioden)

	*keep if  strpos(Alias,  "SE") 	//Keep only those  including Sweden
	
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
	save "$data\File\Hour_Data\20`y'\spot`y'`w'.dta", replace
}	
log close
}
foreach y of local years_with_53_weeks {	
log using "$LOG\spot_20`y'_w0153.log", replace
numlist "10(1)53"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	
	display "Now working on Week `w'"
	import delimited "$elspot\Elspot_file\20`y'\spot`y'`w'.sdv", clear
	drop if v4==""
	drop if v3!="20`y'" & v3!="Year"
	nrow	


	capture ren v6 Date
	capture rename v34 Total
	drop Total
	capture drop Hour3B
	capture rename Hour3A Hour3
	
	tab Unit
	keep if Unit == "SEK" | Unit== "EUR" | Unit== "MWh/h"
	tab Code
	
	tab Alias

	drop if Code=="SF" //Preliminary exchange rate (finns inte i början av tisperioden)

	*keep if  strpos(Alias,  "SE") 	//Keep only those  including Sweden
	
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
	save "$data\File\Hour_Data\20`y'\spot`y'`w'.dta", replace
}	
log close
}

// Current Year
log using "$LOG\spot_20`current_year'_w01`current_year_latest_week'.log", replace

if `current_year_latest_week' > 9 {
	numlist "10(1)`current_year_latest_week'"
	local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local nums {	
		display "Now working on Week `w'"
		import delimited "$elspot\Elspot_file\spot`current_year'`w'.sdv", clear
		drop if v4==""
		drop if v3!="20`current_year'" & v3!="Year"
		nrow	

		capture ren v6 Date
		capture rename v34 Total
		drop Total
		capture drop Hour3B
		capture rename Hour3A Hour3
		
		tab Unit
		keep if Unit == "SEK" | Unit== "EUR" | Unit== "MWh/h"
		tab Code
		
		drop if Code=="SF" //Preliminary exchange rate (finns inte i början av tisperioden)

		*keep if  strpos(Alias,  "SE") 	//Keep only those  including Sweden
		
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
		save "$data\File\Hour_Data\20`current_year'\spot`current_year'`w'.dta", replace
	}	
	log close
}
if `current_year_latest_week' < 10 {
	foreach w of local current_year_available_weeks {		
		display "Now working on Week `w'"
		import delimited "$elspot\Elspot_file\spot`current_year'`w'.sdv", clear
		drop if v4==""
		drop if v3!="20`current_year'" & v3!="Year"
		nrow	

		capture ren v6 Date
		capture rename v34 Total
		drop Total
		capture drop Hour3B
		capture rename Hour3A Hour3
		
		tab Unit
		keep if Unit == "SEK" | Unit== "EUR" | Unit== "MWh/h"
		tab Code
		
		drop if Code=="SF" //Preliminary exchange rate (finns inte i början av tisperioden)

		*keep if  strpos(Alias,  "SE") 	//Keep only those  including Sweden
		
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
		save "$data\File\Hour_Data\20`current_year'\spot`current_year'`w'.dta", replace
	}	
	log close	
}

* All years (Hour data)
//Start year - Latest current year
	forvalues y = `start_year'(1)`latest_full_year' {
		use "$data\File\Hour_Data\20`y'\spot`y'01.dta", clear
		numlist "10(1)52"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\File\Hour_Data\20`y'\spot`y'`w'.dta"
			}
		save "$data\File\spot_`y'", replace
	}
	foreach y of local years_with_53_weeks {	
		use "$data\File\Hour_Data\20`y'\spot`y'01.dta", clear
		numlist "10(1)53"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\File\Hour_Data\20`y'\spot`y'`w'.dta"
			}
		save "$data\File\spot_`y'", replace
	}
//Current year
if `current_year_latest_week' > 9 {
	use "$data\File\Hour_Data\20`current_year'\spot`current_year'01.dta", clear
		numlist "10(1)`current_year_latest_week'"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\File\Hour_Data\20`current_year'\spot`current_year'`w'.dta"
			}
		save "$data\File\spot_`current_year'", replace
}
if `current_year_latest_week' < 10 {
		foreach w of local current_year_available_weeks {	
			if `w'==01 {
				use "$data\File\Hour_Data\20`current_year'\spot`current_year'01.dta", clear
			}
			else {
				append using "$data\File\Hour_Data\20`current_year'\spot`current_year'`w'.dta"
			}	
		}
		save "$data\File\spot_`current_year'", replace
}

//Append years
	use "$data\File\spot_`start_year'", clear
	local app_start `=`start_year'+1' 
	forvalues y = `app_start'(1)`current_year' {
		append using "$data\File\spot_`y'.dta"
		erase "$data\File\spot_`y'.dta"
	}
		erase "$data\File\spot_`start_year'.dta"

	drop __Data_type 
	reshape long Hour , i(Code Unit Year Week Day Date Alias) j(Hourr) 
		rename Hour file
		rename Hourr Hour
	replace Unit = "mwh" if Unit=="MWh/h"
	gen J = Code + Unit
	drop Code Unit
	reshape wide file, i(Year Week Day Date Alias Hour) j(J) string
	rename fileSKmwh Purch_mwh
	rename fileSOSEK Price_SEK
	rename fileSOEUR Price_EUR
	rename fileSS Sales_mwh

//Correcting the Year-variable, sorting and more
	destring Week, replace
	bys Year: sum Week
	gen true_year = yofd(daily(Date, "DMY"))
	gen edate= date(Date, "DMY")
	drop Year
	sort true_year edate Hour
	rename true_year Year
	order Year Week Day Date edate Hour Alias

	bys Year: sum Week	

	
	save "$data\File\Year_data\spot_y`start_year'_y`current_year'", replace




