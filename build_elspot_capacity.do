gl main "Y:\Assistenter\Emma Gunnarsson 2021-\Elecricity_markets"
gl elspot "$main\Raw\Nord Pool\Elspot"
gl output "$main\Output"
gl data "$main\processed_data"
gl LOG "$main\Log"

ssc install nrow


*Define time period:
local start_year				00
local start_years				01 02 03 04 05 06 07 08 09
local latest_full_year			22
local years_with_53_weeks		20 15 09 04
local current_year 				23
local current_year_latest_week	7
local current_year_available_weeks	01 02 03  04 05 06 07 //Only runs if current_year_latest_week is below 9 


*When adding data, redefine the locals above, then rerun the code
*When downloading more data, replace the very last week available in the old data with that week from the new data (in case the old data were downloaded in the middle of a week)

*Creating Hour_data for 2000, 2001-2011 is largely hard coded due to irregularities in the data.
*However, the locals above matter for the Year_data, all years
* THe locals above also matter for creting Hour_data for years 2012 and so on


*********************
** Elspot Capacity **
*********************

//Year 2000
	log using "$LOG\capacity_2000_w0138.log", replace
	numlist "10(1)38"
	local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local nums {	

		display "Now working on Week `w'"
		import delimited "$elspot\Elspot_capacity\2000\scap00`w'.sdv", clear
		drop if v4==""
		drop if v3!="2000" & v3!="Aar"
		nrow	

		replace Kode="Day ahead flow" if Kode=="D"
		replace __Datatype="Exchange capacity (MWh/h)" if __Datatype=="UE"
		drop if __Datatype=="CR"

		keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden
		
		rename __Datatype __Data_type
		rename Kode Code
		rename Aar Year
		rename Uke Week
		rename Dag Day
		rename Dato Date
			forvalues s = 1(1)24 {
				rename Time`s' Hour`s'
			}
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
		save "$data\Capacity\Hour_Data\2000\scap00`w'.dta", replace
	}
	log close
	log using "$LOG\capacity_2000_w3952.log", replace
	forvalues  w = 39(1)52 {	
		display "Now working on Week `w'"
		import delimited "$elspot\Elspot_capacity\2000\scap00`w'.sdv", clear
		capture tostring v32, replace
		replace v32="Sum" if v32=="."
		drop if v3!="2000" & v3!="Year"
		nrow	
		capture drop  v34 v35
		replace Code="Day ahead flow" if Code=="D"
		replace __Data_type="Exchange capacity (MWh/h)" if __Data_type=="UE"
		drop if __Data_type=="CR"

		keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden

		tab Alias

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
		save "$data\Capacity\Hour_Data\2000\scap00`w'.dta", replace
	}
	log close
*Year 2001 - 2011
	local yearss 01 02 03 04 05 06 07 08 09 10 11 
	foreach y of local yearss {	

	log using "$LOG\capacity_20`y'_w0152.log", replace
	numlist "10(1)52"
	local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local nums {	
		display "Now working on Week `w'"
		import delimited "$elspot\Elspot_capacity\20`y'\scap`y'`w'.sdv", clear
		capture tostring v32, replace
		replace v32="Sum" if v32=="."
		drop if v3!="20`y'" & v3!="Year"
		nrow	
		capture ren v6 Date
		capture drop  v34 v35
		replace Code="Day ahead flow" if Code=="D"
		replace __Data_type="Exchange capacity (MWh/h)" if __Data_type=="UE"
		drop if __Data_type=="CR"

		keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden

		tab Alias
		
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
		save "$data\Capacity\Hour_Data\20`y'\scap`y'`w'.dta", replace
	}
	log close
	}
	

*Year 2012 -latest_full_year
	forvalues y = 12(1)`latest_full_year'  {	
	log using "$LOG\capacity_20`y'_w0152.log", replace
	numlist "10(1)52"
	local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local nums {	
		display "Now working on Week `w'"
		import delimited "$elspot\Elspot_capacity\20`y'\scap`y'`w'.sdv", clear
		capture tostring v32, replace
		replace v32="Sum" if v32=="."
		drop if v3!="20`y'" & v3!="Year"
		nrow	
		capture ren v6 Date
		capture drop  v34 v35
		capture drop Hour3B
		capture rename Hour3A Hour3
		replace Code="Day ahead flow" if Code=="D"
		replace __Data_type="Exchange capacity (MWh/h)" if __Data_type=="UE"
		drop if __Data_type=="CR"

		keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden

		tab Alias
		
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
		save "$data\Capacity\Hour_Data\20`y'\scap`y'`w'.dta", replace
	}
	log close
	}
	foreach y of local years_with_53_weeks {	
		log using "$LOG\capacity_20`y'_w0153.log", replace
		numlist "10(1)53"
		local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
		foreach w of local nums {	
			display "Now working on Week `w'"
			import delimited "$elspot\Elspot_capacity\20`y'\scap`y'`w'.sdv", clear
			capture tostring v32, replace
			replace v32="Sum" if v32=="."
			drop if v3!="20`y'" & v3!="Year"
			nrow	
			capture ren v6 Date
			capture drop  v34 v35
			capture drop Hour3B
			capture rename Hour3A Hour3
			replace Code="Day ahead flow" if Code=="D"
			replace __Data_type="Exchange capacity (MWh/h)" if __Data_type=="UE"
			drop if __Data_type=="CR"

			keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden

			tab Alias
			
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
			save "$data\Capacity\Hour_Data\20`y'\scap`y'`w'.dta", replace
		}
		log close
		}
		

*Current Year
if `current_year_latest_week' > 9 {

	log using "$LOG\capacity_20`current_year'_w01`current_year_latest_week'.log", replace
	numlist "10(1)`current_year_latest_week'"
	local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local nums {
		display "Now working on Week `w'"	
		import delimited "$elspot\Elspot_capacity\scap`current_year'`w'.sdv", clear
		drop if v4==""
		drop if v3!="20`current_year'" & v3!="Year"

		nrow
		capture ren v6 Date
		capture drop Hour3B
		capture rename Hour3A Hour3
		replace Code="Day ahead flow" if Code=="D"
		replace __Data_type="Exchange capacity (MWh/h)" if __Data_type=="UE"
		drop if __Data_type=="CR"

		keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden
		
		tab Alias

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
		save "$data\Capacity\Hour_Data\20`current_year'\scap`current_year'`w'.dta", replace
	}
	log close
}
if `current_year_latest_week' < 10 {
	log using "$LOG\capacity_20`current_year'_w01`current_year_latest_week'.log", replace
	foreach w of local current_year_available_weeks {	
		display "Now working on Week `w'"	
		import delimited "$elspot\Elspot_capacity\scap`current_year'`w'.sdv", clear
		drop if v4==""
		drop if v3!="20`current_year'" & v3!="Year"

		nrow
		capture ren v6 Date
		capture drop Hour3B
		capture rename Hour3A Hour3
		replace Code="Day ahead flow" if Code=="D"
		replace __Data_type="Exchange capacity (MWh/h)" if __Data_type=="UE"
		drop if __Data_type=="CR"

		keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden
		
		tab Alias

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
		save "$data\Capacity\Hour_Data\20`current_year'\scap`current_year'`w'.dta", replace
	}
	log close	
}


**All years (Hour data)
//APPEND to Years 2000-latest full year
	numlist "10(1)`latest_full_year'"
	local yearss `start_year' `start_years' `r(numlist)'
	foreach y of local yearss {		
	use "$data\Capacity\Hour_Data\20`y'\scap`y'01.dta", clear
		numlist "10(1)52"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
		foreach w of local weeks {	
			append using "$data\Capacity\Hour_Data\20`y'\scap`y'`w'.dta"
		}
			save "$data\Capacity\capacity_`y'.dta", replace
	}	
	foreach y of local years_with_53_weeks {	
	use "$data\Capacity\Hour_Data\20`y'\scap`y'01.dta", clear
		numlist "10(1)53"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
		foreach w of local weeks {	
			append using "$data\Capacity\Hour_Data\20`y'\scap`y'`w'.dta"
		}
			save "$data\Capacity\capacity_`y'.dta", replace
	}	

//Current year
if `current_year_latest_week' > 9 {
		numlist "10(1)`current_year_latest_week'"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
		use "$data\Capacity\Hour_Data\20`current_year'\scap`current_year'01.dta", clear
		foreach w of local weeks {	
			append using "$data\Capacity\Hour_Data\20`current_year'\scap`current_year'`w'.dta"
		}
			save "$data\Capacity\capacity_`current_year'.dta", replace
}
if `current_year_latest_week' < 10 {
		foreach w of local current_year_available_weeks {		
			if `w'==01 {
				use "$data\Capacity\Hour_Data\20`current_year'\scap`current_year'01.dta", clear
			}
			else {
				append using "$data\Capacity\Hour_Data\20`current_year'\scap`current_year'`w'.dta"
			}					
		}
		save "$data\Capacity\capacity_`current_year'.dta", replace
}

//Append years to one single dataset start year-current year
		use "$data\Capacity\capacity_`start_year'.dta", clear

		numlist "10(1)`current_year'"
		local years `start_years' `r(numlist)'
		foreach y of local years {	
			append using "$data\Capacity\capacity_`y'.dta"
			erase "$data\Capacity\capacity_`y'.dta"
		}
		erase "$data\Capacity\capacity_`start_year'.dta"
		
		
//Correcting the Year-variable, sorting and more
	drop _ Sum
	destring Week, replace
	bys Year: sum Week
	gen true_year = yofd(daily(Date, "DMY"))
	gen edate= date(Date, "DMY")
	drop Year
	sort true_year edate 
	rename true_year Year
	
	egen cap_max_date=rowmax(Hour*)
	label var cap_max_date "Maximum capacity (mwh) particualr date"
	
	reshape long Hour  , i(Year Week Day Date Alias cap_max_date) j(Hourr) 
	rename Hour cap_mwh
	rename Hourr Hour
	order Year Week Day Date edate Hour Alias __Data_type Code cap_mwh cap_max_date
	label var cap_mwh "Capacity (mwh) by hour"

	save "$data\Capacity\Year_Data\capacity_y`start_year'_y`current_year'", replace

	