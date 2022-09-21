#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=48:00:00
#SBATCH --job-name=gcbias_illumina
#SBATCH --output=/home/asherrar/logs/%x-%a.o
#SBATCH --error=/home/asherrar/logs/%x-%a.e
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH --array=2-4
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=andrew.sherrard@bcchr.ca

sample=HG00$SLURM_ARRAY_TASK_ID
cd /scratch/asherrar/thesis_files/bam/illumina/

destination=/scratch/asherrar/thesis_files/deeptools/gcbias
	
computeGCBias -b $sample-illumina-chm13v2.0-sorted.bam --effectiveGenomeSize 3117275501 -p 16 \
	-g /scratch/asherrar/thesis_files/references/chm13v2.0.2bit \
	-o $destination/$sample-illumina-chm13v2.0-gcbias.txt \
	--biasPlot $destination/$sample-illumina-chm13v2.0-gcbias.png

computeGCBias -b $sample-illumina-hg38-sorted.bam --effectiveGenomeSize 3209286105 -p 16 \
	-g /scratch/asherrar/thesis_files/references/hg38.2bit \
	-o $destination/$sample-illumina-hg38-gcbias.txt \
	--biasPlot $destination/$sample-illumina-hg38-gcbias.png
	
computeGCBias -b $sample-illumina-hg19_chromosomes-sorted.bam --effectiveGenomeSize 3101804739 -p 16 \
	-g /scratch/asherrar/thesis_files/references/hg19_chromosomes.2bit \
	-o $destination/$sample-illumina-hg19_chromosomes-gcbias.txt \
	--biasPlot $destination/$sample-illumina-hg19_chromosomes-gcbias.png