# Introduction to handle JSON data with R

Seiring dengan perkembangan teknologi, media maupun tipe data yang disimpan pun turut mengalami perkembangan.

## Objektif


## Read JSON from web API
```
library(jsonlite)
urljson <- "https://infopemilu.kpu.go.id/pilkada2018/pemilih/dpt/1/JAWA%20BARAT/BOGOR/DRAMAGA/listDps.json"
dps <- fromJSON(urljson)
```
