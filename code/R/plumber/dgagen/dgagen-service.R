library(plumber)
source("dgagen-helpers.R")
#* @apiTitle DGA API
#* @apiDescription 

# Load the sequence list  used for seeds
seq <-readRDS("seq.rds")

# Load the model
model <- load_model_tf("dgagen.keras")
#freeze_weights(model)

#* Generate domain names pseudo-randomly
#* @param seed The seed to start generating
#* @param n The number of domains to generate
#* @param tld The top level domain
#* @get /generate
#* @serializer unboxedJSON

function(seed=1, n=1, tld=".com") {
  seed <- as.integer(seed) %% length(seq)
  n <- as.integer(n)
  dga<-generatedga(seed=seed, 
              model = model ,
              n = n,
	      tld = tld,
              sequences=seq)
  list(version='aidojo-dgagen-cnnv1',domains=dga)    
}
