# Parallel_Imputation of large scale SNP data

LiftOver
Phasing
GenotypeHarmonizer
Imputation

Step 1, LiftOver

During this step, the genomic assembly of the data is converted from one genomebuild to another. At this moment, there are two LiftOver options:

hg18 -> hg19
hg38 -> hg19
Tools used by the LiftOver step:

LiftOver, version 20161011
PLINK, version 1.9

Step 2, Phasing

During this step, the haplotype structure of the data is determined.

Tools used by the Phasing step:

SHAPEIT, v2.r837-static

Step 3, ShapeIT

During this step, quality control is performed and the data is aligned to the reference data.

Tools used:

ShapeIT

Step 4, Imputation

During this step, the data is split into many chunks, in order to impute the data properly.

Tools used by the Imputation step:

MiniMac3 
