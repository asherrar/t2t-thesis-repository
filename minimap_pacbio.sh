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

sample=HG00$SLURM_ARRAY_TASK_ID

source_dir=/scratch/asherrar/thesis_files/hg002_trio/pacbio/$sample
filetype=".fasta"
filetype_length=$(expr '-1' '*' length $filetype)

cd $source_dir

for file in $(ls *$filetype)
do
	file_name=${file::$filetype_length}
	echo "Processing sample file $file_name"

	for ref in /scratch/asherrar/thesis_files/references/*.fasta
	do
		destination=/scratch/asherrar/thesis_files/bam/pacbio
		ref_file=$(basename $ref)
		ref_name=${ref_file::-6}
		
		# sample-readlength-reference-file
		output_name=$sample-pacbio-$ref_name-$file_name-sorted.bam
		echo " - Using reference $ref"

		# align with minimap2
		minimap2 -ax map-pb $ref $source_dir/$file -t 32 -Y -L --MD | samtools view -bhS - | samtools sort -m80G - -o $destination/$output_name
		samtools index $destination/$output_name
	done 
done
