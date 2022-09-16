#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=96:00:00
#SBATCH --job-name=bwa_exome
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

source_dir=/scratch/asherrar/thesis_files/hg002_trio/exome/$sample

cd $source_dir
for bam in $(ls *.bam)
do
	samtools collate -u -O $bam | samtools fastq -1 ${sample}_exome_R1.fastq -2 ${sample}_exome_R2.fastq -n
done

for ref in /scratch/asherrar/thesis_files/references/*.fasta
do
	destination=/scratch/asherrar/thesis_files/bam/exome
	ref_file=$(basename $ref)
	ref_name=${ref_file::-6}
	
	# sample-readlength-reference-file
	output_name=$sample-exome-$ref_name-sorted.bam
	echo "Processing $sample with reference $ref"

	# align with bwa
	bwa mem -M -t 32 $ref ${sample}_exome_R1.fastq ${sample}_exome_R2.fastq | samtools view -bhS - | samtools sort -m80G - -o $destination/$output_name
	samtools index $destination/$output_name
done 