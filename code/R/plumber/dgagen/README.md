# DGAGEN

A service for generating pseudo-random domains using a CNN using Tensorflow R API

## INSTALL:

Since installing *Tensorflow* and *Keras* could be difficult the best approach is to use a provided docker image
available [here](https://hub.docker.com/repository/docker/harpomaxx/dgagen)

### TRYING DOCKER

```
docker run -p8001:8001 harpomaxx/dgagen:cnnv1
```	 
	 	 
### TRYING STANDALONE

#### Install dependencies

```
R -e "install.package(
	 c('tensorflow',
	 'tokenizers',
	 'keras',
	 'reticulate',
	 'stringr',
	 'dplyr',
	 'purrr',
	 'plumber')
)"

```

#### Execute the service

```
Rscript  ./launchservice.R
```


## QUERING THE SERVICE


#### Use curl to test the service

```
 curl "http://localhost:8001/generate?n=10&seed=2&tld=.com"
```

#### You should receive an answer similar to this one

```
{"version":"aidojo-dgagen-cnnv1",
	"domains":[	"wscompartingcomlesperscomlersandersc.com",
			"wscomparfingradesc.com",
			"wscomskorgmallingeruscombrog.com",
			"wscompycombroudcomfrasesto.com",
			"rsanetscomsalingsour.com",
			"rsanetcombroukplys.com",
			"wcompressingcomm.com",
			"wscomderfindenscomsenterscomstoresco.com",
			"rscomshofrangracomfarthenton.com",
			"rscommycomsalinescomalane.com"
		]
}
```
