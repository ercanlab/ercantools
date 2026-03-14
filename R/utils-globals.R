#' @importFrom dplyr group_by summarise n bind_rows filter mutate count
#' @importFrom tibble tibble
#' @importFrom tidyr pivot_longer pivot_wider
#' @importFrom rlang :=
#' @importFrom stats t.test median setNames
#' @importFrom ggplot2 ggplot aes geom_violin geom_boxplot scale_fill_manual
#'   labs theme_bw coord_cartesian theme geom_hline geom_text annotate
#'   element_text stat_summary scale_x_discrete facet_wrap facet_grid
#'   scale_color_manual geom_point geom_line geom_density geom_histogram
#'   geom_rug scale_shape_manual guide_legend geom_col
#' @importFrom ggpubr stat_compare_means
#' @importFrom ggrepel geom_label_repel
#' @importFrom magrittr %>%
NULL

utils::globalVariables(c(
  # violin_log2FC / violin_counts
  "Chromosome", "log2FC", "Condition", "Conc", "label", "n",
  # violin_all_chr functions
  "Chromosome_clean", "Chromosome_label", "Treatment", "Group",
  # correlation functions
  "chr_to_evaluate", "p_value", "comparison", "comparison_type",
  "neg_log10_pvalue", "is_significant", "mean_target", "mean_reference",
  # distributions
  "Condition_raw", "seqnames", "Conc_plot",
  # MD / Volcano plot
  "colors", "shapes", "FDR","sig_color",
  # dplyr
  ".data"
))
