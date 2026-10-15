# Assignment 1 - Business Statistics
# Name: Mohammed Yusuf Shaikh
# Student No.: 251615255
# Email ID: mshaikh.msc2027@ivey.ca

# Loading the Dataset Vungle
install.packages('ggplot2')
library(ggplot2)

# Load the Vungle data
vungle <- read_csv("~/Downloads/VungleData.csv")

# Check column names
names(vungle)

# Calculate performance rates
A <- subset(vungle, Strategy == "Vungle A")

B <- subset(vungle, Strategy == "Vungle B")

# 5. CALCULATE COMPLETION RATE

A$CompletionRate <- A$Completes / A$Impressions

B$CompletionRate <- B$Completes / B$Impressions


# 6. CALCULATE CLICK-THROUGH RATE (CTR)

A$CTR <- A$Clicks / A$Impressions

B$CTR <- B$Clicks / B$Impressions


# 7. CALCULATE CONVERSION RATE

A$ConversionRate <- A$Installs / A$Impressions

B$ConversionRate <- B$Installs / B$Impressions


# 8. CALCULATE AVERAGE eRPM

mean(A$eRPM)

mean(B$eRPM)


# 9. CALCULATE AVERAGE COMPLETION RATE

mean(A$CompletionRate)

mean(B$CompletionRate)


# 10. CALCULATE AVERAGE CTR

mean(A$CTR)

mean(B$CTR)


# 11. CALCULATE AVERAGE CONVERSION RATE

mean(A$ConversionRate)

mean(B$ConversionRate)


# 12. DIFFERENCE IN AVERAGE eRPM

mean(B$eRPM) - mean(A$eRPM)


# 13. PERCENTAGE IMPROVEMENT IN eRPM

((mean(B$eRPM) - mean(A$eRPM)) / mean(A$eRPM)) * 100



# 14. PAIRED T-TEST FOR eRPM

# H0: Strategy B does not have higher eRPM than Strategy A
# H1: Strategy B has higher eRPM than Strategy A

t.test(B$eRPM,
       A$eRPM,
       paired = TRUE,
       alternative = "greater")


# 15. PAIRED T-TEST FOR COMPLETION RATE

t.test(B$CompletionRate,
       A$CompletionRate,
       paired = TRUE)


# 16. PAIRED T-TEST FOR CTR

t.test(B$CTR,
       A$CTR,
       paired = TRUE)


# 17. PAIRED T-TEST FOR CONVERSION RATE

t.test(B$ConversionRate,
       A$ConversionRate,
       paired = TRUE)


# 18. GRAPH OF eRPM

plot(A$eRPM,
     type = "l",
     ylim = range(A$eRPM, B$eRPM),
     xlab = "Day",
     ylab = "eRPM",
     main = "Daily eRPM: Strategy A vs Strategy B")

lines(B$eRPM, lty = 2)

legend("topleft",
       legend = c("Strategy A", "Strategy B"),
       lty = c(1, 2))
