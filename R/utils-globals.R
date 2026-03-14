#' @importFrom dplyr group_by summarise n bind_rows filter mutate count
#' @importFrom tibble tibble
#' @importFrom stats t.test median setNames
#' @importFrom ggplot2 ggplot aes geom_violin geom_boxplot scale_fill_manual
#'   labs theme_bw coord_cartesian theme geom_hline geom_text annotate
#'   element_text stat_summary scale_x_discrete
#' @importFrom ggpubr stat_compare_means
#' @importFrom magrittr %>%
NULL

utils::globalVariables(c(
  "Chromosome", "log2FC", "Condition", "Conc", "label", "n"
))
