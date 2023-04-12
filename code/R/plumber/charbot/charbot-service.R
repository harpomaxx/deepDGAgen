library(plumber)
#* @apiTitle Charbot DGA API
#* @apiDescription 
source("charbot.R")
# Load  list of benign domains
d <-readRDS("./domains.rds")

#* Generate domain names pseudo-randomly
#* @param seed The seed to start generating
#* @param n The number of domains to generate
#* @param tld a list of top level domain
#* @param sld a lsit of second level domain
#* @get /generate
#* @serializer unboxedJSON

function(seed=1, n=1, domains=d) {
  seed <- as.integer(seed) %% length(seq)
  n <- as.integer(n)
  dga<-charbot_generatedga(
        seed=seed,
        n = n,
	      tlds = d$tld,
	      slds = d$sld )
  list(version='aidojo-charbot-v1',domains=dga)    
}
