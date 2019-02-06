kaggleAlchemyLogger <- function(){
# connect to /log folder
# ts(timestamp)
# cat("hello kaggle alchemy") ps id number

library(lubridate)
timestamp_now_ <- now()
sys_user_env_ <- Sys.getenv("LOGNAME")
sys_platf_env_ <- Sys.getenv("R_PLATFORM")
version_r_ <- strsplit(R.version.string,' ')[[1]][3]



logger_ <- data.frame("ts" = timestamp_now_,
                      "user"=sys_user_env_,
                      "platform"=sys_platf_env_,
                      "version"= version_r_
                      )
# Writing log data
write.table(logger_, file = paste0("log/","/test_log.txt"),
            append= TRUE, sep = "\t")
}
kaggleAlchemyLogger()
