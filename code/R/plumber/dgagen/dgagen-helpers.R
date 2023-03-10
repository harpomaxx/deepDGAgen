## Helper functions for generate domains pseudo-randomly

library(tensorflow)
library(tokenizers)
library(keras)
library(reticulate)
library(stringr)
library(dplyr)
library(purrr)

# Default vocabulary
vocabulary <-
  stringr::str_split("$abcdefghijklmnopqrstuvwxyz0123456789-_.+*,\"", pattern = '')[[1]]
valid_characters_vector <- c(vocabulary)
tokens <- 1:length(valid_characters_vector)
names(tokens) <- valid_characters_vector

domains_limit <- 1000 # limit the domain generation up to 10000
maxlen <- 40          # the maxlen of input sequence



#' function for padding sequences
#'
#' @param x 
#' @param maxlen 
#' @param padding 
#' @param truncating 
#' @param value 
#'
#' @return a matrix padded to maxlen
#' @export 
#'
#' @examples
pad_sequences_fast <-
  function(x,
           maxlen,
           padding = "pre",
           truncating = "pre",
           value = 0) {
    x %>%
      map(function(x) {
        if (length(x) > maxlen) {
          if (truncating == "pre") {
            x[(length(x) - (maxlen) + 1):length(x)]
          } else if (truncating == "post") {
            x[1:maxlen]
          } else {
            stop("Invalid value for 'truncating'")
          }
        } else {
          if (padding == "pre") {
            c(rep(value, maxlen - length(x)), x)
          } else if (padding == "post") {
            c(x, rep(value, maxlen - length(x)))
          } else {
            stop("Invalid value for 'padding'")
          }
        }
      }) %>%
      do.call(c, .) %>%
      unlist() %>%
      matrix(ncol = maxlen, byrow = TRUE)
  }

#' convert dataset to matrix of tokens
#'
#' @param data 
#' @param labels 
#' @param maxlen 
#'
#' @return a list with x,y tokenized
#' @export
#'
#' @examples
tokenize <- function(data, labels, maxlen) {
  sequencel <- sapply(data, function(x)
    strsplit(x, split = ""))
  # print(sequencel)
  x_data <- lapply(sequencel, function(x)
    sapply(x, function(x) {
      tokens[[x]]
    }))
  
  y_data <- lapply(labels, function(x)
    sapply(x, function(x) {
      tokens[[x]]
    }))
  
  padded_token <-
    pad_sequences_fast(
      unname(x_data),
      maxlen = maxlen,
      padding = 'post',
      truncating = 'post'
    )
  return (list(x = padded_token, y = y_data %>% unlist() %>% unname()))
  
}

# convert vector with char tokens to one-hot encoding matrix
#'
#' @param data 
#' @param shape 
#'
#' @return a matrix encoded using one-hot
#' @export
#'
#' @examples
to_onehot <- function(data, shape) {
  train <- array(0, dim = c(shape[1], shape[2], shape[3]))
  for (i in 1:shape[1]) {
    for (j in 1:shape[2])
      train[i, j, data[i, j]] <- 1
  }
  return (train)
}

#' Convert vector with char tokens to one-hot encoding vector
#'
#' @param data 
#' @param shape 
#'
#' @return  a matrix encoded using one-hot
#' @export
#'
#' @examples
to_onehot_y <- function(data, shape) {
  train <- array(0, dim = c(shape[1], shape[2]))
  for (i in 1:shape[1]) {
    train[i, data[i]] <- 1
  }
  return (train)
}


#' Create a dataset using one_hot
#'
#' @param data 
#' @param labels 
#' @param maxlen 
#'
#' @return a list with `x` and `y` members encoded
#' @export
#'
#' @examples
build_dataset_one_hot <- function(data, labels, maxlen) {
  labels <- labels %>% as.matrix()
  dataset <- tokenize(data, labels, maxlen)
  shape = c(nrow(dataset$x), maxlen, length(valid_characters_vector))
  dataset$x <- to_onehot(dataset$x, shape)
  shape = c(length(dataset$y), length(valid_characters_vector))
  dataset$y <- to_onehot_y(dataset$y, shape)
  return(dataset)
}


#' Helper function for generating next char Temperature Scaling.
#' An approach similar to Platt's scaling.
#' Softmax outputs tend to produce overconfident probabilities.
#' Using this function the model will basically be less confident 
#' about it's prediction. 
#' more info h
#' https://stackoverflow.com/questions/58764619/why-should-we-use-temperature-in-softmax
#' @param preds 
#' @param chars 
#' @param temperature 
#' @param seed 
#'
#' @return a character picked from vocabulary
#' @export
#'
#' @examples
choose_next_char <- function(preds, chars, temperature,seed){
  set.seed(seed)
  preds <- log(preds) / temperature
  exp_preds <- exp(preds)
  preds <- exp_preds / sum(exp(preds))
  
  next_index <- rmultinom(1, 1, preds) %>%
    as.integer() %>%
    which.max()
  chars[next_index]
}


#' Generate DGA
#'
#' @param seed a number for seeding the model
#' @param n th numbers of domain to generate
#' @param model the model for generating domains
#' @param tld a top level domain
#' @param sequences a list of sequences for seeding the model
#'
#' @return a matrix with domains name
#' @export
#'
#' @examples
generatedga <- function(model, n, seed, tld, sequences) {
  nextseed <- seed
  dga <- c()
  set.seed(seed)
  pkgs<-c("keras")
  for (j in seq(1:(n%%domains_limit))){ 
    initial_sentence <- sequences[seed]
    generated <- ""
    for (i in seq(0:sample(15:35, 1))) {
      set.seed(seed)
      vectorized_test <- tokenize(initial_sentence, "n", maxlen)
      shape = c(nrow(vectorized_test$x),
                maxlen,
                length(valid_characters_vector))
      vectorized_test <- to_onehot(vectorized_test$x, shape)
      predictions <- model(vectorized_test)
      predictions <- predictions%>% as.array() 

      #predictions <-
      #  predict(model, vectorized_test, 
      #		verbose = 0,
      #		use_multiprocessing = TRUE,
      #		workers=5)
      next_char <-
        choose_next_char(
          preds = predictions,
          chars = valid_characters_vector,
          temperature = 0.2,
          nextseed
        )
      initial_sentence <- paste0(initial_sentence, next_char)
      initial_sentence <-
        substr(initial_sentence, 2, nchar(initial_sentence))
      generated <- paste0(generated, next_char)
      nextseed <- nextseed + 1
    }
    dga[j] <- paste0(generated, tld)
  }
  dga
}
