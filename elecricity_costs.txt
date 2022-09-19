

gl main "Y:\Emma Gunnarsson 2021-\Nord Pool Data"
gl elspot "$main\Raw\Elspot"
gl output "$main\Output"
gl data "$main\processed_data"
gl LOG "$main\Log"

*When adding data, increase the max number in the relevant numlists. 
*When downloading more data, replace the very last week available in the old data with that week from the new data (in case the old data were downloaded in the middle of a week)
****************************
** Preparing the data

**FLows
use "$data\Flows\Hour_Data\flows_y12_y22.dta", clear
	tab Alias
	keep if strmatch(Alias, "SE*") 
	drop if strmatch(Alias, "*FI") 
	drop if strmatch(Alias, "*NO*") 
	drop if strmatch(Alias, "*PL") 
	drop if strmatch(Alias, "*DK*") 
	drop if strmatch(Alias, "*LT") 
	tab Alias
	rename flow_mwh flow_
	reshape wide flow_, i(Year Week Day Date Hour) j(Alias) string
save "$main\processed_data\temp_flow.dta", replace

**File
use "$data\File\Hour_Data\spot_y12_y22.dta", clear
	gen  Price_ = Price_SEK
	drop Purch_mwh Sales_mwh Price_SEK
	reshape wide Price_, i(Year Week Day Date Hour) j(Alias) string
save "$main\processed_data\temp_price.dta", replace
	gen diff_1_2 = Price_SE1 - Price_SE2
	gen diff_2_3 = Price_SE2 - Price_SE3
	gen diff_3_4 = Price_SE3 - Price_SE4
	sum diff_1_2 diff_2_3 diff_3_4

**Merge file and flow data
use "$data\File\Hour_Data\spot_y12_y22.dta", clear
merge m:1 Year Week Day Date Hour using "$main\processed_data\temp_flow.dta", nogen
merge m:1 Year Week Day Date Hour using "$main\processed_data\temp_price.dta", nogen

	erase "$main\processed_data\temp_flow.dta"
	erase "$main\processed_data\temp_price.dta"
****************************
	
	
	
****************************	
** per hour:
	
//Total amount swedish consumpers pay
	gen Purch_SEK = Price_SEK * Purch_mwh	
		sum Price_SEK Purch_mwh Purch_SEK  //Har negativa priser??
		
//total amount producers get from selling
	gen Sales_SEK = Price_SEK * Sales_mwh
		sum Price_SEK Sales_mwh Sales_SEK
//
foreach var in flow_SE1_SE2 flow_SE2_SE1 flow_SE2_SE3 flow_SE3_SE2 flow_SE3_SE4 flow_SE4_SE3 {
		replace `var'=0 if `var'==.
	}

	gen flaskhalsint =	(Price_SE2-Price_SE1) * (flow_SE1_SE2-flow_SE2_SE1) + ///
						(Price_SE3-Price_SE2) * (flow_SE2_SE3-flow_SE3_SE2) + ///
						(Price_SE4-Price_SE3) * (flow_SE3_SE4-flow_SE4_SE3)
		sum flaskhalsint

//sum over elecricity areas
collapse (mean) flaskhalsint (sum) Purch_SEK Sales_SEK, by(Year Week Day Date Hour)
			
save "$data\elkostnader_Swe_hour.dta", replace	
****************************	
		

		
		
****************************			
** per year			
collapse   (sum) flaskhalsint Purch_SEK Sales_SEK , by(Year)	
export excel using "$output\elkostnader_y12_y22", sheet("y12_y22") sheetreplace firstrow(variables) nolabel

****************************	



