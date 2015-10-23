### utils.R --- 
## Filename: utils.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 20 13:17:29 2015 (-0400)
## Last-Updated: Thu Oct 22 22:45:44 2015 (-0400)
##           By: Noah Peart
######################################################################

## Return a list of partials/controllers from subdirectories
findParts <- function(ids=c("partials", "controllers")) {
    dirs <- list.dirs(recursive=TRUE)
    inds <- setNames(lapply(ids, function(id) basename(dirs) == id), ids)
    lapply(inds, function(ind)
        sub("^\\.+[/\\]+", "",
            list.files(dirs[ind], full.names=TRUE, no..=TRUE)))
}

## Find data
findData <- function(locs, files) {
    found <- c()
    for (loc in locs) {
        if (any((present <- file.exists(file.path(loc, files))))) {
            found <- c(found, file.path(loc, files[present]))
            files <- files[!present]
        }
        if (length(files) == 0)
            break
    }
    return( list(found=found, missed=files) )
}

## grep indices ordered by year
grepInOrder <- function(coln, yrs, dat) {
    unlist(sapply(paste0(coln, yrs), function(x) grep(x, names(dat))))
}

## Polar to cartesian
## deg: if input theta is in degrees
pol2cart <- function(r, theta, deg = FALSE, recycle = FALSE) {
    if (deg) theta <- theta * pi/180
    if (length(r) > 1 && length(r) != length(theta) && !recycle)
        stop("'r' vector different length than theta, if recycling 'r' values is desired 'recycle' must be TRUE")
    xx <- r * cos(theta)
    yy <- r * sin(theta)
    ## Account for machine error in trig functions
    xx[abs(xx) < 2e-15] <- 0
    yy[abs(yy) < 2e-15] <- 0
    out <- cbind(xx, yy)
    colnames(out) <- c("x", "y")
    return( out )
}

"%||%" <- function(a, b) if (!is.null(a)) a else b

## Create empty data.frame with all possible names
blankDF <- function(...) {
    ns <- Reduce(union, lapply(list(...), names))
    dat <- setNames(as.list(integer(length(ns))), ns)
    as.data.frame(dat)[0,]
}
