# Introduction to handle JSON data with R

## Read JSON from web API
`
library(jsonlite)
urljson <- "https://infopemilu.kpu.go.id/pilkada2018/pemilih/dpt/1/JAWA%20BARAT/BOGOR/DRAMAGA/listDps.json"
dps <- fromJSON(urljson)
`
