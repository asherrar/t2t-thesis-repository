#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=96:00:00
#SBATCH --job-name=minimap_nano
#SBATCH --output=/home/asherrar/logs/%x-%a.o
#SBATCH --error=/home/asherrar/logs/%x-%a.e
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --array=2-4
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=andrew.sherrard@bcchr.ca

module load minimap2/2.24 samtools/1.15.1

sample=HG00$SLURM_ARRAY_TASK_ID

source_dir=/scratch/asherrar/thesis_files/hg002_trio/nano_ultra/$sample
filetype=".fastq.gz"
filetype_length=$(expr '-1' '*' length $filetype)

for file in $source_dir/*$filetype
do
	file_base=$(basename $file)
	file_name=${$file_base::$filetype_length}

	gunzip $file

	for ref in /scratch/asherrar/thesis_files/references/*.fasta
	do
		destination=/scratch/asherrar/thesis_files/bam/nano_ultra
		output_name=$sample-nano_ultra-$file_name-sorted.bam

		# align with minimap2
		minimap2 -ax map-ont $ref $source_dir/$file_name.fastq -t 32 -Y -L --MD | samtools view -bhS - | samtools sort -m80G - -o $destination/$output_name
		samtools index $destination/$output_name
	done 
done
