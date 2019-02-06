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

#install_packages <- 0
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
                     "glmnet"))
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
library(glmnet)




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



# # **************************************
# # Custome Measure: ndcg5 metric
# # **************************************
# dcg_at_k <- function (r, k=min(5, length(r)) ) {
#   #only coded alternative formulation of measures used
#   r <- as.vector(r)[1:k]
#   sum(( 2^r - 1 )/ log2( 2:(length(r)+1)) )
# }
