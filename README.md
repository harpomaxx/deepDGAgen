## Using neural networks for DGA generation

Part of the ai-dojo project.

## Tools

Keras, TensorFlow, R

### MODELS

### Model 1

A char-level convolutional neural network for domains generation. Given an initial domain, the network will predict the next most likely character. A plumber dockerized service is available [here](https://github.com/harpomaxx/deepDGAgen/tree/master/code/R/plumber/dgagen).

**Operation:** the botmaster and the botnet should have the list of initial domains. In other words the seed to start generating domains must be chosen from a list of domains included in the service. Then we need to establish a mechanism for synchronyzing the seed to start generating from the same initial set of sequences. Or find a way to generate a particular domain name to start generating from.

**Benefits:**

-   Fast. It is easy and fast to generate thousands of pseudo-bening domains.

**Flaws:**

-   An initial set of sequences is needed to start generating new domains

-   We can not control the the similarities/differences of the generated domain against a particular domain.

### Model 2

Using auto encoders to create an embedded space from an initial set of bening domains. Domain autoencoders are based on a encoder/decoder LSTM architecture. So instead of using a domain list as a seed, the idea is to compress the list using sequence autoencoders. The domains (\~100K for now) list used as seed was reduced to a 128-dimensional vector. Then we can use the decoder to recreate the original domain. A notebook with the implementation is available [here](https://github.com/harpomaxx/deepDGAgen/blob/master/code/R/notebooks/sequences-autoencoders.rmd).

**Operation:** The botmaster and the botnet should share the same seed. The seed in this case would be the coordinates of an initial set of domains on the latent space learned by the autoencoders.

**Benefits:**

-   Fast. It is easy and fast to generate thousands of pseudo-bening domains.

-   We can generate multiple domains similar to an initial domain

**Flaws:**

-   Initial set of domains can be encoded in the embedded space. No need to have the actual list of domain. Only the embedded space is necesary and the information of the coordinates of each of the encoded domains of the initial list. (not very practical)
-   Generating multiple new domains is dificult. The learned latent space is not continuous. So given an initial domain, it is difficult to generate new variation of this particular sentences.

### Model 3

Variational autoencoders to create an embedded space from benign domains. Domain autoencoders is based on a encoder/decoder LSTM architecture. A notebook with the implementation is available [here](https://github.com/harpomaxx/deepDGAgen/blob/master/code/R/notebooks/sequences-vae-final.rmd).

**Operation:** The botmaster and the botnet should have the same seed. The seed in this case would be the coordinates of an initial set of domains on the latent space learned by the autoencoders.

**Benefits:**

-   Fast. It is easy and fast to generate thousands of pseudo-bening domains.

-   We can generate multiple domains similar to an initial domain

-   We can control the similarities/differences of the generated domain against an initial domain.
