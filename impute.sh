#!/bin/bash
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=12000
#SBATCH --job-name=imputemm3
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --array=1,2,4,6,8,9,11,12,15,16,17,19
#SBATCH -p sysgen
#SBATCH --mail-type=END  
#SBATCH --mail-user=l5@student.unimelb.edu.au


module load zlib/1.2.8-GCC-4.9.3
module load glibc/2.15-GCC-4.9.3

if [ -n "${1}" ]; then
    SLURM_ARRAY_TASK_ID=${1}
fi

chr=${SLURM_ARRAY_TASK_ID}

wd=`pwd`"/"
source parameters.sh
threads=16

#echo "Imputing on $threads threads"

#impute
${mm3omp} --refHaps $refvcf \
          --haps $targetvcf \
          --prefix $imputedvcf \
          --cpus $threads

#convert to plink format
plink --vcf ${imputedvcf}.dose.vcf.gz --double-id --make-bed --out $imputedplink --threads $threads
#quality control 
plink --bfile ${imputedplink} --hwe ${filterHWE} --maf ${filterMAF} --make-bed --out ${imputedplinkqc} \
--threads $threads