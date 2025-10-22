# Exploring IKEA Assembly Instructions
# Code by Anthony Durrant from R4DS Slack

# Libraries

library(tidyverse)
library(magick)
library(tesseract)

# Load PDFs

pdfs_names <-
  list.files(path = here::here("ikea_pdfs"))

downloaded_pdfs <-
  here::here("ikea_pdfs", pdfs_names)

# Read PDFs

a <- image_read_pdf(downloaded_pdfs)

numbers <-
  tesseract(options = list(tessedit_char_whitelist = "0123456789"))

tictoc::tic()
a %>%
  image_blur(radius = 13, sigma = 1.2) %>% 
  ocr(engine = numbers) %>% 
  str_split("\n") -> ab
tictoc::toc()
