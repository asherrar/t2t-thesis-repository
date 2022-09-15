#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=96:00:00
#SBATCH --job-name=minimap_pacbio
#SBATCH --output=/home/asherrar/logs/%x-%a.o
#SBATCH --error=/home/asherrar/logs/%x-%a.e
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --array=2-4
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=andrew.sherrard@bcchr.ca

module load minimap2/2.24 samtools/1.15.1
shopt -s nullglob

sample=HG00$SLURM_ARRAY_TASK_ID

source_dir=/scratch/asherrar/thesis_files/hg002_trio/pacbio/$sample
filetype=".fastq"
filetype_length=$(expr '-1' '*' length $filetype)

cd $source_dir

for file in $(ls *$filetype)
do
	file_name=${file::$filetype_length}

	for ref in /scratch/asherrar/thesis_files/references/*.fasta
	do
		destination=/scratch/asherrar/thesis_files/bam/pacbio
		output_name=$sample-pacbio-$file_name-sorted.bam

		# align with minimap2
		minimap2 -ax map-pb $ref $source_dir/$file -t 32 -Y -L --MD | samtools view -bhS - | samtools sort -m80G - -o $destination/$output_name
		samtools index $destination/$output_name
	done 
done
