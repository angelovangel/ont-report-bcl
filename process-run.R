#!/usr/bin/env Rscript
#============
#

# The script makes a report similar to the one from MinKNOW but better
# Input:
# - path to a raw ONT run folder (where sequencing_summary.. fastq_pass .. etc are located) 
# Output:
# - report.csv - fastq statistics per sample or per barcode
# - report.html - report containing metadata from final_summary, sequencing summary and fastq files
#
# Requirements:
# - https://github.com/angelovangel/faster2
# - R libraries loaded in report.Rmd
#============


library(optparse)
require(rmarkdown)

option_list <- list(
  make_option(c('--path', '-p'), 
              help = 'path to run folder [%default]', 
              type = 'character', default = NULL),
  make_option(c('--outfile','-o'), 
              help = 'name of output report file [%default]', 
              type = 'character', default = 'report.html')
  )

opt_parser <- OptionParser(option_list = option_list, 
                           description = 'Generate a csv/html report from data in a ONT run folder', 
                           epilogue = 'https://github.com/angelovangel/ont-report-bcl.git')
opts <- parse_args(opt_parser)

if (is.null(opts$path)){
  print_help(opt_parser)
  stop("At least a path to a ONT run folder is required (use option '-p path/to/folder')", call.=FALSE)
}




# render the rmarkdown, using fastq-report.Rmd as template
rmarkdown::render(input = "report.Rmd",
                  output_file = opts$outfile,
                  output_dir = getwd(), # important when knitting in docker
                  knit_root_dir = getwd(), # important when knitting in docker
                  params = list(
                    path = opts$path
                  )
)
