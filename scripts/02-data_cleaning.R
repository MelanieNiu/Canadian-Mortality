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

# Select the columns of interest
col_name <- names(raw_data)
raw_data <- raw_data %>%
  rename("Year" = "REF_DATE", 
         "Leading_Cause_Death" = "Leading.causes.of.death..ICD.10.",
         "Value" = "VALUE") %>%
  select("Year", "Characteristics", "Leading_Cause_Death", "Value")

# Subset for Number of Deaths
rd_1 <- subset(raw_data, Characteristics == "Number of deaths") 
rd_1$Number_Death <- rd_1$Value 
rd_1 <- rd_1 %>% 
  select(Year, Leading_Cause_Death, Number_Death)

# Subset for Ranking
rd_2 <- subset(raw_data, Characteristics == "Rank of leading causes of death") 
rd_2$Ranking <- rd_2$Value
rd_2 <- rd_2 %>% 
  select(Year, Leading_Cause_Death, Ranking)

# Combine the subsets and select columns of interest
cleaned_data <- cbind(rd_1, rd_2, by = c("Year","Leading_Cause_Death")) %>%
  select("Year", "Leading_Cause_Death","Ranking","Number_Death")
dim(cleaned_data)

#### Save data ####
write_csv(cleaned_data, "outputs/data/analysis_data.csv")
