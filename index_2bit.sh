#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=24:00:00
#SBATCH --job-name=index_2bit
#SBATCH --output=/home/asherrar/logs/%x-%a.o
#SBATCH --error=/home/asherrar/logs/%x-%a.e
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=andrew.sherrard@bcchr.ca

module load bwa/0.7.17

bwa index -a bwtsw /scratch/asherrar/thesis_files/references/hg19.fasta
bwa index -a bwtsw /scratch/asherrar/thesis_files/references/hg38.fasta

/home/asherrar/tools/ucsc_tools/faToTwoBit -noMask /scratch/asherrar/thesis_files/references/hg19.fasta /scratch/asherrar/thesis_files/references/hg19.2bit
/home/asherrar/tools/ucsc_tools/faToTwoBit -noMask /scratch/asherrar/thesis_files/references/hg38.fasta /scratch/asherrar/thesis_files/references/hg38.2bit