#' Write a data frame to an xz-compressed delimited file
#'
#' Streams `write.table()` output through the system `xz` binary with `-T0`
#' (use all available cores). Nothing uncompressed is written to disk.
#'
#' @param x          A data frame.
#' @param file       Output path. ".xz" is appended if absent.
#' @param sep        Field separator. Default "\t".
#' @param quote      Quote character fields. Default FALSE.
#' @param row.names  Write row names. Default FALSE.
#' @param threads    Value passed to xz's -T flag. Default 0 (all cores).
#' @param level      Compression preset 0-9. Default 6.
#' @param overwrite  Allow clobbering an existing file. Default TRUE.
#' @param ...        Passed through to `utils::write.table()`
#'                   (e.g. col.names, na, dec, fileEncoding, qmethod).
#'
#' @return The path written, invisibly.
stb_write_xz <- function(x,
                     file,
                     sep = "\t",
                     quote = FALSE,
                     row.names = FALSE,
                     threads = 0L,
                     level = 6L,
                     overwrite = TRUE,
                     ...) {

  ## --- validate the object -------------------------------------------------
  if (missing(x)) {
    stop("`x` is missing: supply a data frame.", call. = FALSE)
  }
  if (!is.data.frame(x)) {
    stop("`x` must be a data frame, not an object of class ",
         paste(class(x), collapse = "/"), ".", call. = FALSE)
  }
  if (nrow(x) == 0L) {
    warning("`x` has 0 rows; only the header will be written.", call. = FALSE)
  }
  if (missing(file) || !is.character(file) || length(file) != 1L || !nzchar(file)) {
    stop("`file` must be a single non-empty path.", call. = FALSE)
  }

  ## --- validate the environment --------------------------------------------
  xz <- Sys.which("xz")
  if (!nzchar(xz)) {
    stop("`xz` was not found on PATH. Install xz-utils (apt install xz-utils, ",
         "brew install xz) or use gzfile()/xzfile() instead.", call. = FALSE)
  }
  threads <- as.integer(threads)
  level   <- as.integer(level)
  if (is.na(threads) || threads < 0L) stop("`threads` must be a non-negative integer.", call. = FALSE)
  if (is.na(level) || level < 0L || level > 9L) stop("`level` must be 0-9.", call. = FALSE)

  ## --- resolve the target --------------------------------------------------
  if (!grepl("\\.xz$", file, ignore.case = TRUE)) file <- paste0(file, ".xz")
  if (file.exists(file) && !overwrite) {
    stop("File already exists and `overwrite = FALSE`: ", file, call. = FALSE)
  }
  outdir <- dirname(file)
  if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)
  file <- file.path(normalizePath(outdir, mustWork = TRUE), basename(file))

  ## --- stream through xz ---------------------------------------------------
  cmd <- sprintf("%s -T%d -%d -c > %s",
                 shQuote(xz), threads, level, shQuote(file))

  con <- pipe(cmd, open = "wb")
  res <- try(
    utils::write.table(x,
                       file      = con,
                       sep       = sep,
                       quote     = quote,
                       row.names = row.names,
                       ...),
    silent = TRUE
  )
  close(con)

  if (inherits(res, "try-error")) {
    unlink(file)
    stop("write.table() failed: ", conditionMessage(attr(res, "condition")),
         call. = FALSE)
  }
  if (!file.exists(file) || file.size(file) == 0L) {
    unlink(file)
    stop("xz produced no output; check that `xz` runs correctly on this system.",
         call. = FALSE)
  }

  invisible(file)
}