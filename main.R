source("Rscripts/RPC_functions.R")

folder <- "working_folder"
if(!dir.exists(folder)){
  cat("working_folder didn't exist and was created in the project directory\n")
  dir.create(folder, showWarnings = F)
}
dir(folder, pattern = ".xlsx$|.xls$") -> excel.files
if (length(excel.files) == 0) {
  stop("Couldn't found excel files in the working_folder")
}
process.files(folder, excel.files)
