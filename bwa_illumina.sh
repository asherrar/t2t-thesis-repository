#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=96:00:00
#SBATCH --job-name=bwa_illumina
#SBATCH --output=/home/asherrar/logs/%x-%a.o
#SBATCH --error=/home/asherrar/logs/%x-%a.e
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --array=2-4
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=andrew.sherrard@bcchr.ca

module load bwa/0.7.17 samtools/1.15.1

sample=HG00$SLURM_ARRAY_TASK_ID

source_dir=/scratch/asherrar/thesis_files/hg002_trio/illumina/$sample

for ref in /scratch/asherrar/thesis_files/references/*.fasta
do
	destination=/scratch/asherrar/thesis_files/bam/illumina
	output_name=$sample-illumina-sorted.bam
	echo "Processing $sample with reference $ref"

	# align with bwa
	bwa mem -M -t 32 $ref $source_dir/${sample}_HiSeq30x_subsampled_R1.fastq $source_dir/${sample}_HiSeq30x_subsampled_R2.fastq | samtools view -bhS - | samtools sort -m80G - -o $destination/$output_name
	samtools index $destination/$output_name
done 