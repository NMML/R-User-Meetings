library(ggplot2)
# create some dummy length and weight data for sex and age categories
df=data.frame(Sex=rep(c("M","F"),100),Age=factor(rep(c("J","A"),each=100),levels=c("J","A")))
lengthmean=model.matrix(~Sex*Age,df)%*%c(85,10,35,50)
set.seed(42)
lengths=rnorm(200,lengthmean,lengthmean*.15 )
wtslope=model.matrix(~Age+Sex,df)%*%c(.1,.1,.1)
weight=rnorm(200,75+wtslope*lengths^.8,wtslope*lengths^.8*.25)
df$Weight=weight
df$Length=lengths

# Use qplot from the ggplot2 package to create a plot of weight vs length. It takes the data and creates what it thinks is
# the best default plot.
qplot(Length,Weight,data=df)
# show how to use color for grouping variables
dev.new()
qplot(Length,Weight,data=df,colour=Sex)
# Customizing colors
# Now here is where things get a little strange because you'll use the addition operator (+) to pieces to the plot
# We'll add a manual scale for color such that the first value of sex (F) is red and the second value (M) is blue
dev.new()
qplot(Length,Weight,data=df,colour=Sex)+scale_colour_manual(values=c("red","blue"))
# Customizing labels
# Similarly we may want to change the default values of the x and y labels
dev.new()
qplot(Length,Weight,data=df,colour=Sex)+scale_colour_manual(values=c("red","blue"))+xlab("Length (cm)")+ylab("Weight (kg)")
dev.new()
qplot(Length,Weight,data=df,colour=Sex)+scale_colour_manual(values=c("red","blue"))+xlab("\nLength (cm)")+ylab("Weight (kg)\n")
# Color is great but not if you are color blind, so you may want to use colour and shape
dev.new()
qplot(Length,Weight,data=df,colour=Sex,shape=Sex)+scale_colour_manual(values=c("red","blue"))+scale_shape_manual(values=c(1,3))
# Or use colour and shape with different variables
dev.new()
qplot(Length,Weight,data=df,colour=Sex,shape=Age)+scale_colour_manual(values=c("red","blue"))+scale_shape_manual(values=c(1,3))
# Close all graphics windows
graphics.off()

# qplot is fine for many graphs but the standard approach is to use the more flexible ggplot.
# with ggplot there is not default type of plot.  You have to tell it what you want plotted with things called geoms. Also,
# you have to tell it aesthetics for the plot.  At a bare minimum these are the x and y (in that order) as shown below.
# The following would create an object but haven't told it how to plot the data so it will give an error unless it is
# assigned to an object like p below
p=ggplot(df,aes(Length,Weight))
# Like with
ggplot(df,aes(Length,Weight))+geom_point()
ggplot(df,aes(Length,Weight))+geom_line()
# change default color
# Doesn't work because anything in the aesthetic (aes) is assumed to be a mapping
# variable.  The following creates variable named darkblue and the default pink color is used
ggplot(df,aes(Length,Weight,colour="darkblue"))+geom_point()
# This is the correct way
ggplot(df,aes(Length,Weight))+geom_point(colour="darkblue")
# This changes color and size and shape
ggplot(df,aes(Length,Weight))+geom_point(colour="darkblue",size=3, shape=3)
# Now add a red line
ggplot(df,aes(Length,Weight))+geom_point(colour="darkblue",size=3, shape=3)+geom_line(colour="red")
# That's a fairly useless line, let's instead add a smooth line, but let's now create the plot and then print it
p=ggplot(df,aes(Length,Weight))+geom_point(colour="darkblue",size=3, shape=3)+geom_smooth(colour="red",method="lm")
p
# Now maybe it is non-linear so let's add a more general smooth, the default
p+geom_smooth(colour="green")
# Add color to show sex grouping
p=ggplot(df,aes(Length,Weight,colour=Sex))+geom_point()
p
# But maybe I'm not fond of those colors,so like above I can change them
p=p+scale_colour_manual(values=c("red","blue"))+xlab("\nLength (cm)")+ylab("Weight (kg)\n")
p
# Now I decide that I really want to use color and shape, so I can't simply add this
p=ggplot(df,aes(Length,Weight,shape=Sex,colour=Sex))+geom_point()
p=p+scale_colour_manual(values=c("red","blue"))+xlab("\nLength (cm)")+ylab("Weight (kg)\n")+scale_shape_manual(values=c(1,3))
p
# Now maybe want to look at the lines for each sex
p=p+geom_smooth(aes(group=Sex),method="lm")
# Sometimes it can be more useful to split groups of data into separate plots.
# In ggplot this is called faceting.  We can look at the length-weight plot for each asex group as follows
p=ggplot(df,aes(Length,Weight))+geom_point()+facet_grid(.~Sex)
p
# or by
p=ggplot(df,aes(Length,Weight))+geom_point()+facet_grid(Sex~.)
p
# Or you can use 2 variables
p=ggplot(df,aes(Length,Weight))+geom_point()+facet_grid(Age~Sex)
p
# How about adding a line for each facet
p=p+geom_smooth(method="lm")
p
# Maybe I'd like to flip roles of sex and age
p=ggplot(df,aes(Length,Weight))+geom_point()+facet_grid(Sex~Age)+geom_smooth(method="lm")
p
# What if I want to flip x and y
p+coord_flip()
# Works fine except that the fitted line doesn't look correct.  All it does is flip the coordinates.  With
# a fitted line, you have to re-define dependent and independent variables.
dev.new()
p=ggplot(df,aes(Weight,Length))+geom_point()+facet_grid(Sex~Age)+geom_smooth(method="lm")
p
# By default, ggplot fixes x and y scales, but on occasion it can be useful to free one or more of the scales
p=ggplot(df,aes(Weight,Length))+geom_point()+facet_grid(Sex~Age,scale="free_y")+geom_smooth(method="lm")
p
dev.new()
p=ggplot(df,aes(Weight,Length))+geom_point()+facet_grid(Sex~Age,scale="free_x")+geom_smooth(method="lm")
p
dev.new()
p=ggplot(df,aes(Weight,Length))+geom_point()+facet_grid(Sex~Age,scale="free")+geom_smooth(method="lm")
p
graphics.off()

# There are many different geoms -- let's try histograms and barplots
ggplot(df,aes(Length))+geom_histogram()+facet_grid(Age~Sex)+ylab("Frequency")
# Note that you get a warning about a default bin width
# Geoms have a default statistic function that is used to manipulate the data.  In this
# case it is stat_bin function that accepts either binwidth .
ggplot(df,aes(Length))+geom_histogram(binwidth=20)+facet_grid(Age~Sex)+ylab("Frequency\n")
dev.new()
# or breaks arguments. If the breaks do not define equal intervals then you need to use position="dodge" because
# the default is to stack
ggplot(df,aes(Length))+geom_histogram(breaks=c(80,100,150,200,260),position="dodge")+facet_grid(Age~Sex)+ylab("Frequency\n")
dev.new()
# When you have unequal intervals it is best to show the histogram as density rather than frequency
ggplot(df,aes(Length))+geom_histogram(aes(y=..density..),breaks=c(80,100,150,200,260),position="dodge")+facet_grid(Age~Sex)+ylab("Density\n")
# On occasion, you have data that are already pre-summarized, so you don't need a stat function and you simply want to show the
# barplot. For example, using table we can construct a frequency table of length by sex and then use as.data.frame to turn it into a dataframe
# In that case you use stat="identity" so it does not try to manipulate a y variable because it has already been summarized. You use
# position="dodge" to have the bars for each sex next to each other on top of each other for default of stacked
dtable=as.data.frame(with(df,table(cut(Length,c(80,120,160,200,250)),Sex)))
names(dtable)[1]="Length"
ggplot(dtable,aes(Length,Freq,group=Sex,fill=Sex))+geom_bar(stat="identity",position="dodge")
dev.new()
ggplot(dtable,aes(Length,Freq,group=Sex,fill=Sex))+geom_bar(stat="identity")

# Another typical plot is one with error bars.  Here will create a mean and ci for weight for each sex-age 
# category.
means=as.vector(with(df,tapply(Weight,list(Sex,Age),mean)))
count=as.vector(with(df,tapply(Weight,list(Sex,Age),length)))
se=sqrt(as.vector(with(df,tapply(Weight,list(Sex,Age),var))/count))
citable=data.frame(Sex=rep(c("Female","Male"),2),Age=rep(c("Juvenile","Adult"),each=2),Weight=means,
        LCL=means-qt(.975,count-1)*se, UCL=means+qt(.975,count-1)*se)
ggplot(citable,aes(Sex,Weight,ymin=LCL,ymax=UCL,group=Age,colour=Age,shape=Age))+geom_point()+geom_errorbar(width=.5)
        








