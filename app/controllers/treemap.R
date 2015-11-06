df <- read.table(text="   income expense education gender residence
1   153      2989 NoCollege      F       Own
2   289       872   College      F      Rent
3   551        98 NoCollege      M      Rent
4   286       320   College      M      Rent
5   259       372 NoCollege      M      Rent
6   631       221 NoCollege      M       Own
7   729       105   College      M      Rent
8   582       450 NoCollege      M       Own
9   570       253   College      F      Rent
10 1380       635 NoCollege      F      Rent
11  409       425 NoCollege      M      Rent
12  569       232 NoCollege      F       Own
13  317       856   College      M      Rent
14  199       283   College      F       Own
15  624       564 NoCollege      M       Own
16 1064       504 NoCollege      M       Own
17  821       169 NoCollege      F      Rent
18  402       175   College      M       Own
19  602       285   College      M      Rent
20  433       264   College      M      Rent
21  670       985 NoCollege      F       Own", header=TRUE)

library(treemap)
library(data.table)

## Some dummy variables to aggregate by: ALL, i, and index
dat <- as.data.table(df)[, `:=`(total = factor("ALL"), i = 1, index = 1:.N)][]
indexList <- c('total', 'gender', 'education', 'residence')  # order or aggregation

## Function to aggregate at each grouping level (SIR)
agg <- function(index, ...) {
    dots <- list(...)
    expense <- dots[["expense"]][index]
    income <- dots[["income"]][index]
    sum(expense) / sum(income) * 100
}

## Get treemap data
res <- treemap(dat, index=indexList, vSize='i', vColor='index',
               type="value", fun.aggregate = "agg",
               income=dat[["income"]], expense=dat[["expense"]])  # ... args get passed to fun.aggregate

## Now use ggplot to make the bargraph
## The useful variables: level (corresponds to indexList), vSize (bar size), vColor(SIR)
## Create a label variable that is the value of the variable in indexList at each level
out <- res$tm
out$label <- out[cbind(1:nrow(out), out$level)]
out <- out[,c("vSize", "vColor", "level", "color", "label")]  # just keep good stuff
out <- with(out, out[order(level, label),])

## Time to find label positions: function to find x-positions for each level
## y will just be the level
out$xlab <- unlist(lapply(split(out$vSize, out$level), function(x) cumsum(x) - x/2))

## Plot
ggplot(out, aes(x=level, y=vSize, fill=interaction(level, label))) +
  geom_bar(stat='identity', position='fill')


setkey(out, level)


library(ggplot2)

X = data.table(x=c(1,1,1,2,2,5,6), y=1:7, key="x")
Y = data.table(x=c(2,6), z=letters[2:1], key="x")
