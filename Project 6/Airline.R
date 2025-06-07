#install packages
install.packages("tidyverse")
install.packages("reshape2")
install.packages("ggplot2")
install.packages("janitor")
install.packages("readr")
install.packages("dplyr")

# Getting Libraries
library(tidyverse)
library(reshape2)
library(ggplot2)
library(janitor)
library(readr)
library(dplyr)

# Data Cleaning



# Read the csv file
invistico_airline <- read_csv("/Users/myusuf/Library/CloudStorage/OneDrive-UniversityofToronto/STA312 Topic in Statistics/Invistico_Airline.csv")

# Drop rows with NA values from entire dataset
invistico_airline <- invistico_airline %>%
  drop_na()

invistico_airline <- invistico_airline %>%
  mutate(satisfaction_code = factor(satisfaction,
                                    levels = c("satisfied", "dissatisfied"),
                                    labels = c("1", "0"))
  )

# cleaned names standardized 
invistico_airline <- clean_names(invistico_airline)
# Reshape the data to long format
invistico_airline_long <- reshape2::melt(invistico_airline)


########
# Histogram Maps
# Plot histograms for all variables
ggplot(invistico_airline_long, aes(x = value)) +
  geom_histogram(bins = 15, fill = "steelblue", color = "black") +
  facet_wrap(~variable, scales = "free") +
  labs(title = "Histograms of Multiple Variables in Invistico Airline Dataset") +
  theme_minimal()

######
# Corr Matrix & Heat map

# Calculate the correlation matrix for numerical variables
cor_matrix <- invistico_airline %>%
  select(where(is.numeric)) %>%
  cor(use = "complete.obs") # Compute correlations for numeric columns only

# Reshape the correlation matrix to long format for ggplot2
cor_matrix_long <- melt(cor_matrix)

# Plot the heatmap
ggplot(cor_matrix_long, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white", midpoint = 0,
                       limit = c(-1, 1), space = "Lab", name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(
    title = "Heatmap of Correlation Matrix for Invistico Airline Dataset",
    x = "",
    y = ""
  )

##############

#Fit the binomial logistic regression model
logistic_model <- glm(
  satisfaction_code ~ flight_distance + departure_delay_in_minutes + cleanliness
  + inflight_entertainment + seat_comfort + seat_comfort + age 
  + gender + class + food_and_drink + leg_room_service + gate_location + ease_of_online_booking
  + cleanliness + checkin_service,
  data = invistico_airline,
  family = binomial
)

# Summary of the model
summary(logistic_model)


reduced_model <- glm(
  satisfaction_code ~ departure_delay_in_minutes + cleanliness + inflight_entertainment + inflight_entertainment + seat_comfort + seat_comfort + age 
  + gender + class + food_and_drink ,
  data = invistico_airline,
  family = binomial
)

# Compare AIC values
AIC(reduced_model, logistic_model)

# Compare the full and reduced models using the Likelihood Ratio Test
anova(reduced_model, logistic_model, test = "Chisq")


# Install pROC package if not already installed
install.packages("pROC")

# Load the package
library(pROC)

# Compute ROC curve for the full model
roc_full <- roc(invistico_airline$satisfaction_code, predicted_probs_full)

# Plot the ROC curve
plot(roc_full, col = "blue", main = "ROC Curve for Full Model", lwd = 2)

# Compute and display AUC for the full model
auc_full <- auc(roc_full)
cat("AUC (Full Model):", auc_full, "\n")

# Compute ROC curve for the reduced model
roc_reduced <- roc(invistico_airline$satisfaction_code, predicted_probs_reduced)

# Plot the ROC curve
plot(roc_reduced, col = "red", add = TRUE, lwd = 2)

# Compute and display AUC for the reduced model
auc_reduced <- auc(roc_reduced)
cat("AUC (Reduced Model):", auc_reduced, "\n")

# Add legend to the plot
legend("bottomright", legend = c("Full Model", "Reduced Model"), col = c("blue", "red"), lwd = 2)








