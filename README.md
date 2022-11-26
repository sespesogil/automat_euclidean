# automat_euclidian

Utility to calculate Euclidean distances in chrom3D models

# Required dependencies

- R version > v3.3.1
- Samtools > v1.1
- pheatmap
- Bedtools > 2.24.0

# Usage

automat_euclidian.sh 

```./automat_euclidian.sh chrom3D_model ROI```

```chrom3D_model``` = path to the chrom3D file 
```ROI``` = regions of interests bedfile (chrN Start End)

# Updates

New functions to compare models have been incorporated, as well as estimate the likelihood of finding regions of interest conformation versus randomness (both paired and unpaired tests). 
