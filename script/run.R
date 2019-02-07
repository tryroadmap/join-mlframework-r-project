#' alchemyMLPipelineSetup(@parm){..}
#' The functions builds a template for starting the ML Pipelining project in R or RStudio.
#'
#' recommend one repo per version
#' stacking folders hosts all methods for stacking
#' rfs_xgboost hosts all hyper parameter tunning methods for random forest xgboost
#' logging.R light package runs first closes last/crash
#' for every project only change this file

alchemyMLPipelineSetup <- function (pipelinename ="rushmutatenormalizeccfraudml", pipelineversion="version_01"){

   dir.create(pipelinename) #put references for methos used here if needed.
  # setwd(paste0(getwd(), "/", pipelinename))
  # sprintf("working directory: %s", getwd() )

  # **************************************
  # create directory
  # **************************************
  dir.create(paste0("data")) #  download input here
  dir.create(paste0("cache"))
  dir.create(paste0("submit"))
  dir.create(paste0("log"))




  dir.create(paste0("cache/", pipelineversion))
  dir.create(paste0("cache/", pipelineversion, "/valid"))
  dir.create(paste0("cache/", pipelineversion, "/test"))
  dir.create(paste0("submit/", pipelineversion))

  print("Kaggle Alchemy Directory:")
  print("logging: /log/")
  print("data input: /data/")
  print("submission files: /submit/")



  # **************************************
  # run scripts
  # **************************************
  source("script/logging.R")
  #source("script/utils.R")
  #source("script/preprocessing.R")
  #source("script/stacking.R")
  #source("script/rfs_xgboost.R")
  #source("script/submission.R")

}

alchemyMLPipelineSetup(pipelinename ="rushmutatenormalizeccfraudml", pipelineversion="version_02")
