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
raw_data <- read_parquet("inputs/data/raw_data.parquet")

# # Select the columns of interest
col_name <- names(raw_data)
raw_data <- raw_data %>%
  rename("Year" = "REF_DATE",
         "Cause" = "Leading.causes.of.death..ICD.10.",
         "Value" = "VALUE") %>%
  select("Year", "Characteristics", "Cause", "Value")
  
number_of_deaths <- raw_data %>%
  filter(Characteristics == "Number of deaths") %>%
  select(Year, Cause, Death = Value)

ranking_of_death <- raw_data %>%
  filter(Characteristics == "Rank of leading causes of death") %>%
  select(Year, Cause, Ranking = Value)

# Combine the subsets 
combined_data <- full_join(number_of_deaths, ranking_of_death, by = c("Year", "Cause"))

# Filter out rows containing yearly totals
cleaned_data <- filter(combined_data, !grepl("\\[A00-Y89\\]", Cause)) %>%
  mutate(Cause = sub("\\[.*", "", Cause))

#### Save data ####
write_parquet(cleaned_data, "outputs/data/cleaned_data.parquet")
