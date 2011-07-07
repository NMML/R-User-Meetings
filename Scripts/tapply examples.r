# tapply: Applies a function over a vector
#   using another vector to group.
#   The return value can be a list (if 'simplify = FALSE')
#     or an array (if 'simplify = TRUE')

n <- 100
grp1 <- sample(c("a", "b"), n, rep = T)
grp2 <- sample(c("c", "d"), n, rep = T)
length <- rnorm(n, 100, 4)
weight <- rnorm(n, 3, 1)

tapply(length, grp1, mean)
tapply(length, list(grp1, grp2), mean)
tapply(length, grp1, range)
arr.list <- tapply(length, list(grp1, grp2), range)
arr.list["a", "c"]



# by: Applies a function over subsets of a data.frame
#    The return value is a list of class 'by'

test.df <- data.frame(grp1 = grp1, grp2 = grp2, length = length, weight = weight)

by.1grp <- by(test.df, grp1, nrow)
by.1grp["a"]

by.2grp <- by(test.df, list(grp1, grp2), nrow)
by.2grp["a", "d"]



# aggregate: Applies function over columns of a data.frame
#    The return value is simplified to an array if possible

agg.1grp <- aggregate(test.df[, c("length", "weight")], list(grp1 = grp1), function(x) {
  c(mean = mean(x), median = median(x))
})

agg.2grp <- aggregate(test.df[, c("length", "weight")], list(grp1 = grp1, grp2 = grp2), function(x) {
  c(mean = mean(x), median = median(x))
})

agg.form.1grp <- aggregate(length ~ grp1, test.df, var)
agg.form.2grp <- aggregate(length ~ grp1 + grp2, test.df, var)
agg.form.2grp.lw <- aggregate(cbind(length, weight) ~ grp1 + grp2, test.df, var)





