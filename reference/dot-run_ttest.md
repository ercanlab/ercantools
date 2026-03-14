# Run a two-sample t-test and return a tidy data frame row

Run a two-sample t-test and return a tidy data frame row

## Usage

``` r
.run_ttest(
  group_target,
  group_reference,
  condition_name,
  chr,
  comparison_type = "chr vs rest"
)
```

## Arguments

- group_target:

  Numeric vector for the target group.

- group_reference:

  Numeric vector for the reference group.

- condition_name:

  Character string labelling this condition.

- chr:

  Character string labelling the chromosome being tested.

- comparison_type:

  Character string describing the comparison type.

## Value

A one-row data.frame with t-test results.
