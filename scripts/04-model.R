#### Preamble ####
# Purpose: Models for Canadian Leading Causes of Death
# Author: Yuchao Niu
# Date: March 11th, 2024
# Contact: yc.niu@utoronto.ca
# License: MIT
# Pre-requisites: N.A.

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

#### Read data ####
cleaned_data <- read_parquet("outputs/data/cleaned_data.parquet")
analysis_data <- cleaned_data |>
  filter(Cause %in% top_five_causes)

### Model data ####

#Poisson Model
canada_death_poisson <-
  stan_glm(
    Death ~ Cause,
    data = analysis_data,
    family = poisson(link = "log"),
    seed = 853
  )

#N binomial Model
canada_death_negbinomial <-
  stan_glm(
    Death ~ Cause,
    data = analysis_data,
    family = neg_binomial_2(link = "log"),
    seed = 853
  )

#### Save model ####

saveRDS(canada_death_poisson, "outputs/models/canada_death_poisson.rds")
saveRDS(canada_death_negbinomial, "outputs/models/canada_death_negbinomial.rds")


# For the Poisson model
poisson_terms <- names(coef(canada_death_poisson))

# For the Negative Binomial model
negbin_terms <- names(coef(canada_death_negbinomial))

# Printing out the terms
print(poisson_terms)
print(negbin_terms)


