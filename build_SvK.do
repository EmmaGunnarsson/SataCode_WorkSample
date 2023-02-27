clear all
cd "Y:\Assistenter\Emma Gunnarsson 2021-\Elecricity_markets\Raw\svk"
global processed "Y:\Assistenter\Emma Gunnarsson 2021-\Elecricity_markets\processed_data"
*ssc install findname
*ssc install nrow

*1. Define your time period:
	local first_year 11
	local last_full_year 21
	local current_year 22
		local last_week 10  //Lat available week in current_year
	
	** // \\ **	
	
	
*2. Run the code:

forvalues y = `first_year'(1)`last_full_year' {
	di "Working on year 20`y'"
	capture frame drop production_heatp_`y'
	frame create production_heatp_`y'
	frame production_heatp_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)' 
			foreach var of local varlist { 		//Trim the strings so that findname will work
				if ![`var'==A] {  				//skip the date varaible
				capture tostring `var', gen(`var'1)
				replace `var' =subinstr( `var' ," ","",.)
				replace `var' =lower( `var')					
					
				}
			}
			findname, any(@=="värmekraft")
			keep A `r(varlist)'
			findname, any(@=="produktion") //These findname commands define what variables i gonna keep
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
			
			rename _20`y' Date_Hour
				
		reshape long X_ , i(Date_Hour) j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_heatp
	}	
	capture frame drop production_diesel_`y'
	frame create production_diesel_`y'
	frame production_diesel_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
					replace `var' ="diesel"  if strmatch( `var' ,"*diesel*")
				}
			}	
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_diesel
			rename _20`y' Date_Hour
	}
	capture frame drop consumption_schablon_delivery_`y'
	frame create consumption_schablon_delivery_`y'
	frame consumption_schablon_delivery_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="schablonleverans")
			keep A `r(varlist)'
			findname, any(@=="förbrukning")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ cons_mwh_schablon
			rename _20`y' Date_Hour
	}
	capture frame drop losses_schablon_delivery_`y'
	frame create losses_schablon_delivery_`y'
	frame losses_schablon_delivery_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="schablonleverans")
			keep A `r(varlist)'
			findname, any(@=="förluster")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ loss_mwh_schablon
			rename _20`y' Date_Hour
	}
	capture frame drop production_solar_`y'
	frame create production_solar_`y'
	frame production_solar_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="solkraft")
			keep A `r(varlist)'
			findname, any(@=="produktion")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_solar
			rename _20`y' Date_Hour
	}
	capture frame drop consumption_hour_`y'
	frame create consumption_hour_`y'
	frame consumption_hour_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="timmättförbr")
			keep A `r(varlist)'
			findname, any(@=="exkl.avk.last")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ cons_mwh_hour
			rename _20`y' Date_Hour
	}
	capture frame drop consumption_unspecified_`y'
	frame create consumption_unspecified_`y'
	frame consumption_unspecified_`y' {
	di "Working on year 20`y'"	
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear	
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
					replace `var'= "." if `var'=="-"
				}
			}
			capture findname, any(@=="ospec.")
			capture keep A `r(varlist)'
			capture findname, any(@=="förbrukning")
			capture keep A `r(varlist)'
			capture drop if A==""
			capture drop if A==" "
			capture nrow
			capture rename se* SE*
			capture drop if SE2=="mwh"
			capture rename SE* X_SE*
			capture confirm variable X_SE3
			if !_rc {
					di  "variables exist"
					}
			else {
					di  "no variables" //if there are no variables, reshape wont work =>
					gen X_SE = "."
					di "In year `y', variable is missing"
					}
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ cons_mwh_unspec
			rename _20`y' Date_Hour
	}
	capture frame drop avkopplingsb_last_`y'
	frame create avkopplingsb_last_`y'
	frame avkopplingsb_last_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="avkopplingsb.")
			keep A `r(varlist)'
			findname, any(@=="last")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ avkopp_mwh_last
			rename _20`y' Date_Hour
	}
	capture frame drop production_unspecified_`y'
	frame create production_unspecified_`y'
	frame production_unspecified_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="ospec.")
			keep A `r(varlist)'
			findname, any(@=="produktion")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_unspec
			rename _20`y' Date_Hour
	}
	capture frame drop production_water_`y'
	frame create production_water_`y'
	frame production_water_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear	
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {

					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="vattenkraft")
			keep A `r(varlist)'
			findname, any(@=="produktion")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_water
			rename _20`y' Date_Hour
	}
	capture frame drop production_wind_`y'
	frame create production_wind_`y'
	frame production_wind_`y' {
		import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear	
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="vindkraft")
			keep A `r(varlist)'
			findname, any(@=="produktion")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`y') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_wind
			rename _20`y' Date_Hour
	}
	
	capture frame drop production_nucle_`y'
		frame create production_nucle_`y'
		frame production_nucle_`y' {
			import excel "timvarden-20`y'-01-12.xls", sheet("generis_temp") clear	
				findname, type(string)
				local varlist `r(varlist)'
				foreach var of local varlist {
					if ![`var'==A] {
						replace `var' =subinstr( `var' ," ","",.)
						replace `var' =lower( `var')
					}
				}
				findname, any(@=="kärnkraft")
				keep A `r(varlist)'
				findname, any(@=="produktion")
				keep A `r(varlist)'
				drop if A==""
				drop if A==" "
				nrow
				rename se* SE*
				drop if SE3=="mwh"
				rename SE* X_SE*
			reshape long X_ , i(_20`y') j(Alias) string
				destring X_, replace
				rename X_ prod_mwh_nucl
				rename _20`y' Date_Hour
	}

	frame change production_heatp_`y'
	frlink 1:1 Date_Hour Alias, frame(production_diesel_`y' )
	frlink 1:1 Date_Hour Alias, frame(consumption_schablon_delivery_`y')
	frlink 1:1 Date_Hour Alias, frame(losses_schablon_delivery_`y')
	frlink 1:1 Date_Hour Alias, frame(production_solar_`y')
	frlink 1:1 Date_Hour Alias, frame(consumption_hour_`y')
	frlink 1:1 Date_Hour Alias, frame(consumption_unspecified_`y')
	frlink 1:1 Date_Hour Alias, frame(avkopplingsb_last_`y')
	frlink 1:1 Date_Hour Alias, frame(production_unspecified_`y')
	frlink 1:1 Date_Hour Alias, frame(production_water_`y')
	frlink 1:1 Date_Hour Alias, frame(production_wind_`y')
	frlink 1:1 Date_Hour Alias, frame(production_nucle_`y')

	frget prod_mwh_diesel, 		from(production_diesel_`y')   				//Note! equivalent to merge, keep(master match)
	frget cons_mwh_schablon, 	from(consumption_schablon_delivery_`y')
	frget loss_mwh_schablon, 	from(losses_schablon_delivery_`y')
	frget prod_mwh_solar, 		from(production_solar_`y')
	frget cons_mwh_hour,	 	from(consumption_hour_`y')
	frget cons_mwh_unspec,	 	from(consumption_unspecified_`y')
	frget avkopp_mwh_last,	 	from(avkopplingsb_last_`y')
	frget prod_mwh_unspec,	 	from(production_unspecified_`y')
	frget prod_mwh_water,	 	from(production_water_`y')
	frget prod_mwh_wind,	 	from(production_wind_`y')
	frget prod_mwh_nucl,	 	from(production_nucle_`y')
 

	 drop production_diesel_`y' consumption_schablon_delivery_`y' losses_schablon_delivery_`y' production_solar_`y' consumption_hour_`y' consumption_unspecified_`y' avkopplingsb_last_`y' production_unspecified_`y' production_water_`y' production_wind_`y' production_nucle_`y'
	 
	 save "$processed\SvK_variables_`y'_.dta", replace
	 
	frames reset

}


//Last, unfnnished year
{
	di "Working on year 20`current_year'"
	capture frame drop production_heatp_`current_year'
	frame create production_heatp_`current_year'
	frame production_heatp_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)' 
			foreach var of local varlist { 		//Trim the strings so that findname will work
				if ![`var'==A] {  				//skip the date varaible
				capture tostring `var', gen(`var'1)
				replace `var' =subinstr( `var' ," ","",.)
				replace `var' =lower( `var')					
					
				}
			}
			findname, any(@=="värmekraft")
			keep A `r(varlist)'
			findname, any(@=="produktion") //These findname commands define what variables i gonna keep
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
			
			rename _20`current_year' Date_Hour
				
		reshape long X_ , i(Date_Hour) j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_heatp
	}	
	capture frame drop production_diesel_`current_year'
	frame create production_diesel_`current_year'
	frame production_diesel_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
					replace `var' ="diesel"  if strmatch( `var' ,"*diesel*")
				}
			}	
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_diesel
			rename _20`current_year' Date_Hour
	}
	capture frame drop consumption_schablon_delivery_`current_year'
	frame create consumption_schablon_delivery_`current_year'
	frame consumption_schablon_delivery_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="schablonleverans")
			keep A `r(varlist)'
			findname, any(@=="förbrukning")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ cons_mwh_schablon
			rename _20`current_year' Date_Hour
	}
	capture frame drop losses_schablon_delivery_`current_year'
	frame create losses_schablon_delivery_`current_year'
	frame losses_schablon_delivery_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="schablonleverans")
			keep A `r(varlist)'
			findname, any(@=="förluster")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ loss_mwh_schablon
			rename _20`current_year' Date_Hour
	}
	capture frame drop production_solar_`current_year'
	frame create production_solar_`current_year'
	frame production_solar_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="solkraft")
			keep A `r(varlist)'
			findname, any(@=="produktion")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_solar
			rename _20`current_year' Date_Hour
	}
	capture frame drop consumption_hour_`current_year'
	frame create consumption_hour_`current_year'
	frame consumption_hour_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="timmättförbr")
			keep A `r(varlist)'
			findname, any(@=="exkl.avk.last")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ cons_mwh_hour
			rename _20`current_year' Date_Hour
	}
	capture frame drop consumption_unspecified_`current_year'
	frame create consumption_unspecified_`current_year'
	frame consumption_unspecified_`current_year' {
	di "Working on year 20`current_year'"	
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear	
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
					replace `var'= "." if `var'=="-"
				}
			}
			capture findname, any(@=="ospec.")
			capture keep A `r(varlist)'
			capture findname, any(@=="förbrukning")
			capture keep A `r(varlist)'
			capture drop if A==""
			capture drop if A==" "
			capture nrow
			capture rename se* SE*
			capture drop if SE2=="mwh"
			capture rename SE* X_SE*
			capture confirm variable X_SE3
			if !_rc {
					di  "variables exist"
					}
			else {
					di  "no variables" //if there are no variables, reshape wont work =>
					gen X_SE = "."
					di "In year `current_year', variable is missing"
					}
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ cons_mwh_unspec
			rename _20`current_year' Date_Hour
	}
	capture frame drop avkopplingsb_last_`current_year'
	frame create avkopplingsb_last_`current_year'
	frame avkopplingsb_last_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="avkopplingsb.")
			keep A `r(varlist)'
			findname, any(@=="last")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ avkopp_mwh_last
			rename _20`current_year' Date_Hour
	}
	capture frame drop production_unspecified_`current_year'
	frame create production_unspecified_`current_year'
	frame production_unspecified_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="ospec.")
			keep A `r(varlist)'
			findname, any(@=="produktion")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_unspec
			rename _20`current_year' Date_Hour
	}
	capture frame drop production_water_`current_year'
	frame create production_water_`current_year'
	frame production_water_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear	
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {

					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="vattenkraft")
			keep A `r(varlist)'
			findname, any(@=="produktion")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_water
			rename _20`current_year' Date_Hour
	}
	capture frame drop production_wind_`current_year'
	frame create production_wind_`current_year'
	frame production_wind_`current_year' {
		import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear	
			findname, type(string)
			local varlist `r(varlist)'
			foreach var of local varlist {
				if ![`var'==A] {
					replace `var' =subinstr( `var' ," ","",.)
					replace `var' =lower( `var')
				}
			}
			findname, any(@=="vindkraft")
			keep A `r(varlist)'
			findname, any(@=="produktion")
			keep A `r(varlist)'
			drop if A==""
			drop if A==" "
			nrow
			rename se* SE*
			drop if SE2=="mwh"
			rename SE* X_SE*
		reshape long X_ , i(_20`current_year') j(Alias) string
			destring X_, replace
			rename X_ prod_mwh_wind
			rename _20`current_year' Date_Hour
	}
	
	capture frame drop production_nucle_`current_year'
		frame create production_nucle_`current_year'
		frame production_nucle_`current_year' {
			import excel "timvarden-20`current_year'-01-`last_week'.xls", sheet("generis_temp") clear	
				findname, type(string)
				local varlist `r(varlist)'
				foreach var of local varlist {
					if ![`var'==A] {
						replace `var' =subinstr( `var' ," ","",.)
						replace `var' =lower( `var')
					}
				}
				findname, any(@=="kärnkraft")
				keep A `r(varlist)'
				findname, any(@=="produktion")
				keep A `r(varlist)'
				drop if A==""
				drop if A==" "
				nrow
				rename se* SE*
				drop if SE3=="mwh"
				rename SE* X_SE*
			reshape long X_ , i(_20`current_year') j(Alias) string
				destring X_, replace
				rename X_ prod_mwh_nucl
				rename _20`current_year' Date_Hour
	}

	frame change production_heatp_`current_year'
	frlink 1:1 Date_Hour Alias, frame(production_diesel_`current_year' )
	frlink 1:1 Date_Hour Alias, frame(consumption_schablon_delivery_`current_year')
	frlink 1:1 Date_Hour Alias, frame(losses_schablon_delivery_`current_year')
	frlink 1:1 Date_Hour Alias, frame(production_solar_`current_year')
	frlink 1:1 Date_Hour Alias, frame(consumption_hour_`current_year')
	frlink 1:1 Date_Hour Alias, frame(consumption_unspecified_`current_year')
	frlink 1:1 Date_Hour Alias, frame(avkopplingsb_last_`current_year')
	frlink 1:1 Date_Hour Alias, frame(production_unspecified_`current_year')
	frlink 1:1 Date_Hour Alias, frame(production_water_`current_year')
	frlink 1:1 Date_Hour Alias, frame(production_wind_`current_year')
	frlink 1:1 Date_Hour Alias, frame(production_nucle_`current_year')

	frget prod_mwh_diesel, 		from(production_diesel_`current_year')
	frget cons_mwh_schablon, 	from(consumption_schablon_delivery_`current_year')
	frget loss_mwh_schablon, 	from(losses_schablon_delivery_`current_year')
	frget prod_mwh_solar, 		from(production_solar_`current_year')
	frget cons_mwh_hour,	 	from(consumption_hour_`current_year')
	frget cons_mwh_unspec,	 	from(consumption_unspecified_`current_year')
	frget avkopp_mwh_last,	 	from(avkopplingsb_last_`current_year')
	frget prod_mwh_unspec,	 	from(production_unspecified_`current_year')
	frget prod_mwh_water,	 	from(production_water_`current_year')
	frget prod_mwh_wind,	 	from(production_wind_`current_year')
	frget prod_mwh_nucl,	 	from(production_nucle_`current_year')
 

	 drop production_diesel_`current_year' consumption_schablon_delivery_`current_year' losses_schablon_delivery_`current_year' production_solar_`current_year' consumption_hour_`current_year' consumption_unspecified_`current_year' avkopplingsb_last_`current_year' production_unspecified_`current_year' production_water_`current_year' production_wind_`current_year' production_nucle_`current_year'
	 
	 save "$processed\SvK_variables_`current_year'_.dta", replace
	 
	frames reset

}

//Append years
use "$processed\SvK_variables_11_.dta", clear
	erase "$processed\SvK_variables_11_.dta"
forvalues f = 12(1)22 {
	append using "$processed\SvK_variables_`f'_.dta"
		erase "$processed\SvK_variables_`f'_.dta"
}
save "$processed\SvK\SvKvariables_y11_y22.dta", replace


//Time variables
use  "$processed\SvK\SvKvariables_y11_y22.dta", clear
	gen double nd_hour_minute = clock(Date_Hour, "DMY hms")
	gen double nd_hour_minute_sec = clock(Date_Hour, "DMY hm")
	replace nd_hour_minute=0 if nd_hour_minute==.
	replace nd_hour_minute_sec=0 if nd_hour_minute_sec==.
	gen nd_time = nd_hour_minute + nd_hour_minute_sec	
	replace nd_hour_minute=. if nd_hour_minute==0
	replace nd_hour_minute_sec=. if nd_hour_minute_sec==0
gen double Date_hour_round = round(nd_time, 60000*30)
	format  Date_hour_round %tc
	gen Year1= yofd(daily(Date_Hour, "DMY hms"))
	gen Year2= yofd(daily(Date_Hour, "DMY hm"))
	replace Year1=0 if Year1==.
	replace Year2=0 if Year2==.
	gen Year= Year1 + Year2
	tab Year, missing
	drop Year1 Year2
	order Date_Hour Alias Year   nd_time Date_hour_round
	drop nd_hour_minute nd_hour_minute_sec
	rename (Date_Hour nd_time Date_hour_round)  (Date_Hour_svk nd_time_svk Date_hour_round_svk) 
save "$processed\SvK\SvKvariables_y11_y22.dta", replace











