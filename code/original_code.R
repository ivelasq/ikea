# Exploring IKEA Assembly Instructions

# This is an old file from my original attempts to explore IKEA assembly instructions
# This is back when IKEA had its PDFs on the website, which it no longer does
# It also contains a few failed attempts to read PDFs

# libraries ---------------------------------------------------------------

library(tidyverse)
library(rvest)
library(pdftools)
library(tesseract)

# stackoverflow tutorial: https://stackoverflow.com/questions/31517121/using-r-to-scrape-the-link-address-of-a-downloadable-file-from-a-web-page

# download ikea pdfs ----------------------------------------------------------

# web scraping

page <- read_html('https://www.ikea.com/ms/en_US/customer_service/assembly_instructions.html#7')

pdf_fromsite <-
  page %>%
  html_nodes("a") %>%       # find all links
  html_attr("href") %>%     # get the url
  str_subset(".pdf") %>%   # find those that end in pdf
  str_extract("(?<=open\\(\\').+?(?>pdf)") %>%
  as_data_frame()

# downloading pdfs

pdf_urls <-
  pdf_fromsite %>% 
  mutate(urls = paste0("https://www.ikea.com/", value)) %>% 
  select(-1) %>% 
  slice(-1:-2) %>%
  slice(1:5) %>% 
  as_vector() 

save_here <- paste0("./ikea_pdfs/assembly_instructions_", 1:5, ".pdf")

mapply(download.file, pdf_urls, save_here)

# reading pdf files -------------------------------------------------------

pdfs_names <-
  list.files(path = "./ikea_pdfs/")

downloaded_pdfs <-
  paste0("./ikea_pdfs/", pdfs_names)

# unfortunately, pdf_text can't read the numbers we'd like
# pdf_text("./ikea_pdfs/assembly_instructions_3.pdf")

# reading image files -----------------------------------------------------

# creating and reading image files

mapply(ocr, downloaded_pdfs)

ocr("./ikea_pdfs/assembly_instructions_2.pdf")[1]

png_names <-
  list.files(path = "./", pattern = "\\.png$")