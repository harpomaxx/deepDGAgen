source("dgagen-helpers.R")

seq <-readRDS("seq.rds")
model <- load_model_tf("dgagen.keras")
freeze_weights(model)
generate<-function(seed=1, n=1) {
  seed <- as.integer(seed) %% length(seq)
  n <- as.integer(n)
  dga<-generatedga(seed=seed, 
              model = model ,
              n = n,
              sequences=seq)
  list(domains=dga)    
}

print(generate(1,10))
