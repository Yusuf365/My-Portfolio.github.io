*xtset: https://www.stata.com/manuals/xtxtset.pdf
*Linear fixed- and random-effects models: https://www.stata.com/features/overview/linear-fixed-and-random-effects-models/
*xtreg: https://www.stata.com/manuals/xtxtreg.pdf
*hausman test: https://www.stata.com/manuals/rhausman.pdf
*Panel Data Analysis Fixed and Random Effects using Stata: https://www.princeton.edu/~otorres/Panel101.pdf
*esttab Multiple regression table in stata: http://repec.org/bocode/e/estout/esttab.html

*Fixed effects regression is a method for controlling for omitted variables in panel data when the omitted variables vary across entities (states) but do not change over time.



histogram passen

*create new variable concenpct which is concen*100 (so market concentration with unit percentage) so it's easier to interpret coefficients

gen concenpct = concen*100

*summarize dataset

summarize dist passen fare ldist lfare ldistsq lpassen concenpct

*Table
tabstat year dist passen fare bmktshr ldist lfare ldistsq, statistics( count mean sd max min ) columns(statistics)

*output the regression results to a table
ssc install estout
regress fare concenpct, robust
eststo model1
regress lfare concenpct, robust
eststo model2
regress lfare concenpct passen, robust
eststo model3
regress lfare concenpct passen dist, robust
eststo model4
xtreg lfare concenpct passen, fe vce(robust)
eststo model5
xtreg lfare concenpct passen i.year, fe vce(robust)
eststo model6
esttab model1 model2 model3 model4 model5 model6 using Trial4.rtf, r2

*1. simple linear regression

reg fare concenpct, robust

* check whether there's omitted variable bias

reg fare passen, robust

correlate concenpct passen

*2. Multiple linear regression

reg lfare concenpct passen, robust 

reg lfare concen lpassen, robust 

* Futhermore, there can be various other factors affecting avg on way fare other than market concentarion percentage therefore which could be tested with multiple linear regression like distance, avg no. of passenger.
* The multiple regression runs for log of fare as dependent Y variable with market concentration as X1 variable and log of avg no. of passengers as X2 variable (control varibale). 

twoway scatter fare concenpct

twoway scatter fare lpassen

*histogram of fare and lfare

histogram concenpct

histogram lfare

histogram passen
histogram lpassen


*lfare more symmetrical than fare, so should use lfare

*3. Fixed effect regression

sort id year

xtset id year, yearly

xtdescribe

xtsum id year lfare concenpct passen lpassen

* running hausman test to determine whether to use fixed or random effect model

xtreg lfare concenpct passen ldistsq, fe 

estimate store fixed

xtreg lfare concenpct passen ldistsq, re 

hausman fixed ., sigmamore

*result tells us we should use fixed effect model

*run fixed effect model, separate entity by route identifier, allow clustered standard errors, controlling for year effects

xtreg lfare concenpct passen ldistsq i.year, fe vce(robust)

xtreg lfare concenpct passen dist ldistsq i.year, fe vce(robust)

xtreg lfare concenpct passen i.year, fe vce(robust)

*distance variables omitted because no between years variation, so conclusion is to drop distance variable

xtreg lfare concenpct lpassen i.year, fe vce(robust)

*choose lpassen because coefficient interpretation is nicer

*test whether time fixed effects are needed

testparm i.year

*Reject the null that the coefficients for all years are jointly equal to zero, therefore need to add time fixed effects.

xtreg lfare concenpct lpassen i.year, fe vce(robust)

*recover individual-specific effects (leftover variation in the. dependant variable that cannot be explained by the regressors)

quietly xtreg lfare concenpct passen, fe vce(robust)
predict alphafehat, u
sum alphafehat


