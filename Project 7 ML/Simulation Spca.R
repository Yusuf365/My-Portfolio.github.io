# Load necessary package
# install.packages("elasticnet")
# install.packages("janitor")
# install.packages("dplyr")
# install.packages("knitr")
# install.packages("tidyverse")

# Load Libraries
library(elasticnet)
library(dplyr)
library(janitor)
library(knitr)
library(tidyverse)

# Using seed to get same reproducible result 
set.seed(123) 

# Generating Data
# no. of observations we went through multiple trial & errors for value of n for high dimensionality
n <- 10000
# no. of variable/features (predictors) we use for synthetic example
p <- 10

# Specifing Three latent variables - hidden factors as per paper Synthetic example
V1 <- rnorm(n, mean = 0, sd = sqrt(290))  
V2 <- rnorm(n, mean = 0, sd = sqrt(300))  
V3 <- -0.3 * V1 + 0.925 * V2 + rnorm(n)


# Generating Matrix as per synthetic example
X <- matrix(0, nrow = n, ncol = p)
X[, 1:4]  <- V1 + matrix(rnorm(n * 4), nrow = n)
X[, 5:8]  <- V2 + matrix(rnorm(n * 4), nrow = n)
X[, 9:10] <- V3 + matrix(rnorm(n * 2), nrow = n)

# We standardize the data matrix as it is required for PCA and SPCA method
X_standardized <- scale(X, center = TRUE, scale = TRUE)

# PCA Method

# Apply PCA Method to standardized data prcomp() is used 
pca_loading_value <- prcomp(X_standardized)
# We round the loading values for PC1, PC2 & PC3 but we extract it before using $rotation
print(round(pca_loading_value$rotation[, 1:3], 3))
# Total variance is explained by PCA
total_explained_variance <- summary(pca_loading_value)$importance["Proportion of Variance", 1:2] * 100

# Sparse PCA Method

# Apply Sparse PCA Method to standardized data spca() is used from elastic net package
spca_result <- spca(X_standardized, K = 2, type = "predictor", sparse = "varnum", para = c(4, 4), lambda = 1e-6)
# We round the loading values for PC1 & PC2 but we extract it before using $loadings
print(round(spca_result$loadings, 1))
# Total variance is explained by SPCA using $pev
spca_variance_explained <- spca_result$pev * 100

# We construct a table using knitr

# We use PCA and SPCA loadings table using tibble
loadings_table <- tibble::tibble(
  Variable = paste0("X", 1:10),
  'PCA PC1' = round(pca_loading_value$rotation[, 1], 3),
  'PCA PC2' = round(pca_loading_value$rotation[, 2], 3),
  'PCA PC3' = round(pca_loading_value$rotation[, 3], 3),
  'SPCA PC1' = round(spca_result$loadings[, 1], 1),
  'SPCA PC2' = round(spca_result$loadings[, 2], 1)
)

# 2. Explained variance table using tibble
pca_spca_explained_variance <- tibble::tibble(
  Variable = "Explained Variance (%)",
  'PCA PC1' = round(total_explained_variance[1], 1),
  'PCA PC2' = round(total_explained_variance[2], 1),
  'PCA PC3' = round(summary(pca_loading_value)$importance["Proportion of Variance", 3] * 100, 2),
  'SPCA PC1' = round(spca_result$pev[1] * 100, 1),
  'SPCA PC2' = round(spca_result$pev[2] * 100, 1)
)

# we combine two table using bind_rows
result_table <- bind_rows(loadings_table, pca_spca_explained_variance)

# We print the Table for paper.qmd
kable(result_table, caption = "Table 1: Results of the Simulation Example — Loadings and Variance")
