#' Multiply 2 numbers
#' @description
#'
#' @param x A number or vector of numbers
#' @param y A number or vector of numbers
#' @return The result of multiplying [x] by [y]
#'
#' @return
#' @export
#'
#' @examples
#' mult(2, 2) # 4
#' mult(3, c(2, 2)) # [1] 6, 6
mult <- function(x, y) {
  x * y
}
