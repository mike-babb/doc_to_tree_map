####
# Plot a treemap from character counts found in Microsoft work documents
####

# mike babb
# in this, my dissertation documents
# updated: 2025 08 18

library(data.table)
library(fs)
library(magrittr)
library(rstudioapi)
library(treemap)

####
# CLEAN UP
####
rm(list=ls())
gc()

####
# CONTROL LOGIC FOR INPUTS AND OUTPUTS
####
use_demo <- TRUE

if(use_demo){
  # this file was created in python
  input_file_path <- fs::path_dir(rstudioapi::documentPath())
  input_file_name <- 'demo_text.txt'
  
  # use the fs and rstudioapi libraries to get the directory of the script
  output_file_path <- fs::path_dir(rstudioapi::documentPath())
}else{
# input - given a series of files with time stamps in the name
input_file_path <-
  "YOUR-INPUT-PATH"

# generate a list of files
file_list <- list.files(input_file_path, pattern = '(^chapter_data)(.+)(txt$)')
file_list_df <- data.table(file_name = file_list)

# extract the date and time info
file_list_df <- file_list_df[order(file_list_df$file_name, decreasing = TRUE), ]

# get the most recent file
input_file_name <- file_list_df$file_name[1]

# output file path
output_file_path <-
  "YOUR-OUTPUT-PATH"
}

# build the input file path
input_fpn <- file.path(input_file_path, input_file_name)

# output file name: replace the txt with a png
output_file_name <- sub(pattern = 'txt', replacement = 'png', x = input_file_name)
output_fpn <- file.path(output_file_path, output_file_name)

####
# LOAD THE DATA
####
df <- read.csv(file = input_fpn,
               sep = '\t',
               stringsAsFactors = FALSE)

# convert to a data.table
df <- data.table(df)

# generate a vector of column names pertaining to headings
# for use as index columns
heading_col_names <- colnames(df)
heading_col_names <- heading_col_names[2:(length(heading_col_names) - 1)]

####
# PLOT THE TREEMAP
####
# start the plot by creating an empty png
png(filename = output_fpn,
    width = 2000,
    height = 1000)

# create the treemap and direct the output to a png
treemap(
  dtf = df,
  index = heading_col_names,
  vSize = "char_count",
  palette = "Set2",
  title = input_file_name,
  type = "index",
  inflate.labels = TRUE,
  fontsize.labels = 4,
  lowerbound.cex.labels = 0,
  force.print.labels = TRUE,
  overlap.labels = 1
)

# finish the plot!
dev.off()