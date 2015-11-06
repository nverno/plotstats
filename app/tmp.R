setDT(dat)[, ind:= .SD[[index[1L]]], .I]

setDT(dat)[, .SD[[index[1L]]], .I]$V1

dat[, ind := .SD[[.BY[[1]]]], by=index]


library(data.table)  # version 1.9.7
set.seed(1999)
dat <- data.frame(matrix(sample(letters, 30, TRUE), nrow=10))
dat$index <- sample(1:3, 10, TRUE)
dat <- setNames(dat, c(letters[1:3], "index"))

## Using data.frame with matrix index
with(dat, dat[cbind(1:nrow(dat), index)])
# [1] "m" "v" "h" "f" "c" "h" "l" "s" "w" "y"

setDT(dat)
dat[, ind:= .SD[[index[1L]]], .I]
dat[, ind2 := .SD[[index]], by = seq(nrow(dat))]
dat[, ind3 := .SD[[.BY[[1]]]], by=index]

library(data.table)  # version 1.9.7
set.seed(1999)
dat <- data.frame(matrix(sample(letters, 30, TRUE), nrow=10),
                  stringsAsFactors = FALSE)
dat$index <- sample(1:3, 10, TRUE)
dat <- setNames(dat, c(letters[1:3], "index"))

with(dat, dat[cbind(1:nrow(dat), index)])

setDT(dat)[, ind4 := .SD[[.BY[[1]]]], by=index]

setDT(dat)[, ind:= .SD[[index[1L]]], .I]
