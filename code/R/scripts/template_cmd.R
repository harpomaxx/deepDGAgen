suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))

source("code/R/functions/function_template.R")
option_list <- list(
  make_option("--input", action="store", type="character", help = "Set the name of the input file"),
  make_option("--output", action="store", type="character", default="igraph.png", help = "Set the name of the output file")
)
opt <- parse_args(OptionParser(option_list=option_list))

if (is.null(opt$input) || is.null(opt$output)){
  message("[] Parameters missing. Please use --help for look at available parameters.")
  quit()
}else{
  # put your code here
  
  
}
