# CharBot 

A service for generating pseudo-random domains using the approach proposed by the paper
CharBot: A Simple and Effective Method for Evading DGA Classifiers *Peck et al., 2019*

## INSTALL:

Please use the provided docker image
available [here](https://hub.docker.com/repository/docker/harpomaxx/charbot)

### TRYING DOCKER

```
docker run -p8001:8001 harpomaxx/charbot
```	 
	 	 
### TRYING STANDALONE

#### Install dependencies

```
R -e "install.package( 'plumber')"

```

#### Execute the service

```
Rscript  ./launchservice.R
```


## QUERING THE SERVICE


#### Use curl to test the service

```
 curl "http://localhost:8001/generate?n=10&seed=2"
```

#### You should receive an answer similar to this one

```
{"version":"aidojo-charbot-v1",
	"domains":["eteanaH-auto.com",
		   "8hdearHrea.org",
		   "twojehc.ru",
		   "dziNoo.com",
		   "bo01zi.cn",
                   "bytheswo4dOnc.ar",
                   "thecupe7cars.com",
                   "literateprobraMs.br",
                   "hIftolines.com",
                    "crispxultuse.info"]
}
```
