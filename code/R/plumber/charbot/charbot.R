
domains_limit <- 1000 # limit the domain generation up to 10000



#' Implementation of the algorithm proposed in 
#' CharBot: A Simple and Effective Method for Evading DGA Classifiers
#'
#' @param slds 
#' @param tlds 
#' @param seed 
#' @param n
#'
#' @return DGA
#' @export

charbot_generatedga <- function(slds, tlds, seed, n) {
  
  dga <- list()
  for (j in seq(1:(n %% domains_limit))) {
    # 1. Initialize the pseudorandom generator with the seed s.
    set.seed(seed)
    seed <- seed+1
    # 2. Randomly select an SLD d from the list of SLDs D.
    sld <- sample(slds, 1)
    
    # 3. Randomly select two indices i and j so that 1 ≤ i, j ≤ |d|.
    i <- sample(1:nchar(sld), 1)
    j <- sample(1:nchar(sld), 1)
    
    # 4. Randomly select two replacement characters c1 and c2 from the set of DNS-valid characters.
    dns_chars <- c(letters, LETTERS, 0:9, "-", "_")
    c1 <- sample(dns_chars, 1)
    c2 <- sample(dns_chars, 1)
    
    # 5. Set d[i] ← c1 and d[j] ← c2.
    sld_modified <- sapply(strsplit(sld, ""), function(x) {
      x[i] <- c1
      x[j] <- c2
      return(paste(x, collapse = ""))
    })
    
    # 6. Randomly select a TLD t from the list of TLDs T.
    tld <- sample(tlds, 1)
    
    # 7. Return d.t
    dga <-c(dga,paste(sld_modified, tld, sep = "."))
  }
  return(dga)
}
