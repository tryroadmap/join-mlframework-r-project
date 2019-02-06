# **************************************
# options
# **************************************
options(scipen = 100)
options(dplyr.width = Inf)
options(dplyr.print_max = Inf)

# **************************************
# packages
# **************************************
# install package

install_packages <- 0
if(install_packages == 1){
  install.packages(c("Hmisc",
                     "xgboost",
                     "readr",
                     "stringr",
                     "caret",
                     "car",
                     "plyr",
                     "dplyr",
                     "tidyr",
                     "data.table",
                     "DescTools",
                     "Matrix",
                     "filesstrings",
                     "h20"))
}

# load libraries
library(Hmisc)
library(xgboost)
library(readr)
library(stringr)
library(caret)
library(car)
library(plyr)
library(dplyr)
library(tidyr)
library(data.table)
library(Matrix)
library(filesstrings)

library(h2o)

# **************************************
# functions
# **************************************
'%nin%' <- Negate('%in%')
'%in_v%' <- function(x, y) x[x %in% y]
'%nin_v%' <- function(x, y) x[!x %in% y]
'%in_d%' <- function(x, y) x[names(x) %in% y]
'%nin_d%' <- function(x, y) x[!names(x) %in% y]
'%+%' <- function(x, y) paste0(x, y)

Mean <- function(x) mean(x, na.rm=TRUE)
Median <- function(x) median(x, na.rm=TRUE)
Sd <- function(x) sd(x, na.rm=TRUE)
Sum <- function(x) sum(x, na.rm=TRUE)
Max <- function(x) max(x, na.rm=TRUE)
Min <- function(x) min(x, na.rm=TRUE)
Mean_value <- function(x) ifelse(is.nan(mean(x, na.rm=TRUE))==T, NA, mean(x, na.rm=TRUE))
Sum_value <- function(x) ifelse(sum(!is.na(x))==0, NA, sum(x, na.rm=TRUE))
Max_value <- function(x) ifelse(is.infinite(max(x, na.rm=TRUE))==T, NA, max(x, na.rm=TRUE))
Min_value <- function(x) ifelse(is.infinite(min(x, na.rm=TRUE))==T, NA, min(x, na.rm=TRUE))
ka_print_size <- function(x) {print("Dim Value", paste0(dim(x))) }

ka_input_transport <- function() {
  input_files_ <- list.files(pattern = ".csv")
  for (names in input_files_){
    file.move(paste0(getwd(),"/","input","/",names), paste0(getwd(),"/","data","/",names))
  }
}
    }

# **************************************
# h2o Cluster
# **************************************

# Check connection with H2O and ensure local H2O R package matches server version.
# Optionally ask for startH2O to start H2O if it’s not already running.
# Note that for startH2O to work, the IP must be localhost and you must
# have installed with the Windows or Mac installer package so H2O is in
# a known place. startH2O requires the port to be 54321.
myIP_ = "localhost"
myPort_ = 54321
localH2O = h2o.init(nthreads = -1,
                    max_mem_size = "10g",
                    ip = myIP_, port = myPort_, startH2O = TRUE)

h2o.setTimezone("America/New_York")

# # **************************************
# # Custome Measure: ndcg5 metric
# # **************************************
# dcg_at_k <- function (r, k=min(5, length(r)) ) {
#   #only coded alternative formulation of measures used
#   r <- as.vector(r)[1:k]
#   sum(( 2^r - 1 )/ log2( 2:(length(r)+1)) )
# }
