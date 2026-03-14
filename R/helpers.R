#' Run a two-sample t-test and return a tidy data frame row
#' @param group_target Numeric vector for the target group.
#' @param group_reference Numeric vector for the reference group.
#' @param condition_name Character string labelling this condition.
#' @param chr Character string labelling the chromosome being tested.
#' @param comparison_type Character string describing the comparison type.
#' @return A one-row data.frame with t-test results.
#' @keywords internal
.run_ttest <- function(group_target, group_reference, condition_name, chr,
                       comparison_type = "chr vs rest") {
  t_result <- stats::t.test(group_target, group_reference)
  data.frame(
    Condition        = condition_name,
    p_value          = t_result$p.value,
    chr_to_evaluate  = chr,
    comparison_type  = comparison_type,
    mean_target      = mean(group_target,    na.rm = TRUE),
    mean_reference   = mean(group_reference, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
}

#' Run a two-sample t-test on fold-change data
#' @inheritParams .run_ttest
#' @keywords internal
.run_ttest_fc <- function(group_target, group_reference, chr,
                          comparison_type = "chr vs rest") {
  .run_ttest(group_target, group_reference,
             condition_name  = chr,
             chr             = chr,
             comparison_type = comparison_type)
}

#' Default C. elegans chromosome order
#' @return Character vector of length 6.
#' @keywords internal
.elegans_chr_order <- function() {
  c("chrI", "chrII", "chrIII", "chrIV", "chrV", "chrX")
}

#' Clean chromosome names for display
#' @param x Character vector of chromosome names.
#' @return Character vector with "chr" replaced by "Chr ".
#' @keywords internal
.clean_chr_name <- function(x) {
  gsub("chr", "Chr ", x)
}

#' Validate that required columns exist in a data frame
#' @param object A data.frame or tibble.
#' @param cols Character vector of required column names.
#' @param arg_names Character vector of argument names for the error message.
#' @keywords internal
.check_cols <- function(object, cols, arg_names = cols) {
  missing_idx <- which(!cols %in% colnames(object))
  if (length(missing_idx) > 0) {
    stop(
      paste0(
        "Column(s) not found in `object`:\n",
        paste0("  - '", cols[missing_idx],
               "' (argument `", arg_names[missing_idx], "`)",
               collapse = "\n")
      ),
      call. = FALSE
    )
  }
}
