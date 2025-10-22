library(daiR)
library(googleCloudStorageR)
library(purrr)

proj <- "engaged-stage-335616"
buckets <- gcs_list_buckets(proj)
bucket <- "ikea-bucket"
bucket_info <- gcs_get_bucket(bucket)
bucket_info
gcs_global_bucket(bucket)

my_files <- c("ikea_pdfs/assembly_instructions_1.pdf", "ikea_pdfs/assembly_instructions_2.pdf", "ikea_pdfs/assembly_instructions_3.pdf")

map(my_files, gcs_upload)

