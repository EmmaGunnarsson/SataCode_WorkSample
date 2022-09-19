gl main "Y:\Emma Gunnarsson 2021-\Nord Pool Data"
gl elspot "$main\Raw\Elspot"
gl output "$main\Output"
gl data "$main\processed_data"
gl LOG "$main\Log"

ssc install nrow

*When adding data, increase the max number in the relevant numlists. 
*When downloading more data, replace the very last week available in the old data with that week from the new data (in case the old data were downloaded in the middle of a week)


*********************
** Elspot Capacity **
*********************

//year 2000
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
		drop if  strpos(Alias,  "SEA")			//We dont care about optimizing area
		
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
		drop if  strpos(Alias,  "SEA")			//We dont care about optimizing area

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
*year 2001 - 2011
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
		capture drop  v34 v35
		replace Code="Day ahead flow" if Code=="D"
		replace __Data_type="Exchange capacity (MWh/h)" if __Data_type=="UE"
		drop if __Data_type=="CR"

		keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden
		drop if  strpos(Alias,  "SEA")			//We dont care about optimizing area

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
*year 2012 -2021
	forvalues y = 12(1)21  {	
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
		capture drop  v34 v35
		capture drop Hour3B
		capture rename Hour3A Hour3
		replace Code="Day ahead flow" if Code=="D"
		replace __Data_type="Exchange capacity (MWh/h)" if __Data_type=="UE"
		drop if __Data_type=="CR"

		keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden
		drop if  strpos(Alias,  "SEA")			//We dont care about optimizing area

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
*year 2022
	log using "$LOG\capacity_2022_w0137.log", replace
	numlist "10(1)37"
	local nums 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local nums {
		display "Now working on Week `w'"	
		import delimited "$elspot\Elspot_capacity\scap22`w'.sdv", clear
		drop if v4==""
		drop if v3!="2022" & v3!="Year"

		nrow
		ren v6 Date
		capture drop Hour3B
		capture rename Hour3A Hour3
		replace Code="Day ahead flow" if Code=="D"
		replace __Data_type="Exchange capacity (MWh/h)" if __Data_type=="UE"
		drop if __Data_type=="CR"

		keep if  strpos(Alias,  "SE")			//Keep only those flows including Sweden
		drop if  strpos(Alias,  "SEA")			//We dont care about optimizing area
		
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
		save "$data\Capacity\Hour_Data\2022\scap22`w'.dta", replace
	}
	log close

			

* YEAR DATA: MAX CAPACITY
//2000-2021
	numlist "10(1)21"
	local yearss 00 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach y of local yearss {	
	
	numlist "10(1)52"
	local weeks 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local weeks {		
	use "$data\Capacity\Hour_Data\20`y'\scap`y'`w'.dta", clear
			egen Cap_H_max_=rowmax(Hour*)
			drop Hour* Sum
			capture drop Date
			capture drop v6
			reshape wide Cap_H_max, i(Alias) j(Day) string
			egen Cap_D_max=rowmax(Cap_H_max*)
			drop Cap_H_max_*
	save "$data\Capacity\Year_Data\capacity_`y'_`w'.dta", replace
			}
	}		
//2022
	numlist "10(1)37"
	local weeks 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach w of local weeks {		
	use "$data\Capacity\Hour_Data\2022\scap22`w'.dta", clear
			egen Cap_H_max_=rowmax(Hour*)
			drop Hour* Sum
			capture drop Date
			capture drop v6
			reshape wide Cap_H_max, i(Alias) j(Day) string
			egen Cap_D_max=rowmax(Cap_H_max*)
			drop Cap_H_max_*
	save "$data\Capacity\Year_Data\capacity_22_`w'.dta", replace
			}
	
//APPEND to Years 2000-2021
	numlist "10(1)21"
	local yearss 00 01 02 03 04 05 06 07 08 09 `r(numlist)'
	foreach y of local yearss {		
	use "$data\Capacity\Year_Data\capacity_`y'_01.dta", clear
		
		numlist "10(1)52"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
		foreach w of local weeks {	
			append using "$data\Capacity\Year_Data\capacity_`y'_`w'.dta"
			erase "$data\Capacity\Year_Data\capacity_`y'_`w'.dta"
	}
			save "$data\Capacity\Year_Data\capacity_`y'.dta", replace
			erase "$data\Capacity\Year_Data\capacity_`y'_01.dta"		
	}	
//2022
		numlist "10(1)37"
		local weeks 02 03 04 05 06 07 08 09 `r(numlist)'
		use "$data\Capacity\Year_Data\capacity_22_01.dta", clear
		foreach w of local weeks {	
			append using "$data\Capacity\Year_Data\capacity_22_`w'.dta"
			erase "$data\Capacity\Year_Data\capacity_22_`w'.dta"
	}
			save "$data\Capacity\Year_Data\capacity_22.dta", replace
			erase "$data\Capacity\Year_Data\capacity_22_01.dta"		
	
//Append years to one dataset 2000-2017		
		use "$data\Capacity\Year_Data\capacity_00.dta", clear

		numlist "10(1)22"
		local years 01 02 03 04 05 06 07 08 09 `r(numlist)'
		foreach y of local years {	
		append using "$data\Capacity\Year_Data\capacity_`y'.dta"
		erase "$data\Capacity\Year_Data\capacity_`y'.dta"
		}
		erase "$data\Capacity\Year_Data\capacity_00.dta"
		
		drop _
	
	reshape wide Cap_D_max, i(Alias Year) j(Week) string
	egen Cap_max=rowmax(Cap_D_max*)
	drop Cap_D_max*

	preserve
	keep if Year<2011
		save "$data\Capacity\Year_Data\capacity_y00_y10.dta", replace
			tab Year
			tab Alias
	restore			
	preserve
	keep if Year>2011
		save "$data\Capacity\Year_Data\capacity_y11_y22.dta", replace
			tab Year
			tab Alias
	restore			
		

** EXCEL OUTPUT (Year Data)
use "$data\Capacity\Year_Data\capacity_y00_y10.dta", clear
	rename Cap_max Cap_max_
	reshape wide Cap_max_ , i(Alias) j(Year)
	rename Cap_max_* y*
export excel using "$output\max_capacity_y00_y22", sheet("y00_y10") sheetreplace firstrow(variables) nolabel

use "$data\Capacity\Year_Data\capacity_y00_y10.dta", clear
export excel using "$output\max_capacity_y00_y22", sheet("y00_y10_long") sheetreplace firstrow(variables) nolabel

		
use "$data\Capacity\Year_Data\capacity_y11_y22.dta", clear
	rename Cap_max Cap_max_
	replace Alias = "DK1AandNO1_SE3" if Alias=="DK1A+NO1_SE3"
	replace Alias = "SE3_DK1AandNO1" if Alias=="SE3_DK1A+NO1"
	reshape wide Cap_max_ , i(Alias) j(Year)
	rename Cap_max_* y*
export excel using "$output\max_capacity_y00_y22", sheet("y11_y22") sheetreplace firstrow(variables) nolabel	
	
use "$data\Capacity\Year_Data\capacity_y11_y22.dta", clear
	rename Cap_max Cap_max_
	replace Alias = "DK1AandNO1_SE3" if Alias=="DK1A+NO1_SE3"
	replace Alias = "SE3_DK1AandNO1" if Alias=="SE3_DK1A+NO1"
export excel using "$output\max_capacity_y00_y22", sheet("y11_y22_long") sheetreplace firstrow(variables) nolabel	
	
	
use "$data\Capacity\Year_Data\capacity_y11_y22.dta", clear
	rename Cap_max Cap_max_
	replace Alias = "DK1AandNO1_SE3" if Alias=="DK1A+NO1_SE3"
	replace Alias = "SE3_DK1AandNO1" if Alias=="SE3_DK1A+NO1"
	keep if strmatch(Alias, "SE*") 
	drop if strmatch(Alias, "*FI") 
	drop if strmatch(Alias, "*NO*") 
	drop if strmatch(Alias, "*PL") 
	drop if strmatch(Alias, "*DK*") 
	drop if strmatch(Alias, "*LT") 
	drop if strmatch(Alias, "*PLA") 
	drop if strmatch(Alias, "*PLC") 
	tab Alias	
	reshape wide Cap_max_ , i(Alias) j(Year) 
	rename Cap_max_* y*
export excel using "$output\max_capacity_y00_y22", sheet("SE_SE_y11_y22") sheetreplace firstrow(variables) nolabel	


use "$data\Capacity\Year_Data\capacity_y11_y22.dta", clear
	rename Cap_max Cap_max_
	replace Alias = "DK1AandNO1_SE3" if Alias=="DK1A+NO1_SE3"
	replace Alias = "SE3_DK1AandNO1" if Alias=="SE3_DK1A+NO1"
	drop if strmatch(Alias, "*PL*") 
	drop if strmatch(Alias, "*LT*") 
	drop if strmatch(Alias, "*PLA*") 
	drop if strmatch(Alias, "*PLC*") 
	drop if Alias=="SE1_SE2" | Alias=="SE2_SE1" | Alias=="SE2_SE3" | Alias==" SE3_SE2" | Alias=="SE3_SE4" | Alias=="SE3_SE2" | Alias=="SE4_SE3"
	tab Alias	
	reshape wide Cap_max_ , i(Alias) j(Year)		
	rename Cap_max_* y*
export excel using "$output\max_capacity_y00_y22", sheet("SE_nord_y11_y22") sheetreplace firstrow(variables) nolabel	


use "$data\Capacity\Year_Data\capacity_y11_y22.dta", clear
	rename Cap_max Cap_max_
	replace Alias = "DK1AandNO1_SE3" if Alias=="DK1A+NO1_SE3"
	replace Alias = "SE3_DK1AandNO1" if Alias=="SE3_DK1A+NO1"
	drop if strmatch(Alias, "*FI*") 
	drop if strmatch(Alias, "*NO*") 
	drop if strmatch(Alias, "*DK*") 
	drop if Alias=="SE1_SE2" | Alias=="SE2_SE1" | Alias=="SE2_SE3" | Alias==" SE3_SE2" | Alias=="SE3_SE4" | Alias=="SE3_SE2" | Alias=="SE4_SE3"
	tab Alias	
	reshape wide Cap_max_ , i(Alias) j(Year)	
	rename Cap_max_* y*
export excel using "$output\max_capacity_y00_y22", sheet("SE_kont_y11_y22") sheetreplace firstrow(variables) nolabel	


	
	
	