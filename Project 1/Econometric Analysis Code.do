set more off


browse

drop if location=="Canada"
drop if location=="New Brunswick"
drop if location=="Manitoba"
drop if location=="Newfoundland and Labrador"
drop if location=="Northwest Territories"
drop if location=="Nova Scotia"
drop if location=="Nunavut"
drop if location=="Prince Edward Island"
drop if location=="Nunavut"
drop if location=="Alberta"
drop if location=="Saskatchewan"
drop if location=="Yukon"

// Quebec, ON, BC, 

drop if year<=2008
drop if year>=2020



//Simple Regression 
regress unemploymentrate15over minimumwage 

// Graph Matrix
graph matrix unemploymentrate15over minimumwage labourforce cpi2002100 population annualgdp immigrants emmigrants

corr unemploymentrate15over minimumwage labourforce cpi2002100 population annualgdp immigrants emmigrants

regress unemploymentrate15over minimumwage population // Remove Population due to OVTEST
//Omited variable//
*Issue: omit a variable that is correlated with both X and Y --> violate the assumption of X and e being independent --> bias 
// TEST
estat ovtest // Fail
estat hettest // pass  
vif



//Trial 
regress unemploymentrate15over minimumwage annualgdp
estat ovtest
estat hettest

regress unemploymentrate15over minimumwage annualgdp emmigrants 

/////////////////////////////////////////////////////////////////////////////////////////

// Best Model Version 1 
regress unemploymentrate15over minimumwage annualgdp immigrants 
estat ovtest //Pass
estat hettest
vif //Multicolinearity//
*Issue: independent variables highly correlated with each other --> inflate the SE (harder to find significance)


// BEST MODEL FINAL MODEL
regress unemploymentrate15over minimumwage cpi2002100 annualgdp immigrants //Best model 2 yet //immigrants emmigrants annualgdp   // Best Model yet
estat ovtest
estat hettest
//Multicolinearity//
*Issue: independent variables highly correlated with each other --> inflate the SE (harder to find significance)
vif


// NEW VARIABLE 
//Test New variable 1
gen mig = immigrants-emmigrants
regress unemploymentrate15over minimumwage population mig cpi2002100 //Adding new element migration 
estat ovtest
estat hettest
// Reject

// New Variable GDP per Capita 2
gen gdppercapita = annualgdp/population
regress unemploymentrate15over minimumwage cpi2002100 labourforce gdppercapita // Testing with new variable 
estat ovtest
estat hettest
vif
// Reject

// Trying to add new variable Annual GDP 3
gen growthrate=(annualgdp-annualgdp[_n-1])/(annualgdp[_n-1])
regress unemploymentrate15over minimumwage cpi2002100 labourforce growthrate  // not immigrants and annual gdp
estat ovtest
estat hettest
//Multicolinearity//
*Issue: independent variables highly correlated with each other --> inflate the SE (harder to find significance)
vif
//Reject



//Export regression results//
ssc install estout
eststo: regress unemploymentrate15over minimumwage cpi2002100 annualgdp immigrants
esttab using regression.csv,se(4) b(4) replace ///   #data_file_name.csv,se(4)-4-digits b(4)-estmiate-4-digits#
   star(* 0.10 ** 0.05 *** 0.01) ///                 # '*' for level of significance#
   title (Table ?. Regression Results)               
eststo clear

eststo: regress unemploymentrate15over minimumwage 
eststo: regress unemploymentrate15over minimumwage cpi2002100
eststo: regress unemploymentrate15over minimumwage cpi2002100 annualgdp
eststo: regress unemploymentrate15over minimumwage cpi2002100 annualgdp immigrants
esttab using regression.csv,se(4) b(4) replace ///
   star(* 0.10 ** 0.05 *** 0.01) ///
   title (Table ?. Regression Results)
eststo clear
* To show full results, please screenshot 
