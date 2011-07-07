######################################################################################
#                   Basic R graphics functions
######################################################################################
# demo(graphics) will show a variety of graphics and how to perform them
#
# plot    - x,y cross plots
example(plot)
# boxplot - univariate distribution summary with classification by factors
example(boxplot)
# barplot - standard barplot typically of counts/proportions
example(barplot)
# dotchart - Cleveland dot plot (substitute for barplot)
example(dotchart)
# stripchart - 1d scatterplot
example(stripchart)
# hist - univariate histogram
example(hist)
# pairs - pairwise crossplots of a set of variables
example(pairs)
# coplot - conditioning plots
example(coplot)
# heatmap
example(heatmap)
# image
example(image)
# plotCI  - confidence intervals
example(plotCI)
# rug - show where most data are in density
example(rug)
# legend - add various types of legends
example(legend)
# text - adding text to plots
example(text)
# mtext - adding margin text
example(mtext)
# layout - putting mutliple plots on the same page
example(layout)
######################################################################################
#                   Basics of graphics devices
######################################################################################
# All graphics such as crossplots (plot), barplots (barplot), boxplots (boxplot),
# piecharts (piechart), dotplots (dotplot), etc are shown in a graphics device.
# You can use all of the graphics functions without really understanding what
# a graphics device is but that will limit the usefulness of the graphics functions and your
# understanding. Thus as a starting point, I'll describe how to open and close devices and the types
# of graphic devices.
# I'll start with the help file for the dev.new function which creates a new empty 
# graphics device (window).  You can open multiple graphics devices and switch between them.
?dev.new
# This graphics window is not dependent on a particular type of device/computer system
# the function call dev.new() will open a new graphics window on any system.
dev.new()
# You many have also seen windows() or win.graph() which are specific to Windows and will not work
# on Mac or Linux machines. To look at the possible list of devices, get help 
?Devices
# You'll see that there are many different types such as bitmap, tiff, pdf etc and many of
# these open a device which is attached to a file and the graphic will not appear on the screen.
#
# create simple cross plot
plot(1:10,1:10)
# create another simple cross plot and notice that it replaced the previous plot
plot(1:10,2*(1:10))
# If you want the plots in separate devices use dev.new between them
dev.new()
plot(1:10,1:10)
# you can list which devices are open with the dev.list() function
dev.list()
# One of the windows will show as Active (the last plot) and the other as Inactive (the first plot).
# You can change which one is active with the dev.set() function; you'll see the Active/Inactive titles swap.
dev.set(2)
# The active device is the one which will contain the next plot or next graphic that you want to add. Without explaining
# one it does, I'll use a function that adds a line to the plot. Notice how it goes to the plot in the Active device
abline(0,1)
# Note that there are also functions for copying graphics from one device to another and printing contents of a device
# It is also possible to copy the graphic to a particular format from an open graphics device on the screen.  Click into the device
# and notice how the menu selections change.  Under File, you'll find Save As and Copy to the clipboard for saving/copying the 
# graphics contents into a format.
#
# Next open a pdf graphics device
pdf()
# list open devices
dev.list()
# Now plot the same 2 plots to the pdf device; this device is different and the second plot
# will follow the first on a separate page.
plot(1:10,1:10)
plot(1:10,2*(1:10))
# show files with pdf extension; note that it created Rplots.pdf as the default
list.files(pattern="*.pdf")
# close this device; Make sure to close the device before you try to look at it or you'll get an error message 
# from any program that wants to open it like Adobe reader.
dev.off(3)
# Let's use the system function which lets you run any program from within in R.  The following may not work for
# you without changing the directory specification for Adobe reader. I'm only using this
# to open the file to show you it contains both plots.  You can also open by double clicking on the file.
system('"C:/Program Files (x86)/Adobe/Reader 9.0/Reader/acrord32.exe" Rplots.pdf')
# If I open a new device it will replace the file unless I rename it; However, I can force each plot to a 
# separate file with onefile argument. The plots are named Rplot001, Rplot002, Rplot003.
pdf(onefile=FALSE)
plot(1:10,1:10)
plot(1:10,2*(1:10))
plot(1:10,3*(1:10))
list.files(pattern="*.pdf")
dev.list()
# close all graphics devices
graphics.off()
######################################################################################
#                   Modifying graphic features
######################################################################################
# Many of the above examples demonstrated variation in color, fonts, sizes etc.  
# and labels of various sorts.  All of these are features of the graphics that you can
# modify. This can be confusing because many of the features that you can modify are not
# listed in the arguments of the function in help.  For example, args(plot) lists x,y,...
# as the arguments. The magic is that the ... can contain arguments that are passed to
# other functions that modify the features.  You can see the typical arguments
# for plot by looking at help for ?plot.default. The primary function that is called to 
# modify features is par() but there are other functions including title(), axis(), text(),
# mtext(). Many of the arguments for par can be passed directly from the higher level 
# functions like plot but there are others listed in ?par that can only be set with a
# call to par.  Some of those special parameters like mfrow and mfcol which I'll discuss 
# below modify the layout of the graphics device.
# To see all of the values of the par function type
par()
# Use ?par to see descriptions of what can be set.
?par
# Here is a simple example.  Note that if you save the current values then you can easily reset.
oldpar=par(family="serif",pch=2,cex=1.5)
plot(1:10,1:10)
# This looks odd because you'ld think that it would simply set it to the values specified above
# but in fact if you look at oldpar you'll see that it contains the previous values
par(oldpar)
oldpar
# Now if we plot we can see that it returns to the default values
dev.new()
plot(1:10,1:10)
graphics.off()
#
# The following is a function that Tim Gerrodette wrote that shows the various values of
# pch (plotting characters), col (colors), lty (line types), lwd (line widths) and fonts. 
# The output of the function is shown in the file PlottingFontsLinesPoints.pdf that I sent with script.
# Tim's function uses the functions points, text, and lines that we'll discuss later.
view.codes <- function() {
	oldpar <- par(mar=rep(1,4),family="sans")
	plot(c(0,1),c(0,22),type="n",axes=FALSE,bty="n")
	text(c(0.05,0.3,0.7,0.95),rep(22.5,4),c("Symbols","Colors","Line Types","Widths"),cex=1.3)
	text(c(0.05,0.3,0.7,0.95),rep(21.5,4),c("(pch= )","(col= )","(lty= )","(lwd= )"),cex=1.3)
	# symbols
	for(i in 0:20) {text(0,20-i,i,cex=1.3);  points(.1,20-i, pch=i,cex=1.5)}
	# default palette colors
	palette("default")
	for(i in 0:7) {text(0.28,20-i,i,cex=1.3);  points(.35,20-i, pch=15,cex=2.5,col=i)}
	points(0.35,20,pch=0,cex=2.5)					# puts box around background color
	text(0.23,17,'palette("default")',srt=90,cex=1.2)
	# grayscale palette
	palette(gray(0:5/5))
	for(i in 1:6) {text(0.28,10-i,i,cex=1.3);  points(.35,10-i, pch=15,cex=2.5,col=i)}
	points(0.35,4,pch=0,cex=2.5)					# puts box around background color
	text(0.23,7,"palette(gray(0:5/5))",srt=90,cex=1.2)
	# line types
	for (i in 1:6) {text(0.55,20-i,i,cex=1.3);  lines(c(0.6,0.7,0.85),c(20-i,21-i,21-i),lty=i)}
	# line widths
	for (i in 1:6) lines(c(0.9,1),c(21-i,21-i),lwd=i)
	# typefaces and fonts
	text(0.75,12,"Typefaces and fonts",cex=1.3)
	font.family <- c("serif","sans","mono")
	for (i in 1:3) {
		text(0.75,13-2.3*i,paste("family=",'"',font.family[i],'"',sep=""),cex=1.2,adj=0.5,family="sans")
		text(0.75,12.3-2.3*i,paste(LETTERS,collapse=""),cex=1.1,adj=0.5,family=font.family[i])
		text(0.75,11.7-2.3*i,paste(c(letters," ",0:9),collapse=""),cex=1.1,adj=0.5,family=font.family[i])
	}
	for (i in 1:4) text(0.4+i/8,3,paste("font=",i,sep=""),font=i,adj=0)
	text(0.75,2.0,"font=5",cex=1.2,adj=0.5,family="sans")
	text(0.75,1.3,paste(LETTERS,collapse=""),cex=1.1,adj=0.5,font=5)
	text(0.75,0.7,paste(letters,collapse=""),cex=1.1,adj=0.5,font=5)
	palette("default")
	par(oldpar)
}	
view.codes()
# Specifying labels and title
with(iris,plot(Sepal.Length,Sepal.Width,xlab="Sepal width (mm)",ylab="Sepal length (mm)",main="Fisher's Iris data - Sepal length vs width"))
# Using \n to split the title into 2 lines
with(iris,plot(Sepal.Length,Sepal.Width,xlab="Sepal width (mm)",ylab="Sepal length (mm)",main="Fisher's Iris data\nSepal length vs width"))
# Using title function to add a title and sub-title
with(iris,plot(Sepal.Length,Sepal.Width,xlab="Sepal width (mm)",ylab="Sepal length (mm)"))
title(main="Fisher's Iris data\nSepal length vs width",sub="sub titles are at the bottom of the plot")
# getting some extra space by using oma (outer margin) which is specified in lines for (bottom,left,top,right)
oldpar=par(oma=c(3,0,0,0))
with(iris,plot(Sepal.Length,Sepal.Width,xlab="Sepal width (mm)",ylab="Sepal length (mm)"))
title(main="Fisher's Iris data\nSepal length vs width")
title(sub="sub titles are at the bottom of the plot",outer=TRUE,line=0)
# Maybe you would like the plot without the bounding box
with(iris,plot(Sepal.Length,Sepal.Width,xlab="Sepal width (mm)",ylab="Sepal length (mm)",bty="n"))
title(main="Fisher's Iris data\nSepal length vs width")
title(sub="sub titles are at the bottom of the plot",outer=TRUE,line=0)
# Hmm, not quite what I want because the axis I'd like axes to extend beyond range of data; '
# I can adjust by specifying xlim, ylim 
with(iris,plot(Sepal.Length,Sepal.Width,xlab="Sepal width (mm)",ylab="Sepal length (mm)",bty="n",xlim=c(4,9),ylim=c(1.5,5)))
title(main="Fisher's Iris data\nSepal length vs width")
title(sub="sub titles are at the bottom of the plot",outer=TRUE,line=0)
# Now let's add colors and different symbols based on on the species of iris
with(iris,plot(Sepal.Length,Sepal.Width,xlab="Sepal width (mm)",ylab="Sepal length (mm)",col=Species,pch=as.numeric(Species)))
# Now add a legend and use locator function to position it. For col and pch we use the numeric levels 
# of the factor Species of which there are 3, so we specify 1:3=c(1,2,3)
legend(locator(1),legend=levels(iris$Species),col=1:3,pch=1:3)
# Now what if for some reason we wanted it on a log scale for x, y or both
with(iris,plot(Sepal.Length,Sepal.Width,log="x",xlab="Sepal width (mm)",ylab="Sepal length (mm)",col=Species,pch=as.numeric(Species)))
with(iris,plot(Sepal.Length,Sepal.Width,log="y",xlab="Sepal width (mm)",ylab="Sepal length (mm)",col=Species,pch=as.numeric(Species)))
with(iris,plot(Sepal.Length,Sepal.Width,log="xy",xlab="Sepal width (mm)",ylab="Sepal length (mm)",col=Species,pch=as.numeric(Species)))
######################################################################################
#                   Adding plot components
######################################################################################
# plots components can be added one by one; first plot points and use character expansion 1.5 to
# increase size of points and exclude axes and labels
plot(1:10,1:10,xaxt="n",yaxt="n",xlab="",ylab="",cex=1.5)
# next add a title and labels
title("My useless plot",xlab="X",ylab="Y")
# next add x and y axes
axis(1,at=seq(1,9,2))
axis(2,at=seq(1,9,2))
# now add a line
lines(1:10,1:10,lwd=2,lty=2)
# The same thing can also be done with a single command except that the tick mark control is less flexible
plot(1:10,1:10,xlab="X",ylab="Y",cex=1.5,type="b",lty=2,lwd=2,main="My useless plot",xaxp=c(1,9,5),yaxp=c(1,9,5))
# Below is an example which plots the points and fitted regression line
set.seed(1)
x=1:10
y=(1:10)+c(rnorm(9,0,2),-8)
plot(y~x)
# Use abline which takes an intercept and slope to draw a line.  These are obtained from linear model with coef function.
abline(coef(lm(y~x)),lwd=2)
pos=locator(2)
arrows(pos$x[1],pos$y[1],pos$x[2],pos$y[2])
text(pos$x[1],pos$y[1],"Possible outlier",adj=1)
# note plot(lm(y~x)) will provide several useful plots
#######################################################################################
#                  Adding math and greek symbols
#######################################################################################
# the function expression is used to create text with symbols and greek
# to see an example type demo(plotmath); I created the file MathExpressions.pdf by
# using pdf("MathExpressions.pdf") and then typing demo(plotmath)
#
# text - adding text to plots
example(text)
# math expression
plot(1:10, 1:10)
text(4, 9, expression(hat(beta) == (X^t * X)^{-1} * X^t * y))
# mtext - adding margin text
example(mtext)
######################################################################################
#                   Multiple plots in a single device (page)
######################################################################################
# par
par(mfrow=c(2,2),oma=c(0,0,1,0))
plot(1:10,1:10)
plot(1:10,1:10)
plot(1:10,1:10)
plot(1:10,1:10)
mtext("my plots",outer=TRUE)
# layout
#  3 graphs in top row and one in the middle -- all same size 
mat=matrix(c(1,2,3,0,4,0),ncol=3,nrow=2,byrow=TRUE)
mat
par(oma=c(0,0,1,0))
layout(mat)
plot(1:10,1:10)
plot(1:10,1:10)
plot(1:10,1:10)
plot(1:10,1:10)
mtext("my plots",outer=TRUE)
#  3 graphs in top row and one large one for the second row
mat=matrix(c(1,2,3,4,4,4),ncol=3,nrow=2,byrow=TRUE)
mat
par(oma=c(0,0,1,0))
layout(mat)
plot(1:10,1:10)
plot(1:10,1:10)
plot(1:10,1:10)
plot(1:10,1:10)
mtext("my plots",outer=TRUE)
# 2 series plotted on one graph
# two series - single y axis
x1=1:10
x2=11:20
y1=x1
y2=x2
plot(x1,y1,xlim=range(c(x1,x2)),ylim=range(c(y1,y2)),col="red",pch=1)	
points(x2,y2,col="green",pch=2)

# two series - same x, dual y axis
x=1:10
y1=x
y2=2*x+10+rnorm(10)
par(oma=c(0,0,0,2.5))
plot(x,y1,col="red",pch=1,xlab="X",ylab="Y1")	
par(new=TRUE)
plot(x,y2,col="green",pch=2,xaxt="n",yaxt="n",xlab="",ylab="")
axis(4,axTicks(4))
mtext("    Y2",side=4,outer=TRUE,line=1)

#++++++++++++++++++++++++++++++++++++
#
#++++++++++++++++++++++++++++++++++++
plot.doubleaxis <- 
		function(x1, y1, x2, y2, type = "l", xlim = NULL, 
				main  = "", xlab = "x", ylab1 = "y1", ylab2 = "y2", ...)
{
# Written by AE York Sept. 1996 for Splus; converted to R 
#Jan 2001
# Plots y1 vs x1 and y2 vs x2 on the same plot
# Labels for y1 are on the left and labels for y2 on the 
# right
# The domains of the two functions are concatenated and 
# plotted on a
# common x-axis
#
	oldpar <- par()
	par(mar = rep(5, 4))    #
	if(missing(xlim))
		xlim <- range(pretty(range(c(x1, x2))))
	plot(x1, y1, lty = 1, pch = 1, type = type, xlim = xlim, 
			xlab = xlab, ylab = ylab1, ...)
	par(new = T)
	plot(x2, y2, lty = 2, pch = 16, type = type, axes = 
					F, xlim = xlim, xlab  = "", ylab = "")
	axis(side = 4)
	mtext(ylab2, side = 4, line = 2, outer = F)
	
	title(main)
	
	par(mar=oldpar$mar)
	
}

Example: 
		
		set.seed(42); plot.doubleaxis(1:10,rnorm(10), 5:20, 7:22)
