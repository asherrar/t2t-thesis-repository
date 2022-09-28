#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=24:00:00
#SBATCH --job-name=gcbias_pacbio
#SBATCH --output=/home/asherrar/logs/%x-%a.o
#SBATCH --error=/home/asherrar/logs/%x-%a.e
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH --array=2-4
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=andrew.sherrard@bcchr.ca

sample=HG00$SLURM_ARRAY_TASK_ID
cd /scratch/asherrar/thesis_files/bam/pacbio/merged

destination=/scratch/asherrar/thesis_files/deeptools/gcbias
	
computeGCBias -b $sample-pacbio-chm13v2.0-merged.bam --effectiveGenomeSize 3117275501 -p 16 \
	-g /scratch/asherrar/thesis_files/references/chm13v2.0.2bit \
	-o $destination/$sample-pacbio-chm13v2.0-gcbias.txt \
	--biasPlot $destination/$sample-pacbio-chm13v2.0-gcbias.png

computeGCBias -b $sample-pacbio-hg38-merged.bam --effectiveGenomeSize 2913022398 -p 16 \
	-g /scratch/asherrar/thesis_files/references/hg38.2bit \
	-o $destination/$sample-pacbio-hg38-gcbias.txt \
	--biasPlot $destination/$sample-pacbio-hg38-gcbias.png
	
computeGCBias -b $sample-pacbio-hg19-merged.bam --effectiveGenomeSize 2864785220 -p 16 \
	-g /scratch/asherrar/thesis_files/references/hg19.2bit \
	-o $destination/$sample-pacbio-hg19-gcbias.txt \
	--biasPlot $destination/$sample-pacbio-hg19-gcbias.png