

library(rvest)
read_html("https://www.youtube.com/watch?v=kQJWAmvKq2w&feature=youtu.be") %>% 
  html_text() %>% 
  str_detect("Roze Draw")
