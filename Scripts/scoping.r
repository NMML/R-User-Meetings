##################################################################
# Lexical Scoping
##################################################################
# R uses lexical scoping which means that the variables 
# available to a function depend on where the function was
# defined (its environment) and not from where it was called.  
# 
# Below we create a variable x and 2 functions f and g in the 
# global environment. g is called from within f after before f
# completes.
x <- 0
f <- function() 
{
	cat("\n in function f")
	cat("\nx in environment   = ",x,"\n")
	x <- x + 1
	cat("\nx in function      = ",x,"\n")
    g()
	invisible()
}
g <- function() 
{
	cat("\n in function g")
	cat("\nx in environment   = ",x,"\n")
	x <- x + 1
	cat("\nx in function      = ",x,"\n")
	invisible()
}
# We can look at the environment of f and g to see that is the
# global environment because that is where they were both defined.
environment(f)
environment(g)
# Now we'll run f to see the results
f()
# You might have expected that when g was run from f that the value x
# of x might be 1 in the first print statement and 2 in the second.
# However, g gets it copy of x from the global environment and
# not the value of x in f that was changed prior to g being called.
# Thus, f and g produce the same results because the value of x that
# they get is the same value because f and g were defined in the same
# environment.
as.list(environment(f))$x
as.list(environment(g))$x
# Note also that the change to x in both functions does not change the
# value of x in the global environment because the function is using
# a copy of x from the environment inside the function.
x
# It is possible to modify variables in the environment using a 
# different assignment operator.  Instead of using <- you can use
# <<- to modify the variable in the environment of the function rather
# than the function copy. Below is the same 2 functions but now
# I've replaced <- with <<- for the assignment to x.
x <- 0
f <- function() 
{
	cat("\n in function f")
	cat("\nx in environment   = ",x,"\n")
	x <<- x + 1
	cat("\nx in function      = ",x,"\n")
	g()
	invisible()
}
g <- function() 
{
	cat("\n in function g")
	cat("\nx in environment   = ",x,"\n")
	x <<- x + 1
	cat("\nx in function      = ",x,"\n")
	invisible()
}
# Now we'll run f to see the results
f()
# Now you get what you might have expected in the first case, but
# it is only because the value of x in the global environment was 
# modified using the <<- assignment operator.  It is not a good idea
# to write code that depends on values in the global environment or 
# creates and modifies variables in the global environment because
# it may affect something else that the user is doing in the global
# environment. This can be avoided by creating an environment (not the
# global environment) for the function and modifying the objects within that
# environment.  Because the environment remains with the function, this
# allows objects to be modified and retain their values across calls to
# the function.  An obvious example where this is useful is an iteration
# counter for an optimization problem to keep track of the number of 
# times the function is called. The easiest way to create an environment 
# for a function is to define the function in another wrapper function which 
# defines the objects in the environment and then returns the function (and its
# environment) as its result. This is called a closure. Closures are 
# most useful for functions that have functions as arguments.  For example,
# the first argument of the function integrate is the function to be integrated.
# The following modifies the previous example to use a closure to be
# able to maintain the value of x across function calls without modifying
# the value of x in the global environment.
x <- 0
f <- function() 
{
	x <- 0
	g <- function() 
	{
		cat("\n in function g")
		cat("\nx in g environment  = ",x,"\n")
		x <<- x + 1
		cat("\nx in function      = ",x,"\n")
		invisible()
	}
	return(g)
}
# Now we'll run f to create the closure and store it in g
g=f()
# The environment of g is given an identifier that will change.
environment(g)
g=f()
environment(g)
# Now run g several times and examine x in its environment and
# x in the global environment.
# x in the environment of g is 0
as.list(environment(g))$x
# x in the global environment is 0
x
# invoke g
g()
# x in the environment is now 1
as.list(environment(g))$x
# x in the global environment is still 0
x
# invoke g again
g()
# x in the environment is now 2
as.list(environment(g))$x
# x in the global environment is still 0
x
# If you redefine g it will get a new copy of its environemnt.
g=f()
# x in the environment is now 0 again
as.list(environment(g))$x
# Environments are nested - that is every environment has a parent.
# We can examine the parent environment of an environment with the
# function parent.env. Below is the parent environment of g's environment.
parent.env(environment(g))
# All environments will have the global environment
# as an ancestor. Unless you want to get clever with environments, what matters
# is that the contents of any object in a parent environment is available to the 
# any child environment.  This can be useful but can also have unintended 
# consequences. 
# It can be useful when functions define other functions to be used inside the
# function to simplify the code.  As shown below, any variable defined inside
# the function is available to functions it defines (through the environment)
# without passing them as arguments to the function.
increment <- 0
f <- function() 
{
	add_inc <- function(x) return(x+increment)
    increment <- 10
	cat("\n This should be 11: ",add_inc(1))
	cat("\n This should be 20: ",add_inc(10))
}
f()
# However, because it will search the parent environments, apparently odd 
# things can happen if you make a typo or forget to define an object and it
# is found elsewhere.
f <- function() 
{
	add_inc <- function(x) return(x+increment)
	incremnt <- 10
	cat("\n This should be 11: ",add_inc(1))
	cat("\n This should be 20: ",add_inc(10))
}
f()
# You can search for problems like this using the function
# findGlobals or better checkUsage in the codetools package
library(codetools)
# findGlobals shows that increment is being used from outside of the function
findGlobals(f)
# checkUsage identifies that incremnt is defined in the
# function environment but not used. If you develop a package and use rcmd check, 
# checks like these are run on each function in the package.
checkUsage(f)
#
##################################################################
# Dynamic Scoping
##################################################################
# While it is not recommended it is possible to use dynamic scoping
# and it can be useful in some circumstances, most notably to create
# functions that will be used interactively (at the keyboard or scripts)
# rather than being called from other functions. With dynamic scoping,
# objects are obtained from the environment in which the function is 
# called rather than from the environment in which the function was
# defined.  Below is an example that shows the difference. It demonstrates the potential 
# problems that can occur if you are expecting the g to get the result from the global 
# environment and then you invoke it from another function
# 
x <- 0
# Define f which invokes g
f <- function() 
{
	cat("\n in function f")
	cat("\nx in environment   = ",x,"\n")
	x <- x + 1
	cat("\nx in function      = ",x,"\n")
	g()
	invisible()
}
# Define g
g <- function() 
{
	cat("\n in function g")
	cat("\nx in global environment  = ",x,"\n")
	x=get("x",parent.frame())
	cat("\nx from calling frame     = ",x,"\n")
	invisible()
}
# Invoke f, increment x and then invoke g which gets incremented x from f
f()
# Invoke g and now it gets the x from the global environment because it was
# invoked from the global environment and it is then the calling frame. 
g()



