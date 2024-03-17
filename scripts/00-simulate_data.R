#### Preamble ####
# Purpose: Simulates dataset 
# Author: Yuchao Niu
# Date: 16 March 2024
# Contact: yc.niu@utornoto.ca
# License: MIT
# Pre-requisites: N.A.
# Any other information needed? N.A.


#### Workspace setup ####
library(tidyverse)
library(dplyr)

#### Simulate data ####
set.seed(123) # Ensure reproducibility

# Create a dataset
num_observations <- 120
years <- sample(2001:2023, num_observations, replace=TRUE)
causes_of_death <- c('heart disease', 'kidney disease', 'cancer', 'lung disease', 'neuro', 'skin', 'skeletomuscular')
death_causes <- sample(causes_of_death, num_observations, replace=TRUE)
number_of_deaths <- sample(100:1000, num_observations, replace=TRUE)

sim_data <- data.frame(Year=years, 'Cause of Death'=death_causes, 'Number of Deaths'=number_of_deaths)

# Calculate the total number of deaths by cause
death_counts_by_cause <- aggregate(dataset$`Number of Deaths`, by=list(Cause=dataset$`Cause of Death`), FUN=sum)
names(death_counts_by_cause) <- c('Cause of Death', 'Total Deaths')

# Rank the causes by the number of deaths
death_counts_by_cause$Rank <- rank(-death_counts_by_cause$`Total Deaths`, ties.method='min')

# Merge the ranking back to the original dataset
dataset_with_rank <- merge(dataset, death_counts_by_cause[,c('Cause of Death', 'Rank')], by='Cause of Death')



