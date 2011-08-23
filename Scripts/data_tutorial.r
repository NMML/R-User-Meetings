# Manipulating and aggregating data
#
# Demonstrate use of RODBC, merge, table, cast/melt
#
# Throughout, I use the "with" function to make the code a little more readable
# with is like a temporary attach which lasts within the (). It makes names within
# the dataframe understood without qualifying them (e.g, you can use x rather than df$x or df[,"x"])
# Get marking and resight data tables from ACCESS
library(RODBC)
connection=odbcConnectAccess2007("Zc.accdb")
brand=sqlFetch(connection,"ZcBrand")
resight=sqlFetch(connection,"Alive")
str(brand)
str(resight)
# Only want to use a subset of resights from 15 June to 15 August - the primary resight period
# create a numeric field which is month*100+day
resight$mday=as.POSIXlt(resight$sitedate)[["mon"]]*100+as.POSIXlt(resight$sitedate)[["mday"]]
# Create subset which has values between 615 to 815
resight=subset(resight,subset=mday<=815 & mday >=615)
str(resight)
# Once you subset, it is always a good idea to drop unused factor levels. You can do that for all factor
# variables with the droplevels function that was added in v2.12.0. If you don't execute the command below
# the code below using reshape2 will fail because I discovered a small problem in the package that occurs 
# under certain conditions.  The solution is to use droplevels() and I've suggested that Hadley implement that
# in his package.
resight=droplevels(resight)
# I'd like to get a table which shows the counts of number of resights by sex at each site; however, sex
# is in brand.  The solution is to use the function merge which is the equivalent to a join in database lingo
resight.brand=merge(resight,brand,by="brand")
str(resight.brand)
# Note that the count of merged records is 822 neither the number of brands (498) or the number of resight records (830)
# The default behavior for merge is to create a record for x (resight in this case) only if it has a match in y (brands)
# which implies that there is no match for 8 of the 830 records.  To see which ones, we can use all.x=TRUE to force each
# record in x to be included and then we can look for the records with missing brand data.
resight.brand=merge(resight,brand,by="brand",all.x=TRUE)
str(resight.brand)
resight.brand[is.na(resight.brand$cohort),]
# Hmm, there is a brand 588 in the resight data that is not in the brand data.  This is a good way to catch errors.
# In this case it is not an error.  It occurred because I extracted these data from a larger data set and left in these records to 
# demonstrate this aspect of merge. So let's go back to the original merge and construct the table I want.
resight.brand=merge(resight,brand,by="brand")
with(resight.brand,table(sex,sitecode))
# Let's say I also wanted to get the table by year as well
with(resight.brand,table(sex,sitecode,pupyear))
# These tables can get a bit messy to read and ftable (flat table) can provide a nicer version
with(resight.brand,ftable(sex,sitecode,pupyear))
# Sometimes it is useful to convert the result into a dataframe which can be done as follows
counts.df=as.data.frame(with(resight.brand,table(sex,sitecode,pupyear)))
# Let's look at the first few records
head(counts.df)
# Beware that table excludes any records that contain NA in the fields being tabled; 
# you can include them explicity using the argument useNA
with(resight.brand,table(sex,sitecode,useNA="ifany"))
#
# Now let's create a capture history of the resightings
# First join on brand with resights
brand.resight=merge(brand,resight,all.x=TRUE)
resight.table=with(brand.resight,table(brand,pupyear))
# Each animal can be seen more than once in a season so we want to change this to a 1
resight.table[resight.table>= 1]=1
# That is just the resight history and doesn't include the original release. In this data
# there is only 1 cohort but I'll show the general way assuming there were releases in years 
# 2000-2010
release.table=table(brand$brand,factor(brand$cohort,levels=2000:2010))
# Add an additional column to resight table for first release column
resight.table=cbind(rep(0,nrow(resight.table)),resight.table)
ch.table=release.table+resight.table
# Now collapse the table into capture histories
ch=apply(ch.table,1,paste,collapse="")
# Below is an alternative way to create a ch using reshape2
# There are many other aggregation functions like table including aggregate, by, tapply etc
# But a unifying approach is to use the reshape2 package which has cast and melt functions.
# The basic approach is to melt the data (I'll explain later) and then cast it into whatever shape you want it.
# But before we go down that route, I'll show an example of cast that does not require
# melting the data. In reshape the function is cast but in reshape2 there are acast and dcast
# where acast returns an array and dcast returns a dataframe.  Only 2 dimensions can be used with dcast (rows/cols)
# Below I'll use cast to get the table of resight records by sex,sitecode,pupyear
library(reshape2)
# We'll use acast here to create a 3 dimensional array. Each variable defines a margin (dimension for the array).
# The order is important. The variable on the far left changes last and the one on the far right first.  You can
# think of it as nested do loops with the outer to inner proceeding from left to right. Notice that NAs are 
# automatically included if there are any.
acast(resight.brand,sex~sitecode~pupyear,value_var="brand",length) # the variable here is not relevant
# It is possible to reduce the dimensions of the result but keep all of the combinations by combining variables with +
# For example, the following creates a 2 dimensional table by combining sex and sitecode for the rows and
# pupyear for the columns.
acast(resight.brand,sex+sitecode~pupyear,value_var="brand",length) # the variable here is not relevant
# Because the result only has 2 dimensions you can use dcast so the result is a dataframe instead of an array. 
# Also, it is more useful because each factor variable on the left of the ~ ends up being a separate column in the dataframe.
dcast(resight.brand,sex+sitecode~pupyear,value_var="brand",length) 
# If you want to get the same structure we got in counts.df, a dataframe with a Frequency column; use the following.
# I've changed the order here so it matches counts.df
newcounts.df=dcast(resight.brand,pupyear+sitecode+sex~.,value_var="brand",length) 
head(newcounts.df)
head(counts.df)
# Notice that dcast dropped records where the combination was not found.  To force that behavior, you can use
# the argument drop=FALSE.
head(dcast(resight.brand,pupyear+sitecode+sex~.,value_var="brand",length,drop=FALSE)) 
# So far we have only been doing a simple casting of the data and it has melted the
# data for us.  But melt itself can be useful. First what is the concept of melting data.
# Imagine the columns of your data melting down into rows with certain fields being repeated
# with the melted data.  The repeated fields are called the id.vars and the columns that
# melt are the measure.vars.  I'll show a very simple example with 1 id.var and 3 measure.vars.
xdf=data.frame(fac=letters[1:3],x=1:3,y=4:6,z=7:9)
xdf
melt(xdf)
# By default melt will use factor variables as id.vars and numeric fields as measure.vars
# You may want to select specific variables and this as done as follows:
melt(xdf,id.vars=c("fac"),measure.var=c("x","z"))
# Once you have melted the data, it can be casted into a new form with the acast or dcast functions
# To do anything sensible, we need to use a larger dataset so I'll revert back to the brand data
mrb=melt(brand,id.vars=c("brand","sex"),measure.vars=c("weight","length"))
str(mrb)	
# Now we can easily cast the data into a new form or more likely aggregate the data in some manner.
# Below, I'll compute the means and standard errors for each variable by sex.
means=dcast(mrb,sex~variable,mean)
se=dcast(mrb,sex~variable,function(x) return(sqrt(var(x)/length(x))))
means=cbind(means,se.weight=se[,2],se.length=se[,3])
means
# You can also reverse the roles of variable and sex
dcast(mrb,variable~sex,mean)
# Now let's consider a slightly more complicated example in which I want to create a capture history for
# each animal.  The capture history is 1 if it was seen at least once in a year and 0 otherwise. I've carried along
# sex, weight, length in the id.vars so I can have these with the brand to use as covariates. These
# are included in the cast with the + operator.
mrb=melt(resight.brand,id.vars=c("brand","sitedate","pupyear","sex","weight","length"))
ch.df=dcast(mrb,brand+sex+weight+length~pupyear,function(x) ifelse(length(x)>0,1,0))
ch.df$ch=apply(ch.df[-(1:4)],1,paste,collapse="")
head(ch.df)
# The result ch.df is in tabular format.  It is quite often to have tabular data and then want to 
# switch it to non-tabular format. The following also shows how you can use column numbers in place of
# column names.
seen.df=melt(ch.df,id.vars=1:4,measure.vars=5:14 )
# We can change the variable names to be a little more meaningful. Also, sort the dataframe by brand and year
names(seen.df)[5:6]=c("year","seen")
seen.df=seen.df[order(seen.df$brand,seen.df$year),]
head(seen.df)
# melt is also useful in conjunction with facetting in ggplots for plots over multiple variables.  
# Below is an example where I return to the brand data to get a histogram of weight and length by sex.
mrb=melt(brand,id.vars=c("brand","sex"),measure.vars=c("weight","length"))
library(ggplot2)
ggplot(mrb,aes(value))+geom_bar(binwidth=2)+facet_grid(sex~variable,scale="free_x")
