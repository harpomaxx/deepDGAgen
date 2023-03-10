# start service
library(plumber)
r <- plumb("./dgagen-service.R")
r$run(host = "0.0.0.0",port=8001)
