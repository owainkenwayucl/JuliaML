# Base this image on current Julia install
FROM julia:latest

# Install dependencies - git
RUN apt-get update && apt-get install -y git

# Clone repo from git
RUN git clone https://github.com/owainkenwayucl/JuliaML

# Data mountpoint
RUN mkdir -p /data

# Install Flux.jl + deps
WORKDIR "/JuliaML/Fashion"
RUN bash setup.sh

# Agree to terms for FashionMNIST dataset.
ENV DATADEPS_ALWAYS_ACCEPT=true

# Run it.
CMD julia --project="${PWD}" improved.jl && cp *.bson /data
