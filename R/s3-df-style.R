
new_idx_df <- function(df, idx, value="value") {
  stopifnote(is.data.frame(df))
  stopifnot(is.character(idx)) #idx must be in names(df)
  #idx can be named or not
  stopifnot(is.character(value)) #value must be in names(df)

  structure(
    df,
    idx = idx,
    value = value,
    class = c("idx_df", "data.frame")
  )
}

