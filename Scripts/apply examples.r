#
# 'apply' applies a function over a dimension of a
#    matrix, array, or data.frame

my.mat <- matrix(1:6, 2, 3)

# if the result of the function is a one elmement vector, then
#   the result of 'apply' is a vector:
apply(my.mat, 1, median)


# if the result of the function is a vector, then
#   the result of 'apply' is an array:
apply(my.mat, 2, function(x) sample(x, 10, rep = T))


# if the result of each call to the function is not
#   the same length, then
#   the result of 'apply' is a list:
char.mat <- matrix(sample(letters[1:8], 40, rep = T), nrow = 10)
apply(char.mat, 1, unique)
