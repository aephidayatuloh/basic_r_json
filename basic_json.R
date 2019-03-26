library(jsonlite)

# Read JSON text
js1 <- fromJSON('{ 
          "var1":[1, 2],
          "var2":["value1", "value2"],
          "var3":[623.3, 515.2]
         }
         ')
str(js1)

json1 <- '{ 
  "ID":[1,2,3,4,5],
  "Name":["Rick","Dan","Michelle","Ryan","Gary"],
  "Salary":[623.3,515.2,611,729,843.25],
  "StartDate":["1/1/2012","9/23/2013","11/15/2014","5/11/2014","3/27/2015"],
  "Dept":["IT","Operations","IT","HR","Finance"]
}'
x1 <- fromJSON(json1)
str(x1)
x1 <- as.data.frame(x1, stringAsFactor = FALSE)
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
x2 <- as.data.frame(x2, stringsAsFactors = FALSE)
str(x2)

json3 <- '[
  {
  "ID":1,
  "Name":"Rick",
  "Salary":623.3,
  "StartDate":"1/1/2012",
  "Dept":"IT"
  },
  {
  "ID":2,
  "Name":"Dan",
  "Salary":515.2,
  "StartDate":"9/23/2013",
  "Dept":"Operations"
  },
  {
  "ID":3,
  "Name":"Michelle",
  "Salary":611,
  "StartDate":"11/15/2014",
  "Dept":"IT"
  },
  {
  "ID":4,
  "Name":"Ryan",
  "Salary":729,
  "StartDate":"5/11/2014",
  "Dept":"HR"
  },
  {
  "ID":5,
  "Name":"Gary",
  "Salary":843.25,
  "StartDate":"3/27/2015",
  "Dept":"Finance"
  }
]'
x3 <- fromJSON(json3)
str(x3)


# Read JSON data from local .json file
jsondata <- fromJSON("RJson/datajson.json")
str(jsondata$data)

# Read JSON data from website: infopemilu.kpu.go.id
dps <- fromJSON("https://infopemilu.kpu.go.id/pilkada2018/pemilih/dpt/1/JAWA%20BARAT/BOGOR/DRAMAGA/listDps.json")
View(dps)
str(dps)
str(dps$aaData)

# Write downloaded JSON data to an external file
write_json(dps, "RJson/dps.json", pretty = TRUE, dataframes = "rows")
dps <- fromJSON("RJson/dps.json")
dps_data <- dps$aaData

library(dplyr)
# How many 'Kelurahan' in Dramaga?
dps_data %>% 
  distinct(namaKelurahan) %>% 
  count() 
# Or
nrow(dps_data)

# Which 'Kelurahan' have the largest number of TPS?
dps_data %>% 
  arrange(desc(jmlTps)) %>% 
  select(namaKelurahan, jmlTps) %>% 
  .[1,]

# Visualize it!
tps <- dps_data$jmlTps
names(tps) <- dps_data$namaKelurahan
barplot(tps)

# Use ggplot2 package
library(ggplot2)
ggplot(dps_data, aes(x = namaKelurahan, y = jmlTps)) +
         geom_bar(stat = 'identity')

# Visualize the proportion of male and female voters for each TPS
persenPemilih <- dps_data %>% 
  mutate(Laki2 = jmlPemilihLaki/totalPemilih,
         Perempuan = jmlPemilihPerempuan/totalPemilih
         ) %>% 
  select(namaKelurahan, Laki2, Perempuan) %>% 
  gather(key = "jenisKelamin", value = "persenPemilih", -namaKelurahan)

persenPemilih %>% 
  ggplot(aes(x = namaKelurahan, y = persenPemilih, fill = jenisKelamin)) +
    geom_bar(stat = 'identity', position = position_dodge()) #+
    # scale_fill_manual(values = c("skyblue","pink"))

# Import Data from recipe.json
library(tidyr)
# library(purrr)

recipes <- fromJSON("RJson/recipes.json") %>% as.data.frame()
str(recipes)

batters <- 
  recipes %>% 
  as_tibble() %>% 
  mutate(
    batters = batters[[1]]
  ) %>%
  unnest(batters) %>% 
  rename(id_batter = id1,
         batter = type1)

toppings <- 
  recipes %>% 
  as_tibble() %>% 
  unnest(topping) %>% 
  rename(topping.id = id1,
         topping = type1)

tidy_recipes <- 
  left_join(batters, toppings)
#> Joining, by = c("id", "type", "name", "ppu")

tidy_recipes
