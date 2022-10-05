source("Rscripts/RPC_functions.R")

folder <- "working_folder"
dir(folder, pattern = ".xlsx$|.xls$") -> excel.files
if (length(excel.files) == 0) {
  stop("Couldn't found excel files")
}
process.files(folder, excel.files)
