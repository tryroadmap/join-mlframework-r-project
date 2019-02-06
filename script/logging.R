#' Logger Method for Kaggle Alchemy package.
#' kaggleAlchemyLogger <- function(@param){...}
#' writes to /log folder
#' @return before any other script is runnning it grabs values from Sys.env and
#' ts(timestamp) from lubridate.
#' cat("hello kaggle alchemy") ps id number
#' kudos to http://patorjk.com for text-to-ascii art'
#' library(cowsay): http://bit.ly/kagglealchemyart



ascii_art <- c("", " ____  __.                     .__              _____  .__         .__                          ",
"|    |/ _|____     ____   ____ |  |   ____     /  _  \\ |  |   ____ |  |__   ____   _____ ___.__.",
"|      < \\__  \\   / ___\\ / ___\\|  | _/ __ \\   /  /_\\  \\|  | _/ ___\\|  |  \\_/ __ \\ /     <   |  |",
"|    |  \\ / __ \\_/ /_/  > /_/  >  |_\\  ___/  /    |    \\  |_\\  \\___|   Y  \\  ___/|  Y Y  \\___  |",
"|____|__ (____  /\\___  /\\___  /|____/\\___  > \\____|__  /____/\\___  >___|  /\\___  >__|_|  / ____|",
"        \\/    \\//_____//_____/           \\/          \\/          \\/     \\/     \\/      \\/\\/     ",
"")
cat(ascii_art, sep="\n")


kaggleAlchemyLogger <- function(){
library(lubridate)

timestamp_now_ <- now()
sys_user_env_ <- Sys.getenv("LOGNAME")
sys_platf_env_ <- Sys.getenv("R_PLATFORM")
version_r_ <- strsplit(R.version.string,' ')[[1]][3]
pipeline_h_ <- "0"  #1: unhealthy TODO report error



logger_ <- data.frame("ts" = timestamp_now_,
                      "user"=sys_user_env_,
                      "platform"=sys_platf_env_,
                      "version"= version_r_,
                      "health" = pipeline_h_
                      )
# Writing log data
write.table(logger_, file = paste0("log/","test_log.txt"),
            append= TRUE, sep = "\t")
}
kaggleAlchemyLogger()
