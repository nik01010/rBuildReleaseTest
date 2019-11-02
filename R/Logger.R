logging::basicConfig(level = "DEBUG")

# TODO: Need to configure logging to console and debug

# AppLog: main application logger -----------------------------------------
# logDirectory <- as.character(Sys.getenv()["HOME"])
# logDirExists <- dir.exists(logDirectory)
# if (logDirExists)
# {
#   baseFileName <- "rBuildReleaseTest"
#   dateString <- Sys.Date()
#   logFileName <- glue::glue('{baseFileName}-{dateString}.log')
#   logFilePath <- paste0(logDirectory, "/", logFileName)
#   logging::addHandler(
#     handler = logging::writeToFile,
#     file = logFilePath,
#     level = "DEBUG"
#   )
# }


# # TestLog: test logger ----------------------------------------------------
# logging::addHandler(
#   handler = logging::writeToConsole,
#   level = "DEBUG",
#   logger = "TestLog"
# )


# sysInfo <- Sys.info()
# user <- sysInfo["user"]
# node <- sysInfo["nodename"]
# startMsg <- glue::glue('Process started by User {user} on Node {node}')
# loginfo(startMsg)
