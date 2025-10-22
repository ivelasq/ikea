# Exploring IKEA Assembly Instructions

# libraries ---------------------------------------------------------------

library(tidyverse)
library(rvest)
library(pdftools)
library(tesseract)

# stackoverflow tutorial: https://stackoverflow.com/questions/31517121/using-r-to-scrape-the-link-address-of-a-downloadable-file-from-a-web-page

# download ikea pdfs ----------------------------------------------------------

# web scraping

page <-
  read_html('https://web.archive.org/web/20190103112742/https://www.ikea.com/ms/en_US/customer_service/assembly_instructions.html')

pdf_fromsite <-
  page %>%
  html_nodes("a") %>%       # find all links
  html_attr("href") %>%  # get the url
  str_subset(".pdf") %>%   # find those that end in pdf
  str_extract("(?<=open\\(\\').+?(?>pdf)") %>%
  as_tibble()

# downloading pdfs

pdf_urls <-
  pdf_fromsite %>% 
  mutate(urls = paste0("https://web.archive.org/web/2016*/https://www.ikea.com", value)) %>% 
  select(-1) %>% 
  slice(-1:-2) %>%
  slice(1:5) %>% 
  as_vector() 

save_here <- here::here("ikea_pdfs", "assembly_instructions_", 1:5, ".pdf")

mapply(download.file, pdf_urls, save_here)

# reading pdf files -------------------------------------------------------

pdfs_names <-
  list.files(path = here::here("ikea_pdfs"))

downloaded_pdfs <-
  here::here("ikea_pdfs", pdfs_names)

# unfortunately, pdf_text can't read the numbers we'd like
pdf_text(here::here("ikea_pdfs", "assembly_instructions_3.pdf"))

# reading image files -----------------------------------------------------

# creating and reading image files

mapply(ocr, downloaded_pdfs)

ocr("./ikea_pdfs/assembly_instructions_2.pdf", engine = tesseract("eng"))[1]

png_names <-
  list.files(path = "./", pattern = "\\.png$")

# attempt using tesseract -------------------------------------------------

a <- tesseract_params()

eng <- tesseract(options = list(tessedit_char_whitelist = "0123456789",
                                tessedit_ocr_engine_mode = 1,
                                edges_min_nonhole = 20))

cat(ocr(here::here("ikea_png", "assembly_instructions_1_1.png"), engine = eng))
