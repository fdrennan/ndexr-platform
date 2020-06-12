#' @export upload_police_data
upload_police_data <- function() {
  library(openxlsx)
  download.file("https://mappingpoliceviolence.org/s/MPVDatasetDownload.xlsx", "kbp.xlsx")
  police_data <- read.xlsx("kbp.xlsx")
  fs::file_delete("kbp.xlsx")
  police_data <-
    police_data %>%
    rename_all(function(x) {
      x %>%
        str_replace_all("\\.", "_") %>%
        str_replace_all("\\(", "_") %>%
        str_replace_all("\\)", "") %>%
        str_replace_all("__", "_") %>%
        str_replace_all("\\?", "") %>%
        str_replace_all("\\/", "_") %>%
        str_replace_all("\\'s", "_") %>%
        str_replace_all(":", "") %>%
        str_replace_all("__", "_") %>%
        str_replace_all("-", "_") %>%
        str_to_lower()
    }) %>%
    rename(
      geography = geography_via_trulia_methodology_based_on_zipcode_population_density_http_jedkolko_com_wp_content_uploads_2015_05_full_zcta_urban_suburban_rural_classification_xlsx_
    )
  db_drop_table(con = con, table = "police_shootings")
  dbWriteTable(conn = con, name = "police_shootings", value = police_data)
}
