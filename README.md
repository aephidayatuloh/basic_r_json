# Introduction to handle JSON data with R

Seiring dengan perkembangan teknologi, media maupun tipe data yang disimpan pun turut mengalami perkembangan.

**JSON**: **J**ava**S**cript **O**bject **N**otation.

JSON is a syntax for storing and exchanging data.

JSON is text, written with JavaScript object notation.

## Objektif
* Mengetahui JSON sebagai penyimpanan data
* Mengetahui beberapa struktur JSON yang umum digunakan
* Mampu membaca data dari JSON ke R
* Mampu menuliskan data frame dari R menjadi JSON file
* Mampu membaca data dari JSON bersarang menjadi data frame di R


## Read JSON from web API
```
library(jsonlite)
urljson <- "https://infopemilu.kpu.go.id/pilkada2018/pemilih/dpt/1/JAWA%20BARAT/BOGOR/DRAMAGA/listDps.json"
dps <- fromJSON(urljson)
```
