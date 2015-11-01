### pp_clean.R --- 
## Filename: pp_clean.R
## Description: reead/clean permanent plot data
## Author: Noah Peart
## Created: Sat Oct 31 16:28:11 2015 (-0400)
## Last-Updated: Sat Oct 31 16:55:57 2015 (-0400)
##           By: Noah Peart
######################################################################
## Find data: 
locs <- findData(dataloc, datafiles)

## Data with estimated heights/boles
tryCatch({
    pp <- read.csv(grep("pp.csv", locs$found, value = TRUE))
    pploc <- read.csv(grep("PP_DEMSLOPE.csv", locs$found, value = TRUE))
}, error=function(e)
    stop("\n\n*** Failed to read data permanent plot data.***\n\n"))

################################################################################
##
##                              Permanent Plots
##
################################################################################
## tidy, wide -> long
yrs <- c(86, 87, 98, 10)
cols <- grep("^STAT|^DBH|^ht[0-9]+|HTTCR|bv|PPLOT|SPLOT$|^DECM|TAG$|SPEC|ASP|ELEV|BQUDX|BQUDY|CLASS$|^canht|^CPOS|YRMORT|SOILCL",
             names(pp))
dat <- pp[pp$PPLOT > 3, cols]
cols <- grep("[A-Za-z]+$|.*86$|.*87$|.*98$|.*10$", names(dat))
dat <- dat[, cols]  # remove other year columns
dat[,paste0("BA",yrs)] <- 0.00007854 * dat[,paste0("DBH", yrs)]**2

## Growth columns
vars <- c("DBH", "ht", "bv", "canht", "HTTCR", "BA")
for (v in vars) {
    dat[,paste0("g_", v, 86)] <- (dat[,paste0(v, 98)] - dat[,paste0(v, 86)])/12
    dat[,paste0("g_", v, 87)] <- (dat[,paste0(v, 98)] - dat[,paste0(v, 87)])/11
    dat[,paste0("g_", v, 98)] <- (dat[,paste0(v, 10)] - dat[,paste0(v, 98)])/12
}

## Prior growth columns
for (v in vars) {
    dat[,paste0("pg_", v, 98)] <- (dat[,paste0(v, 98)] - dat[,paste0(v, 86)])/12
    inds <- !is.na(dat[,paste0(v, 87)]) & !is.na(dat[,paste0(v, 98)])
    dat[inds, paste0("pg_", v, 98)] <- (dat[inds, paste0(v, 98)] - dat[inds, paste0(v, 87)])/11
    dat[,paste0("pg_", v, 10)] <- (dat[,paste0(v, 10)] - dat[,paste0(v, 98)])/12
}

## Trees that died/aren't in next census period
dat[,"DIED86"] <- ifelse(dat[,"STAT86"] == "ALIVE" & dat[,"STAT98"] != "ALIVE", 1, 0)
dat[,"DIED87"] <- ifelse(dat[,"STAT87"] == "ALIVE" & dat[,"STAT98"] != "ALIVE", 1, 0)
dat[,"DIED98"] <- ifelse(dat[,"STAT98"] == "ALIVE" & dat[,"STAT10"] != "ALIVE", 1, 0)
dat[,"DIED10"] <- NA

## Trees that were actually reported dead
died <- c("DEAD", "PD")  # identifies for dead
dat[,"rDIED86"] <- ifelse(dat[,"STAT86"] == "ALIVE" & dat[,"STAT98"] %in% died, 1, 0)
dat[,"rDIED87"] <- ifelse(dat[,"STAT87"] == "ALIVE" & dat[,"STAT98"] %in% died, 1, 0)
dat[,"rDIED98"] <- ifelse(dat[,"STAT98"] == "ALIVE" & dat[,"STAT10"] %in% died, 1, 0)
dat[,"rDIED10"] <- NA

dat[,paste0("g_", vars, 10)] <- NA
dat[,paste0("pg_", vars, 86)] <- NA
dat[,paste0("pg_", vars, 87)] <- NA
dat$CPOS86 <- NA  # no crown positions measured in 86
dat <- reshape(dat, times = yrs, direction = "long",
               varying = list(
                   BA = grepInOrder("^BA", yrs, dat),
                   gBA = grepInOrder("^g_BA", yrs, dat),
                   STAT = grepInOrder("^STAT", yrs, dat),
                   DBH = grepInOrder("^DBH", yrs, dat),
                   gDBH = grepInOrder("^g_DBH", yrs, dat),
                   HT = grepInOrder("^ht", yrs, dat),
                   gHT= grepInOrder("^g_ht", yrs, dat),
                   BV = grepInOrder("^bv", yrs, dat),
                   gBV = grepInOrder("^g_bv", yrs, dat),
                   HTOBS = grepInOrder("^HTTCR", yrs, dat),
                   gHTOBS = grepInOrder("^g_HTTCR", yrs, dat),
                   CANHT = grepInOrder("^canht", yrs, dat),
                   gCANHT = grepInOrder("^g_canht", yrs, dat),
                   DECM = grepInOrder("DECM", yrs, dat),
                   CPOS = grepInOrder("^CPOS", yrs, dat),
                   DIED = grepInOrder("^DIED", yrs, dat),
                   pgBA = grepInOrder("^pg_BA", yrs, dat),
                   pgDBH = grepInOrder("^pg_DBH", yrs, dat),
                   pgBV = grepInOrder("^pg_bv", yrs, dat),
                   pgHTOBS = grepInOrder("^pg_HTTCR", yrs, dat),
                   pgHT = grepInOrder("^pg_ht", yrs, dat),
                   pgCANHT = grepInOrder("^pg_canht", yrs, dat),
                   rDIED = grepInOrder("^rDIED", yrs, dat)
               ),
               v.names = c("BA", "gBA", "STAT", "DBH", "gDBH", "HT", "gHT", "BV", "gBV",
                   "HTOBS", "gHTOBS", "CANHT", "gCANHT", "DECM", "CPOS", "DIED",
                           "pgBA", "pgDBH", "pgBV", "pgHTOBS", "pgHT", "pgCANHT",
                           "rDIED"),
               timevar = "YEAR")

## Reorder/drop levels
dat$YEAR <- factor(dat$YEAR, levels=c(86, 87, 98, 10))
dat$ELEVCL <- factor(dat$ELEVCL, levels=levels(dat$ELEVCL)[c(3,4,2,1)])
pp <- dat[!is.na(dat$DBH) | !is.na(dat$HT), ]

## Drop/combine factor levels
pp$ELEVCL <- droplevels(pp$ELEVCL)  # remove level ""
pp$allSPEC <- pp$SPEC  # SPEC with all levels
levels(pp$SPEC)[levels(pp$SPEC) %in% c('', 'UNCO', 'UNDE', 'UNID')] <- 'UNID'
levels(pp$SPEC)[grep('^BE', levels(pp$SPEC))] <- 'BESPP'
pp$SPEC <- droplevels(factor(pp$SPEC, levels=sort(levels(pp$SPEC))))

pp$STAT <- droplevels(pp$STAT)
levels(pp$STAT) <- c("UNID", "ALIVE", "DEAD")
pp$ASPCL <- droplevels(pp$ASPCL)
pp$SOILCL <- droplevels(pp$SOILCL)

## Add location data
pp <- left_join(pp, pploc, by='PPLOT')
names(pp)[names(pp) %in% c("LAT", "LONG")] <- c("lat", "lng")

## Factor plots
pp$PPLOT <- factor(pp$PPLOT)

saveRDS(pp, file.path(temploc, "pp.rds"))
