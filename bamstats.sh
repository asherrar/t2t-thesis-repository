#!/bin/bash

#SBATCH --account=def-frid
#SBATCH --time=24:00:00
#SBATCH --job-name=bamstats
#SBATCH --output=/home/asherrar/logs/%x-%a.o
#SBATCH --error=/home/asherrar/logs/%x-%a.e
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=andrew.sherrard@bcchr.ca

module load java/17.0.2

mkdir -p /scratch/asherrar/thesis_files/bamstats/$1

directory=/scratch/asherrar/thesis_files/bam/$1
cd $directory

for file in ./*.bam
do
	file_name=$(basename ${file::-4})
	
	java -Xmx12g -jar /home/asherrar/tools/BAMStats-1.25/BAMStats-1.25.jar -s -q -d -l -v 'html' -i $file -o /scratch/asherrar/thesis_files/bamstats/$1/$file_name.html
	java -Xmx12g -jar /home/asherrar/tools/BAMStats-1.25/BAMStats-1.25.jar -s -q -d -l -v 'simple' -i $file -o /scratch/asherrar/thesis_files/bamstats/$1/$file_name.txt
done
