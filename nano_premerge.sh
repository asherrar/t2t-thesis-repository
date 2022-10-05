#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=00:30:00
#SBATCH --job-name=nano_premerge
#SBATCH --output=/home/asherrar/logs/%x-%a.o
#SBATCH --error=/home/asherrar/logs/%x-%a.e
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=andrew.sherrard@bcchr.ca

cd /scratch/asherrar/thesis_files/bam/nano_ultra

for sample in HG002 HG003 HG004;
do
	for ref in hg19 hg38 chm13v2.0;
	do
		echo "$(ls ${sample}-nano_ultra-${ref}-*)" > ../${sample}-nano_ultra-${ref}
	done
done

sbatch /scratch/asherrar/thesis_files/scripts/nano_merge.sh