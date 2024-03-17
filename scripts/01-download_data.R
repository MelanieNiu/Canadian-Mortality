#### Preamble ####
# Purpose: Downloads and saves the data from Statistics Canada
# Author: Yuchao Niu
# Date: 11 March, 2024
# Contact: yc.niu@utoronto.ca
# License: MIT
# Pre-requisites: N.A.
# Any other information needed? N.A.

#### Workspace setup ####
install.packages("arrow")
library(tidyverse)
library(arrow)

#### Download data ####
raw_data <- 
  read.csv(
    file = "https://www150.statcan.gc.ca/t1/tbl1/en/dtl!downloadDbLoadingData-nonTraduit.action?pid=1310039401&latestN=0&startDate=20010101&endDate=20220101&csvLocale=en&selectedMembers=%5B%5B1%5D%2C%5B1%5D%2C%5B1%5D%2C%5B%5D%2C%5B1%2C2%5D%5D&checkedLevels=3D1%2C3D2")

#### Save data from the Statistics Canada website  ####
write_parquet(raw_data, "inputs/data/raw_data.parquet") 

         
