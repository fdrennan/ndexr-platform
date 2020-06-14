## load packages
# library(tigris)
# library(leaflet)
# library(tidyverse)
#
## cache zip boundaries that are download via tigris package
# options(tigris_use_cache = TRUE)
#
## get zip boundaries that start with 282
#
## get 2016 zip level income data from irs
# irs <- read_csv("https://www.irs.gov/pub/irs-soi/16zpallnoagi.csv")
# con <- postgres_connector()
# police_shootings <- tbl(con, in_schema('public', 'police_shootings')) %>% my_collect
#
#
# irs <-
#  police_shootings %>%
#  group_by(zipcode) %>%
#  count(name = 'n_deaths') %>%
#  ungroup
#
# char_zips <- zctas(cb = TRUE, starts_with = unique(str_sub(irs$zipcode, 1, 3)))
## all colnames to lowercase
# colnames(irs) <- tolower(colnames(irs))
#
# irs <-
#  irs %>%
#  select(zipcode, mean_income = n_deaths)
#
## calculate mean income at zip level
## irs_sub <-
##   irs %>%
##   select(zipcode,
##          n02650,        # Number of returns with total income
##          a02650) %>%    # Total income amount (thousands)
##   rename(returns = n02650,
##          income = a02650) %>%
##   # calculate mean income
##   mutate(income = income * 1000,
##          mean_income = income/returns) %>%
##   arrange(desc(mean_income)) %>%
##   select(zipcode, mean_income)
#
#
## join zip boundaries and income data
# char_zips <- geo_join(char_zips,
#                      irs_sub,
#                      by_sp = "GEOID10",
#                      by_df = "zipcode",
#                      how = "left")
#
#
## create color palette
# pal <- colorNumeric(
#  palette = "Greens",
#  domain = char_zips@data$mean_income)
#
## create labels for zipcodes
# labels <- char_zips@data$mean_income
#
#
# char_zips %>%
#  leaflet %>%
#  # add base map
#  addProviderTiles("CartoDB") %>%
#  # add zip codes
#  addPolygons(fillColor = ~pal(mean_income),
#              weight = 2,
#              opacity = 1,
#              color = "white",
#              dashArray = "3",
#              fillOpacity = 0.7,
#              highlight = highlightOptions(weight = 2,
#                                           color = "#666",
#                                           dashArray = "",
#                                           fillOpacity = 0.7,
#                                           bringToFront = TRUE),
#              label = labels) %>%
#  # add legend
#  addLegend(pal = pal,
#            values = ~mean_income,
#            opacity = 0.7,
#            title = htmltools::HTML("Mean Income <br>
#                                    Tax Returns <br>
#                                    by Zip Code <br>
#                                    2016"),
#            position = "bottomright")
