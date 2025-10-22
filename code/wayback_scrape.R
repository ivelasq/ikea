# Exploring IKEA Assembly Instructions

# StackOverflow tutorial: https://stackoverflow.com/questions/31517121/using-r-to-scrape-the-link-address-of-a-downloadable-file-from-a-web-page

# Libraries ---------------------------------------------------------------

library(tidyverse)
library(rvest)
library(wayback)
library(lubridate)

set.seed(2018) # when I started this project

# Download IKEA PDFs  -----------------------------------------------------

# Web scraping from Wayback Machine to get PDF names

page <-
  read_html('https://web.archive.org/web/20190103112742/https://www.ikea.com/ms/en_US/customer_service/assembly_instructions.html')

pdf_fromsite <-
  page %>%
  html_nodes("a") %>%       # find all links
  html_attr("href") %>%  # get the url
  str_subset(".pdf") %>%   # find those that end in pdf
  str_extract("(?<=open\\(\\').+?(?>pdf)") %>%
  as_tibble()

# Get Wayback Machine links for the PDFs

pdf_old <-
  pdf_fromsite %>% 
  mutate(urls = paste0("https://www.ikea.com", value))

pdf_latest <-
  map(.x = pdf_old$urls,
      .f = archive_available)

# saveRDS(pdf_latest, here::here("data", "wayback_output.rds"))

pdf_valid <-
  pdf_latest %>% 
  map(~ as_tibble(.x, .name_repair = "unique")) %>% 
  bind_rows() %>% 
  filter(available == "TRUE") %>% 
  select(closet_url)

# write_csv(pdf_valid, here::here("data", "wayback_pdf_urls.csv"))

pdf_test <-
  pdf_valid %>% 
  sample_n(300) %>% 
  as_vector()

save_here <- paste0("./ikea_pdfs/assembly_instructions_", 1:300, ".pdf")

mapply(download.file, pdf_test, save_here)
