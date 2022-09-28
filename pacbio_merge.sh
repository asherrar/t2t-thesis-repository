#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=48:00:00
#SBATCH --job-name=pacbio_merge
#SBATCH --output=/home/asherrar/logs/%x-%a.o
#SBATCH --error=/home/asherrar/logs/%x-%a.e
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=64G
#SBATCH --array=2-4
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=andrew.sherrard@bcchr.ca

module load samtools/1.15.1

sample=HG00$SLURM_ARRAY_TASK_ID
mkdir /scratch/asherrar/thesis_files/bam/pacbio/merged
cd /scratch/asherrar/thesis_files/bam

for list in $sample*
do
	cd pacbio
	samtools merge -@ 15 -b /scratch/asherrar/thesis_files/bam/$list -o - | samtools sort -@ 7 -m8G - -o /scratch/asherrar/thesis_files/bam/pacbio/merged/$list-merged.bam
	samtools index /scratch/asherrar/thesis_files/bam/pacbio/merged/$list-merged.bam
	cd ..
done
