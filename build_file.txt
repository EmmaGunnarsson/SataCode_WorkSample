gl main "Y:\Emma Gunnarsson 2021-\Nord Pool Data"
gl elspot "$main\Raw\Elspot"
gl output "$main\Output"
gl data "$main\processed_data"
gl LOG "$main\Log"


ssc install nrow

*When adding data, increase the max number in the relevant numlists. 
*When downloading more data, replace the very last week available in the old data with that week from the new data (in case the old data were downloaded in the middle of a week)

*********************
**** Elspot File ****
*********************
//year 2012 - 2021
forvalues y = 12(1)21  {	
log using "$LOG\spot_20`y'_w0152.log", replace

numlist "10(1)52"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	
	display "Now working on Week `w'"
	import delimited "$elspot\Elspot_file\20`y'\spot`y'`w'.sdv", clear
	drop if v4==""
	drop if v3!="20`y'" & v3!="Year"
	nrow	


	ren v6 Date
	capture rename v34 Total
	drop Total
	capture drop Hour3B
	capture rename Hour3A Hour3
	
	tab Unit
	keep if Unit == "SEK" | Unit== "MWh/h"
	tab Code
	
	tab Alias

	drop if Code=="SF" //Preliminary exchange rate (finns inte i början av tisperioden)

	keep if  strpos(Alias,  "SE") 	//Keep only those  including Sweden
	
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

//year 2022
log using "$LOG\spot_2022_w0152.log", replace
numlist "10(1)37"
local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
foreach w of local nums {	
	display "Now working on Week `w'"
	import delimited "$elspot\Elspot_file\spot22`w'.sdv", clear
	drop if v4==""
	drop if v3!="2022" & v3!="Year"
	nrow	


	ren v6 Date
	capture rename v34 Total
	drop Total
	capture drop Hour3B
	capture rename Hour3A Hour3
	
	tab Unit
	keep if Unit == "SEK" | Unit== "MWh/h"
	tab Code
	
	drop if Code=="SF" //Preliminary exchange rate (finns inte i början av tisperioden)

	keep if  strpos(Alias,  "SE") 	//Keep only those  including Sweden
	
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
	save "$data\File\Hour_Data\2022\spot22`w'.dta", replace
}	
log close





* All years (Hour data)
//2012 - 2021
	forvalues y = 12(1)21 {
		use "$data\File\Hour_Data\20`y'\spot`y'01.dta", clear
		numlist "10(1)52"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\File\Hour_Data\20`y'\spot`y'`w'.dta"
			}
		drop __Data_type Unit
		save "$data\File\spot_`y'", replace
	}
//2022
use "$data\File\Hour_Data\2022\spot2201.dta", clear
		numlist "10(1)37"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
			foreach w of local weeks {		
				append using "$data\File\Hour_Data\2022\spot22`w'.dta"
			}
		drop __Data_type Unit
		save "$data\File\spot_22", replace
//Append years
	use "$data\File\spot_12", clear
	forvalues y = 13(1)22 {
	append using "$data\File\spot_`y'.dta"
	erase "$data\File\spot_`y'.dta"
	}
	erase "$data\File\spot_12.dta"

	reshape long Hour , i(Code Year Week Day Date Alias) j(Hourr) 
		rename Hour file
		rename Hourr Hour
	reshape wide file, i(Year Week Day Date Alias Hour) j(Code) string
	rename fileSK Purch_mwh
	rename fileSO Price_SEK
	rename fileSS Sales_mwh
	
	save "$data\File\Hour_Data\spot_y12_y22", replace















