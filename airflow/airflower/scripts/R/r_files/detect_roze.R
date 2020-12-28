library(biggr)

detect_roze <- function(youtube_url = NULL) {
  read_html(youtube_url) %>% 
    html_text() %>% 
    str_detect("Roze Draw")
}


detect_roze("https://www.youtube.com/watch?v=kQJWAmvKq2w&feature=youtu.be")
