#!/bin/Rscript
# Description of the script

# include functions definitions
source("code/R/functions/template_function.R")

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(yaml))

#### MAIN 

option_list <- list(
  make_option(
    "--input",
    action = "store",
    type = "character",
    help = "Set the name of the input data file in tsv format"
  ),
  make_option(
    "--output",
    action = "store",
    type = "character",
    default = "",
    help = "Set the basename of the output data files in tsv format"
  )
)
opt <- parse_args(OptionParser(option_list=option_list))

if (opt$input %>% is.null() ||
    opt$output %>% is.null()) {
  message("[] Parameters missing. Please use --help for look at available parameters.")
  quit()
} else{
  ## Read input Dataset
  dataset <-  readr::read_delim(opt$input, col_types = cols(), delim = '\t')
  ## Set default parameters
  params <- yaml::read_yaml("params.yaml")
  if(!  "template_stage" %in% names(params)) { 
    message("[] Error: no information found")
    quit()
    }
  ## Call function
  dataset_transformed <- template_function(dataset, params$template_stage$param1, params$template_stage$param2)
  ## Save dataset
  dir.create(dirname(opt$output), showWarnings = FALSE)
  readr::write_delim(dataset_transformed, file = paste0(opt$output,"_transformed.tsv"), delim = '\t')
  ## Save Metric
  list("info" = list(
    "metric1" = runif(1),
    "metric2" = runfi(1)
  )) %>% as.yaml() %>% write("metrics/template_metrics.yaml")
}
