#### Preamble ####
# Purpose: Cleans the raw non regulated lead data
# Author: Yuchao Niu
# Date: 25 Jan 2024
# Contact: yc.niu@utoronto.ca
# License: MIT
# Pre-requisites: none

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)

### Clean the data ###
raw_data <- read.csv("inputs/data/raw_data.csv")

# # Select the columns of interest
col_name <- names(raw_data)
raw_data <- raw_data %>%
  rename("Year" = "REF_DATE",
         "Leading_Cause_Death" = "Leading.causes.of.death..ICD.10.",
         "Value" = "VALUE") %>%
  select("Year", "Characteristics", "Leading_Cause_Death", "Value")
# 
# # Subset for Number of Deaths
# number_data <- filter(raw_data, Characteristics == "Number of deaths") %>%
#   select(Year, Leading_Cause_Death, Value) %>%
#   rename(Number_of_Death = Value) %>%
#   distinct(Year, Leading_Cause_Death, .keep_all = TRUE)
# view(number_data)
# 
# # Subset for Ranking
# ranking_data <- filter(raw_data, Characteristics == "Rank of leading causes of death") %>%
#   select(Year, Leading_Cause_Death, Value) %>%
#   rename(Ranking = Value)
# 
# 
# # Identify causes of death with missing number of deaths or ranking
# missing_number <- setdiff(unique(raw_data$Leading_Cause_Death), unique(number_data$Leading_Cause_Death))
# missing_ranking <- setdiff(unique(raw_data$Leading_Cause_Death), unique(ranking_data$Leading_Cause_Death))
# 
# # Combine missing information
# missing_info <- union(missing_number, missing_ranking)
# 
# print(missing_info)
# 
# # Create a full list of unique combinations of Year and Leading_Cause_Death
# all_combinations <- expand.grid(Year = unique(raw_data$Year), Leading_Cause_Death = unique(raw_data$Leading_Cause_Death))

# Prepare datasets for "Number of deaths" and "Rank of leading causes of death"
number_of_deaths <- raw_data %>%
  filter(Characteristics == "Number of deaths") %>%
  select(Year, Leading_Cause_Death, Number_of_Death = Value)

ranking_of_death <- raw_data %>%
  filter(Characteristics == "Rank of leading causes of death") %>%
  select(Year, Leading_Cause_Death, Ranking = Value)

# Combine the subsets 
combined_data <- full_join(number_of_deaths, ranking_of_death, by = c("Year", "Leading_Cause_Death"))
view(combined_data)

# # Identify missing data for each characteristic by checking against all possible combinations
# missing_number <- anti_join(all_combinations, number_of_deaths, by = c("Year", "Leading_Cause_Death"))
# missing_ranking <- anti_join(all_combinations, ranking_of_death, by = c("Year", "Leading_Cause_Death"))
# 
# # View results
# print(paste("Missing Number of Deaths: ", nrow(missing_number)))
# print(paste("Missing Rankings: ", nrow(missing_ranking)))
# 


# Filter out rows containing yearly totals
cleaned_data <- filter(combined_data, !grepl("\\[A00-Y89\\]", Leading_Cause_Death))
view(cleaned_data)

#### Save data ####
write_csv(cleaned_data, "outputs/data/cleaned_data.csv")
