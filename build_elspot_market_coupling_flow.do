gl main "Y:\Assistenter\Emma Gunnarsson 2021-\Elecricity_markets"
gl elspot "$main\Raw\Nord Pool\Elspot"
gl output "$main\Output"
gl data "$main\processed_data"
gl LOG "$main\Log"

ssc install nrow

*Define time period:
local start_year				15
local latest_full_year			22
local years_with_53_weeks		20 15
local current_year 				23
local current_year_latest_week	7
local current_year_available_weeks	01 02 03  04 05 06 07 //Only runs if current_year_latest_week is below 9 

*When adding data, redefine the locals above, then run the code. 
*When downloading more data, replace the very last week available in the old data with that week from the new data (in case the old data were downloaded in the middle of a week)



** Hour data
//Start year - Latest current year	
forvalues y = `start_year'(1)`latest_full_year' {
	numlist "10(1)52"
	local weeks 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local weeks {	
	import delimited "$elspot\Market_coupling_flow\20`y'\mflo`y'`w'.sdv", clear
	drop if v4==""
	drop if v3!="20`y'" & v3!="Year"
	nrow
		

		rename Hour3A Hour3
		rename Hour3B Hour25
		
		forvalues H=1/25 {
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
		
		egen HourThree = rowmax(Hour3 Hour25)
		drop Hour3 Hour25
		rename  HourThree Hour3
		
		destring Year, replace	
		
		rename v6 Date
		save "$data\Market_coupling_flow\Hour_Data\20`y'\mflo`y'`w'.dta", replace	
	}	
}	
foreach y of local years_with_53_weeks {	
	numlist "10(1)53"
	local weeks 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local weeks {	
	import delimited "$elspot\Market_coupling_flow\20`y'\mflo`y'`w'.sdv", clear
	drop if v4==""
	drop if v3!="20`y'" & v3!="Year"
	nrow
		
		rename Hour3A Hour3
		rename Hour3B Hour25
		
		forvalues H=1/25 {
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
		
		egen HourThree = rowmax(Hour3 Hour25)
		drop Hour3 Hour25
		rename  HourThree Hour3
		
		destring Year, replace	
		
		rename v6 Date
		save "$data\Market_coupling_flow\Hour_Data\20`y'\mflo`y'`w'.dta", replace	
	}	
		}
//Current year	
if `current_year_latest_week' > 9 {
	numlist "10(1)`current_year_latest_week'"
	local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local nums {	
		display "Now working on Week `w'"
		import delimited "$elspot\Market_coupling_flow\mflo`current_year'`w'.sdv", clear
		drop if v4==""
		drop if v3!="20`current_year'" & v3!="Year"
		nrow	
		
		ren v6 Date

		capture rename Hour3B Hour25
		capture rename Hour3A Hour3
		
		forvalues H=1/25 {
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
		
		egen HourThree = rowmax(Hour3 Hour25)
		drop Hour3 Hour25
		rename  HourThree Hour3
		
		destring Year, replace
		
		save "$data\Market_coupling_flow\Hour_Data\20`current_year'\mflo`current_year'`w'.dta", replace
	}	
}
if `current_year_latest_week' < 10 {
	foreach w of local current_year_available_weeks {	
		display "Now working on Week `w'"
		import delimited "$elspot\Market_coupling_flow\mflo`current_year'`w'.sdv", clear
		drop if v4==""
		drop if v3!="20`current_year'" & v3!="Year"
		nrow	
		
		ren v6 Date

		capture rename Hour3B Hour25
		capture rename Hour3A Hour3
		
		forvalues H=1/25 {
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
		
		egen HourThree = rowmax(Hour3 Hour25)
		drop Hour3 Hour25
		rename  HourThree Hour3
		
		destring Year, replace
		
		save "$data\Market_coupling_flow\Hour_Data\20`current_year'\mflo`current_year'`w'.dta", replace
	}	
}

**Append weeks 
forvalues y = `start_year'(1)`latest_full_year' {

		numlist "10(1)52"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
		use "$data\Market_coupling_flow\Hour_Data\20`y'\mflo`y'01.dta", clear	
		foreach w of local weeks {	
			append using "$data\Market_coupling_flow\Hour_Data\20`y'\mflo`y'`w'.dta"
	}
		di "`y'"				
		tab Week	
		tab Day
		tab Alias
		tab __Data_type
		tab Code //M, MR, MS
		save "$data\Market_coupling_flow\mflo_`y'", replace
}
foreach y of local years_with_53_weeks {	
		numlist "10(1)53"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
		use "$data\Market_coupling_flow\Hour_Data\20`y'\mflo`y'01.dta", clear
		
		foreach w of local weeks {	
			append using "$data\Market_coupling_flow\Hour_Data\20`y'\mflo`y'`w'.dta"
	}
		di "`y'"
		tab Week	//week 34 ?
		tab Day
		tab Alias
		tab __Data_type
		tab Code
		save "$data\Market_coupling_flow\mflo_`y'", replace
}					
//Current year
if `current_year_latest_week' > 9 {
	use "$data\Market_coupling_flow\Hour_Data\20`current_year'\mflo`current_year'01.dta", clear
		numlist "10(1)`current_year_latest_week'"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\Market_coupling_flow\Hour_Data\20`current_year'\mflo`current_year'`w'.dta"
			}
		save "$data\Market_coupling_flow\mflo_`current_year'", replace
}
if `current_year_latest_week' < 10 {
		foreach w of local current_year_available_weeks {	
			if `w'==01 {
				use "$data\Market_coupling_flow\Hour_Data\20`current_year'\mflo`current_year'01.dta", clear
			}
			else {
				append using "$data\Market_coupling_flow\Hour_Data\20`current_year'\mflo`current_year'`w'.dta"
			}				
		}
		save "$data\Market_coupling_flow\mflo_`current_year'", replace
}

//Append years
	use "$data\Market_coupling_flow\mflo_`start_year'", clear
	local app_start `=`start_year'+1' 
	forvalues y = `app_start'(1)`current_year' {
		append using "$data\Market_coupling_flow\mflo_`y'.dta"
		erase "$data\Market_coupling_flow\mflo_`y'.dta"
	}
		erase "$data\Market_coupling_flow\mflo_`start_year'.dta"
	
	
	drop Sum
	
	
	
	
	

//Formating, correcting the Year-variable, sorting and more	
	destring Week, replace
	bys Year: sum Week
	gen true_year = yofd(daily(Date, "DMY"))
	gen edate= date(Date, "DMY")
	drop Year
	rename true_year Year
	order Year Week Day Date edate Code Alias Hour* 
	bys Year: sum Week		
	
	sort Code edate  	

	reshape long Hour, i(Code  Year Week Day Date edate Alias) j(timm) 
	rename Hour mflo
	rename timm Hour
		
	order __Data_type Code Year Week Day Date edate Alias Hour mflo
	sort Code edate  Alias Hour	
	drop if Code=="MS"

	save "$data\Market_coupling_flow\Year_data\Market_coupling_flow_y`start_year'_y`current_year'.dta", replace

