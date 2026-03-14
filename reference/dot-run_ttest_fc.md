# Run a two-sample t-test on fold-change data

Run a two-sample t-test on fold-change data

## Usage

``` r
.run_ttest_fc(
  group_target,
  group_reference,
  chr,
  comparison_type = "chr vs rest"
)
```

## Arguments

- group_target:

  Numeric vector for the target group.

- group_reference:

  Numeric vector for the reference group.

- chr:

  Character string labelling the chromosome being tested.

- comparison_type:

  Character string describing the comparison type.
