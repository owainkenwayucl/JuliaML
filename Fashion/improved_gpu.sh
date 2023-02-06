#!/bin/bash -l

#$ -l h_rt=1:0:0
#$ -pe smp 8
#$ -l mem=4G
#$ -l gpu=1

#$ -cwd

module load julia/1.8.5
./setup.sh
export JULIA_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=${OMP_NUM_THREADS}
julia --project="${PWD}" improved_gpu.jl
