# VAE
# This is the current implementation of Variational auto-encoder for sequences.  
# An operational LSTM version.

#' VAE Encoder
#'
#' @param input_size 
#' @param latent_dim 
#'
#' @return
#' @export
#'
#' @examples
create_vae_encoder <- function(input_size, latent_dim) {
  encoder_inputs <-  layer_input(shape=input_size)
  
  x <- encoder_inputs %>%  
    layer_masking(mask_value = 0) %>%
    layer_lstm(256, return_sequences = TRUE) %>%
    layer_lstm(latent_dim)
  
  z_mean    <- x %>% layer_dense(latent_dim, name="z_mean")
  z_log_var <- x %>% layer_dense(latent_dim, name="z_log_var")
  vae_encoder <- keras_model(encoder_inputs, list(z_mean, z_log_var),
                             name="encoder")
}

### Sampler
#
layer_sampler <- new_layer_class(
  classname = "Sampler",
  call = function(self, z_mean, z_log_var) {
    epsilon <- tf$random$normal(shape = tf$shape(z_mean))#,mean=0., stddev=1.0 )
    z_mean + exp(0.5 * z_log_var) * epsilon
  }
)



#' VAE Decoder
#'
#' @param latent_dim 
#' @param maxlen 
#' @param voc_size the size of the vocabulary 
#'
#' @return
#' @export
#'
#' @examples
create_vae_decoder <- function(latent_dim, maxlen, voc_size) {
  latent_inputs <- layer_input(shape = c(latent_dim))
  decoder_outputs <- latent_inputs %>% 
    #layer_dense(256, activation = 'relu') %>%
    layer_repeat_vector(maxlen) %>%
    #layer_lstm(64, return_sequences = TRUE) %>%
    #layer_lstm(128, return_sequences = TRUE) %>%
    layer_lstm(voc_size , return_sequences = TRUE) %>%
    layer_dense(voc_size,activation = 'softmax')
  vae_decoder <- keras_model(latent_inputs, decoder_outputs,
                             name = "decoder")
}

## VAE custom KERAS Model
#

model_vae <- new_model_class(
  classname = "VAE",
  
  initialize = function(encoder, decoder, ...) {
    super$initialize(...)
    self$k <- 0
    #self$cost_annealing <-0
    self$encoder <- encoder
    self$decoder <- decoder
    self$sampler <- layer_sampler()
    self$total_loss_tracker <-
      metric_mean(name = "total_loss")
    self$reconstruction_loss_tracker <-
      metric_mean(name = "reconstruction_loss")
    self$kl_loss_tracker <-
      metric_mean(name = "kl_loss")
  },
  
  metrics = mark_active(function() {
    list(
      self$total_loss_tracker,
      self$reconstruction_loss_tracker,
      self$kl_loss_tracker
    )
  }),
  
  summary = function() {
    summary(self$encoder)
    summary(self$decoder)
  },
  
  train_step = function(data) {
    with(tf$GradientTape() %as% tape, {
      c(z_mean, z_log_var) %<-% self$encoder(data)
      z <- self$sampler(z_mean, z_log_var)
      #z <- z_mean
      #mask <- k_cast(k_not_equal(data, 0), dtype='float32')
      reconstruction <- self$decoder(z) #*  mask     
      reconstruction_loss <-  loss_mean_squared_error(data, reconstruction)#,from_logits = FALSE) #  %>% mean()
      reconstruction_loss <- sum (reconstruction_loss, axis = -1 ) #%>% mean()
      kl_loss <- -0.5 * (1 + z_log_var - z_mean^2 - exp(z_log_var))
      kl_loss <- sum(kl_loss, axis = -1 ) # %>% mean()
      # Implementing cost annealing
      cost_annealing <- ( 1 * (1 - exp( -0.0002 *(self$k)) ))
      total_loss <-  mean(reconstruction_loss + kl_loss *  cost_annealing )
      self$k <- self$k + 1
    })
    grads <- tape$gradient(total_loss, self$trainable_weights)
    self$optimizer$apply_gradients(zip_lists(grads, self$trainable_weights))
    self$total_loss_tracker$update_state(total_loss)
    self$reconstruction_loss_tracker$update_state(reconstruction_loss)
    self$kl_loss_tracker$update_state(kl_loss)
    
    list(total_loss = self$total_loss_tracker$result(),
         reconstruction_loss = self$reconstruction_loss_tracker$result(),
         kl_loss = self$kl_loss_tracker$result())
  }
)

