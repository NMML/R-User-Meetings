# A function is declared with the keyword 'function'
# Arguments go in parentheses
# Expression for function follows argument
f2c <- function(faren) return((faren - 32) * 5 / 9)

# If the function has more than one line, separate
# lines must be grouped with curly braces: '{}'
f2c.text <- function(faren) {
  cels <- f2c(faren)
  text <- paste(faren, "deg. Farenheit = ", cels, "deg. Celsius")
  output <- list(faren = faren, cels = cels, text = text)
  return(output)
}

# The return value of the last statement is the return
# value of the function, so 'return'
# is rarely necessary
# See ?return and ?invisible for more info
f2c.text <- function(faren) {
  cels <- f2c(faren)
  text <- paste(faren, "deg. Farenheit = ", cels, "deg. Celsius")
  list(faren = faren, cels = cels, text = text)
}

# Arguments can have default values set with '='
f2c.default <- function(faren, digits = 2) {
  cels <- f2c(faren)
  cels <- round(cels, digits)
  text <- paste(faren, "deg. Farenheit = ", cels, "deg. Celsius")
  list(faren = faren, cels = cels, text = text)
}

# Arguments are matched according to this order:
#   1) Full name
#   2) Partial name
#   3) Position
# 'if' and 'else' control flow based on condition
f2c.details <- function(degrees, digits = 2, details = F) {
  cels <- f2c(degrees)
  cels <- round(cels, digits)
  if(details) {
    text <- paste(degrees, "deg. Farenheit = ", cels, "deg. Celsius")
    return(list(faren = degrees, cels = cels, text = text))
  }
  cels
}

# Unmatched arguments can be sent to other functions
# with '...'
f2c.ellipsis <- function(degrees, digits = 2, ...) {
  cels <- f2c(degrees)
  cels <- round(cels, digits)
  paste(degrees, cels, ...)
}

# 'if' only operates on a single T/F condition
# to "vectorize" an if statement, use 'ifelse'
f2c.if <- function(degrees, trunc.deg = rep(T, length(degrees))) {
  if(length(trunc.deg) != length(degrees)) {
    stop("'trunc.deg' must be same length as 'degrees'")
  }
  cels <- f2c(degrees)
  ifelse(trunc.deg, trunc(cels), cels)
}

# 'for' iterates through the elements of an object
x <- sample(1:100, 20, T)

# iterating using an index
for(i in 1:length(x)) {
  msg <- paste(i, "=", x[i])
  print(msg)
}

# iterating elements in the vector directly
for(i in x) {
  msg <- paste("i =", i)
  print(msg)
}

# iterating elements in a list directly
mat.list <- lapply(1:5, function(i) {
  nums <- sample(1:1000, 12, T)
  matrix(nums, 4)
})

for(m in mat.list) {
  print(str(m))
}

# 'switch' diverts control based on one of several values
conv.miles <- function(miles, units = "feet") {
  #if(!units %in% c("inches", "feet", "cm", "m", "km")) {
  #  stop("'units' not recognized")
  #}
  switch(units,
    inches = miles * 63360,
    feet = miles * 5280,
    cm = miles * 160934.4,
    m = miles * 1609.344,
    km = miles * 1.609344,
    "unknown unit"
  )
}

# Other control functions/commands are:
#   while
#   repeat
#   break
#   next
#   warning
# See ?Control for details
