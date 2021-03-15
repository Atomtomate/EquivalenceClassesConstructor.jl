#!/bin/bash
#SBATCH -t 12:00:00
#SBATCH --ntasks 1
#SBATCH -p standard96
#SBATCH -A hhp00048
julia -e "include(\"VertexReducedGrid.jl\")"
