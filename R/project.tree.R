#' Print a directory tree with optional exclusions
#'
#' Recursively prints the folder structure of a project (typically the
#' package root), using an ASCII tree layout. Specific folders can be
#' excluded from the output.
#'
#' @param path Character string. Root directory to print. Defaults to `"."`.
#' @param indent Internal parameter used for recursive indentation.
#'   Users normally do not modify this.
#' @param exclude Character vector of folder or file names to exclude
#'   (matched against `basename()`). Defaults to `"dev"`.
#'
#' @return Invisibly returns `NULL`. Called for its side effect of printing
#'   the directory tree.
#'
#' @examples
#' # Print the project tree, excluding the dev/ folder
#' project.tree(".", exclude = "dev")
#'
#' # Exclude multiple folders
#' project.tree(".", exclude = c("dev", ".git", ".Rproj.user"))
#'
#' @export
project.tree <- function(path = ".", indent = "", exclude = c("dev")) {
  items <- list.files(path, full.names = TRUE)
  items <- items[!basename(items) %in% exclude]
  
  for (i in seq_along(items)) {
    item <- items[i]
    is_last <- i == length(items)
    branch <- if (is_last) "\\-" else "|--"
    cat(indent, branch, basename(item), "\n", sep = "")
    if (dir.exists(item)) {
      new_indent <- if (is_last) paste0(indent, "    ") else paste0(indent, "|  ")
      project.tree(item, new_indent, exclude = exclude)
    }
  }
}
