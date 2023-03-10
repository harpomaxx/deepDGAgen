FROM rstudio/plumber
MAINTAINER Carlos Catania (AKA Harpo) "harpomaxx@gmail.com"
RUN apt update -y
RUN  apt install -y python3.10-venv python3-dev
RUN R -e "install.packages('tensorflow')"
RUN R -e "install.packages('keras')"
RUN R -e "install.packages('purrr')"
RUN R -e "install.packages('tokenizers')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('stringr')"
RUN R -e "install.packages('doMC')"
RUN R -e "library(tensorflow);install_tensorflow(version='default-cpu')"
RUN R -e "library(keras);install_keras(version='default-cpu')"
COPY . /app
WORKDIR /app
CMD ["/app/launchservice.R"]

