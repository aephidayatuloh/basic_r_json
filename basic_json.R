library(jsonlite)

# Read JSON text
js1 <- fromJSON('{ 
          "var1":[1, 2],
          "var2":["value1", "value2"],
          "var3":[623.3, 515.2]
         }
         ')
str(js1)
head(js1)

json1 <- '{ 
  "ID":[1,2,3,4,5],
  "Name":["Rick","Dan","Michelle","Ryan","Gary"],
  "Salary":[623.3,515.2,611,729,843.25],
  "StartDate":["1/1/2012","9/23/2013","11/15/2014","5/11/2014","3/27/2015"],
  "Dept":["IT","Operations","IT","HR","Finance"]
}'
x1 <- fromJSON(json1)
str(x1)
x1 <- as.data.frame(x1, stringsAsFactors = FALSE)
str(x1)

json2 <- '[
  [1, "Rick", 623.3, "1/1/2012", "IT"],
  [2, "Dan", 515.2, "9/23/2013", "Operations"],
  [3, "Michelle", 611, "11/15/2014", "IT"],
  [4, "Ryan", 729, "5/11/2014", "HR"],
  [5, "Gary", 843.25, "3/27/2015", "Finance"]
]'
x2 <- fromJSON(json2)
str(x2)
x2 <- as.data.frame(x2, stringsAsFactors = F)
str(x2)

json3 <- '[
  {
  "ID":1, "Name":"Rick", "Salary":623.3, "StartDate":"1/1/2012", "Dept":"IT"
  },
  {
  "ID":2, "Name":"Dan", "Salary":515.2, "StartDate":"9/23/2013", "Dept":"Operations"
  },
  {
  "ID":3, "Name":"Michelle", "Salary":611, "StartDate":"11/15/2014", "Dept":"IT"
  },
  {
  "ID":4, "Name":"Ryan", "Salary":729, "StartDate":"5/11/2014", "Dept":"HR"
  },
  {
  "ID":5, "Name":"Gary", "Salary":843.25, "StartDate":"3/27/2015", "Dept":"Finance"
  }
]'
x3 <- fromJSON(json3)
str(x3)


# Read JSON data from local .json file
dps2018 <- fromJSON("RJson/dps2018.json")
str(dps2018)

url <- "https://infopemilu.kpu.go.id/pilkada2018/pemilih/dpt/1/JAWA%20BARAT/BOGOR/DRAMAGA/listDps.json"
dps2018 <- fromJSON(url)
str(dps2018)
is.list(dps2018)
head(dps2018)
head(dps2018$aaData)
dps2018 <- dps2018$aaData

# Read JSON data from website: infopemilu.kpu.go.id
dps2019 <- fromJSON("https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp.json")
View(dps2019)
str(dps2019)
str(dps2019$table)

dps2019 <- do.call(rbind.data.frame, dps2019$table)
str(dps2019)
head(dps2019)

# Write downloaded JSON data to an external file
write_json(dps2019, "RJson/dps2019.json", pretty = TRUE, dataframes = "rows")

library(dplyr)
# How many 'Kelurahan' in Dramaga?
dps2018 %>% 
  distinct(namaKelurahan) %>% 
  count() 
# Or
nrow(dps2018)

# Which 'Kelurahan' have the largest number of TPS?
dps2018 %>% 
  arrange(desc(jmlTps)) %>% 
  select(namaKelurahan, jmlTps) %>% 
  head(n = 1)

# Visualize it!
tps <- dps2018$jmlTps
names(tps) <- dps2018$namaKelurahan
barplot(tps)

# Use ggplot2 package
library(ggplot2)

dps2018 %>% 
  ggplot(aes(x = reorder(namaKelurahan, jmlTps), y = jmlTps)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_text(aes(label = jmlTps), position = position_dodge(0.5), hjust = -0.25) +
  coord_flip() +
  labs(x = "Kelurahan",
       y = "Jumlah TPS") +
  theme_minimal()

# Visualize the proportion of male and female voters for each TPS
library(tidyr)
persenPemilih <- dps2018 %>% 
  mutate(pct_Laki2 = jmlPemilihLaki/totalPemilih,
         pct_Perempuan = jmlPemilihPerempuan/totalPemilih
         ) %>% 
  select(namaKelurahan, pct_Laki2, pct_Perempuan) %>% 
  gather(key = "jenisKelamin", value = "persenPemilih", -namaKelurahan)

persenPemilih %>% 
  ggplot(aes(x = namaKelurahan, y = persenPemilih, fill = jenisKelamin)) +
  geom_bar(stat = 'identity', position = position_dodge()) +
  scale_fill_manual(values = c("skyblue", "pink")) +
  labs(x = "Kelurahan",
       y = "Proporsi Pemilih") +
  coord_flip() +
  theme_light()

# Import Data from recipe.json
# library(purrr)

recipes <- fromJSON("RJson/recipes.json")
str(recipes)
View(recipes)

batters <- 
  recipes %>% 
  as_tibble() %>% 
  mutate(
    batters = batters[[1]]
  ) %>%
  unnest(batters) %>% 
  rename(batter_id = id1,
         batter = type1)
View(batters)
toppings <- 
  recipes %>% 
  as_tibble() %>% 
  unnest(topping) %>% 
  rename(topping_id = id1,
         topping = type1)

tidy_recipes <- left_join(batters, toppings)
#> Joining, by = c("id", "type", "name", "ppu")

tidy_recipes

