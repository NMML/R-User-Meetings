# lapply: Applies a function over a vector
#   The return value is (always) a list where every element 
#   is the return value of the function applied to each
#   element in the vector

# sapply: Applies a function over a vector
#   The return value is a vector if the return value
#   of every function call is a scalar (one element vector),
#   a matrix if the return value of every function call is the same size
#   and greater than one element, or a list if the return value of
#   every function call is different.


# lapply 'sample' function to vector 1:5 and compile results
#   into a list. This is equivalent to:
#     list(sample(1), sample(2), sample(3), sample(4), sample(5))

lapply(1:5, sample)

# 'sapply' with the same arguments creates the same as above because each
#   call to 'sample' returns an object of a different length

sapply(1:5, sample) 



# this 'sapply' call creates a vector because every call to 'my.factorial' 
#   returns a one element vector:

my.factorial <- function(x) prod(1:x)
sapply(1:5, my.factorial)



# put function in-line with sapply and return a two element vector
#   'sapply' returns a 2x5 matrix

sapply(1:5, function(x) {
  c(x = x, x.factorial = my.factorial(x))
})



# create an example list and 'sapply' a
#   function over it to summarize the elements

ex.list <- lapply(1:10, sample, rep = T)
my.summary <- function(x) {
  x.median <- median(x)
  x.mean <- mean(x)
  x.var <- var(x)
  c(median = x.median, mean = x.mean, var = x.var)
}
sapply(ex.list, my.summary)



# summarize some data.frames in a list
#   use an in-line function this time

n <- 10
ex.list <- lapply(1:10, function(i) {
  grp <- sample(c("a", "b"), n, rep = T)
  length <- rnorm(n, 100, 4)
  weight <- rnorm(n, 3, 1)
  data.frame(grp = grp, length = length, weight = weight)
})
sapply(ex.list, function(x) {
  wt.len <- x$weight / x$length
  median(wt.len)
})


test.df <- ex.list[[1]]

# summarize columns in a data.frame
sapply(test.df[, -1], my.summary)



# bootstrap median weight/length ratio
med.wt.ln <- function(df) median(df$weight / df$length)
boot.dist <- sapply(1:1000, function(x) {
  boot.rows <- sample(1:nrow(test.df), rep = T)
  med.wt.ln(test.df[boot.rows, ])
})
quantile(boot.dist, p = c(0.025, 0.5, 0.975))
hist(boot.dist)
abline(v = med.wt.ln(test.df), col = "red", lwd = 2)




