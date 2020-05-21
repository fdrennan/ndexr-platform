#' @export find_parent
find_parent <- function(hot_scrapes, inferior_id) {
  data_for_search <- hot_scrapes %>%
    filter(str_detect(id, inferior_id)) %>%
    select(contains("id"), body, created_utc)

  parent_id_detect <- str_remove_all(data_for_search$parent_id, ".._")
  parent_thread <- filter(hot_scrapes, str_detect(id, parent_id_detect))

  if (nrow(parent_thread) == 0) {
    final_thread <- TRUE
  } else {
    final_thread <- FALSE
  }

  list(parent_id = parent_id_detect, parent = parent_thread, final_thread = final_thread)
}


#' @export create_thread
create_thread <- function(hot_scrapes, inferior_id_key) {
  base_row <- filter(hot_scrapes, id == inferior_id_key)
  run_iter <- TRUE
  while (run_iter) {
    response <- find_parent(hot_scrapes = hot_scrapes, inferior_id = inferior_id_key)

    run_iter <- response$final_thread == FALSE
    inferior_id_key <- response$parent_id
    if (run_iter) {
      base_row <- bind_rows(response$parent, base_row)
    }
  }
  response <- base_row %>% arrange(created_utc)

  response
}
