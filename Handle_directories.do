gl main "Y:\Assistenter\Emma Gunnarsson 2021-\Elecricity_markets"


!mkdir "$main\processed_data\Capacity"
	!mkdir "$main\processed_data\Capacity\Year_data"
	!mkdir "$main\processed_data\Capacity\Hour_Data"
		forvalues YEAR = 2000/2023 {
			!mkdir "$main\processed_data\Capacity\Hour_Data\\`YEAR'"
		}
!mkdir "$main\processed_data\File"
	!mkdir "$main\processed_data\File\Year_data"
	!mkdir "$main\processed_data\File\Hour_Data"
		forvalues YEAR = 2000/2023 {
			!mkdir "$main\processed_data\File\Hour_Data\\`YEAR'"
		}
!mkdir "$main\processed_data\Flows"
	!mkdir "$main\processed_data\Flows\Year_data"
	!mkdir "$main\processed_data\Flows\Hour_Data"
		forvalues YEAR = 2000/2023 {
			!mkdir "$main\processed_data\Flows\Hour_Data\\`YEAR'"
		}
!mkdir "$main\processed_data\Market_coupling_capacity"
	!mkdir "$main\processed_data\Market_coupling_capacity\Year_data"
	!mkdir "$main\processed_data\Market_coupling_capacity\Hour_Data"
		forvalues YEAR = 2000/2023 {
			!mkdir "$main\processed_data\Market_coupling_capacity\Hour_Data\\`YEAR'"
		}
!mkdir "$main\processed_data\Market_coupling_flow"
	!mkdir "$main\processed_data\Market_coupling_flow\Year_data"
	!mkdir "$main\processed_data\Market_coupling_flow\Hour_Data"
		forvalues YEAR = 2000/2023 {
			!mkdir "$main\processed_data\Market_coupling_flow\Hour_Data\\`YEAR'"
		}
		
!mkdir "$main\processed_data\Operating_Data"
	!mkdir "$main\processed_data\Operating_Data\Year_data"
	!mkdir "$main\processed_data\Operating_Data\Hour_Data"
		forvalues YEAR = 2000/2023 {
				!mkdir "$main\processed_data\Operating_Data\Hour_Data\\`YEAR'"
			}