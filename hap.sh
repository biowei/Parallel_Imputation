#!/bin/bash
#SBATCH --time=03:00:00
#SBATCH --mem-per-cpu=1000
#SBATCH --job-name=job_reports/phase
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --array=1,2,4,6,8,9,11,12,15,16,17,19
#SBATCH -p sysgen
#SBATCH --mail-type=END  
#SBATCH --mail-user=l5@student.unimelb.edu.au

# This script will take a reference-aligned binary plink file and:
# 1. For each chromosome perform shapeit phasing
# 2. Remove snps that don't align between reference and main panel
# 3. Convert to vcf format

# set -e
if [ -n "${1}" ]; then
    SLURM_ARRAY_TASK_ID=${1}
fi

chr=${SLURM_ARRAY_TASK_ID}
wd=$(pwd)"/"
echo $wd
source $wd/parameters.sh
threads=16

flags="--thread $threads --noped"

#if [ "${chr}" -eq "23" ]; then
#    flags="$flags --chrX"
#fi

#if [[ -f ${targetdata}"-align.bim" ]];
#then
#    targetdata="${targetdata}-align"
#    echo "Found aligned set"
#fi

#indv=$(wc -l ${targetdata}.fam | cut -f 1 -d ' ')
#echo "There are $indv individuals"

echo $SLURM_ARRAY_TASK_ID

bed="../temp/psa-norepeat"
plink --bfile $bed --chr $chr --make-bed --out 'data/target/DAT'${chr}
targetdata="data/target/DAT${chr}"

## If less than 100 indivduals, use reference panel to phase
minindiv=100
if [ $indv -lt $minindiv ]; then
    flags="$flags --input-ref ${refhaps} ${reflegend} ${refsample}"
    echo "Using reference set to phase data"
fi

## Performing phasing 
${shapeit2} --input-bed ${targetdata}.bed ${targetdata}.bim ${targetdata}.fam \
            --input-map ${refgmap} \
            --output-max ${hapout}.haps ${hapout}.sample ${flags} \
            --output-log ${wd}job_reports/shapeit.$chr

## Convert data to vcf for minimac3
${shapeit2} -convert \
            --input-haps ${hapout} \
            --output-vcf ${targetvcf} \
            --output-log ${wd}job_reports/shapeit.$chr \
            --thread $threads