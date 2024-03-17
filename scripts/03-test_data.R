#### Preamble ####
# Purpose: Tests Mortality Dataset
# Author: Yc.niu@utoro
# Contact: yc.niu@utoronto.ca
# License: MIT
# Pre-requisites: N.A.
# Any other information needed? N.A.

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Test Data ####
# read cleaned data #
cleaned_data <- read_parquet("outputs/data/cleaned_data.parquet")

# Test for Valid Years Range
if(all(cleaned_data$Year >= 2001 & cleaned_data$Year <= 2023)) {
  print("Test Passed: All years are within the 2001 to 2023 range")
} else {
  print("Test Failed: Some years are outside the 2001 to 2023 range")
}

# Test for Non-negative Number of Deaths
if (all(cleaned_data$Death >= 0, na.rm = TRUE)) {
  print("Test Passed: Number of Deaths is non-negative")
} else {
  print("Test Failed: There are negative values in Number of Deaths")
}

# Test for No Missing Values
if(sum(is.na(cleaned_data)) == 0) {
  print("Test Passed: No missing values in the dataset")
} else {
  print("Test Failed: There are missing values in the dataset")
}

# Test for Unique Ranks per year
cleaned_data %>%
  group_by(Year, Cause) %>%
  summarise(is_unique_rank = n_distinct(Ranking) == n()) %>%
  ungroup() %>%
  filter(is_unique_rank == FALSE) -> non_unique_rank_cases

if (nrow(non_unique_rank_cases) == 0) {
  print("Test Passed: Ranks are unique for each cause of death per year")
} else {
  print("Test Failed: Ranks are not unique for each cause of death per year")
}

# Test for No Duplicate Observations
if(nrow(cleaned_data) == nrow(unique(cleaned_data))) {
  print("Test Passed: No duplicate observations")
} else {
  print("Test Failed: There are duplicate observations")
}

# Test for Correct Data Types

## Test for 'Death' column being numeric
if (class(cleaned_data$Death) == "numeric") {
  message("Test Passed: 'Death' column is numeric.")
} else {
  message("Test Failed: 'Death' column is not numeric.")
}

## Test for 'Ranking' column being numeric
if (class(cleaned_data$Ranking) == "integer") {
  message("Test Passed: 'Ranking' column is integer.")
} else {
  message("Test Failed: 'Ranking' column is not integer.")
}

## Test for 'Cause' column being character
if (class(cleaned_data$Cause) == "character") {
  message("Test Passed: 'Cause' column is character.")
} else {
  message("Test Failed: 'Cause' column is not character.")
}





