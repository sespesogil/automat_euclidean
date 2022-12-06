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

New functions to compare 3D models have been incorporated. It is also now included the possibility to run a permutation analysis based in regions of interest (ROI), to determine the likelihood (probability) of finding that particular associated-ROI euclidean conformation versus randomness (both paired and unpaired tests). 



