#!/usr/bin/env bash

set -e
julia -e "using Pkg; Pkg.update(); Pkg.activate(\"${PWD}\"); Pkg.instantiate()"
