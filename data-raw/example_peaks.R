## Code to generate the example dataset `example_peaks`
## Run with: source("data-raw/example_peaks.R")

set.seed(174)

n_peaks <- 2000

# Approximate proportions of peaks per chromosome in C. elegans
chr_sizes <- c(chrI   = 0.18, chrII  = 0.18, chrIII = 0.15,
               chrIV  = 0.18, chrV   = 0.20, chrX   = 0.11)

seqnames_vec <- sample(names(chr_sizes), size = n_peaks,
                       replace = TRUE, prob = chr_sizes)

# Chromosome lengths in bp
chr_lengths_bp <- c(chrI   = 15e6, chrII  = 15e6, chrIII = 14e6,
                    chrIV  = 17e6, chrV   = 21e6, chrX   = 18e6)

start_vec <- sapply(seqnames_vec, function(chr)
  sample(1:(chr_lengths_bp[chr] - 501), 1))
end_vec   <- start_vec + 500  # width always 501

# Simulate dosage compensation effect on chrX:
# peaks on chrX have higher Fold and lower Conc_notag
is_chrX <- seqnames_vec == "chrX"

conc_notag  <- rnorm(n_peaks, mean = 8, sd = 1.2)
conc_degron <- conc_notag + ifelse(
  is_chrX,
  rnorm(n_peaks, mean =  1.0, sd = 0.4),  # chrX increases in degron
  rnorm(n_peaks, mean =  0.1, sd = 0.3)   # autosomes no change
)

fold_vec <- conc_degron - conc_notag + rnorm(n_peaks, 0, 0.1)
conc_vec <- (conc_notag + conc_degron) / 2

# p-values and FDR
pvals    <- runif(n_peaks)
pvals[is_chrX] <- pvals[is_chrX] * 0.05  # chrX more significant
fdr_vec  <- p.adjust(pvals, method = "BH")

example_peaks <- data.frame(
  seqnames    = seqnames_vec,
  start       = as.integer(start_vec),
  end         = as.integer(end_vec),
  width       = 501L,
  strand      = "*",
  Conc        = round(conc_vec,    4),
  Conc_degron = round(conc_degron, 4),
  Conc_notag  = round(conc_notag,  4),
  Fold        = round(fold_vec,    4),
  p.value     = signif(pvals,      4),
  FDR         = signif(fdr_vec,    4),
  stringsAsFactors = FALSE
)

usethis::use_data(example_peaks, overwrite = TRUE)

message(sprintf("example_peaks created: %d peaks", nrow(example_peaks)))
print(table(example_peaks$seqnames))
