# start service
library(plumber)
r <- plumb("./charbot-service.R")
r$run(host = "0.0.0.0",port=8001)
