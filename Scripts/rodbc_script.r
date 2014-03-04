library(RODBC)
############ connecting to Excel Files  ####################
con=odbcConnectExcel2007("ZcBrand.xlsx")
Resights=sqlFetch(con,"Alive")
Brands=sqlFetch(con,"Brands")
# Female sea lions
Females=Brands[Brands$sex=="F",]
summary(Females)
# Male sea lions with weight >18kg
Males=Brands[Brands$sex=="M"&Brands$weight>18,]
summary(Males)
############## reading a few records at a time###########
xx=sqlFetch(con,"Brands",max=20)
summary(xx$weight)
xx=sqlFetchMore(con,max=20)
summary(xx$weight)
odbcClose(con)

############ connecting to Access Files  ####################
con=odbcConnectAccess2007("Zc.accdb")
Resights=sqlFetch(con,"Alive")
Brands=sqlFetch(con,"ZcBrand")
#############  Fetching only specific fields and records #######
MaleWtLength=sqlQuery(con,query=paste("select weight,length from ZCBRAND","where sex ='M'"))
with(MaleWtLength,plot(weight,length))
############## R version of the same fetch ########################################
Brands=sqlFetch(con,"ZcBrand")
MaleWtLength=subset(Brands,select=c("weight","length"),subset=sex=="M")
with(MaleWtLength,plot(weight,length))
############### merge - equivalent to join operation ################
resight_brand=merge(Resights,Brands)
nrow(Brands)
nrow(Resights)
nrow(resight_brand)
resight_brand=merge(Resights,Brands,all.x=TRUE)
nrow(resight_brand)
summary(resight_brand$sex)
########### create capture history ####
brand_resights=merge(Brands,Resights,by="brand",all.x=TRUE)
capture_history=with(brand_resights,table(brand,as.POSIXlt(sitedate)$year+1900))
capture_history[capture_history>0]=1
head(capture_history)

###### getting remote data and storing in Access database ##############
#' Retrieve buoy data 
#' 
#' @param bouy NDBC buoy designation (ie ESB 46053)
#' @param year 4 digit year to extract
#' @param month text string for month from current year data
#' @param dir directory location for databases; if NULL uses value in databases.txt; if "" uses package directory
#' @return extracted dataframe 
#' @export read_ndbc read_ndbc_month 
#' @aliases read_ndbc read_ndbc_month 
#' @author Jeff Laake
#' @examples
#' esb_2013=read_ndbc("46053",2013)
#' esb_jan=read_ndbc_month("46053","Jan")
read_ndbc=function(buoy,year)
{
	con=url(paste("http://www.ndbc.noaa.gov/view_text_file.php?filename=",buoy,"h",year,".txt.gz&dir=data/historical/stdmet/",sep=""))
	df=read.delim(con,row.names=NULL,skip=2,sep="",header=FALSE)
	names(df)=c("Year","Month","Day","Hour","Minute","WDIR","WSPD","GST","WVHT","DPD","APD","MWD","PRES","ATMP","WTMP","DEWP","VIS","TIDE")
	df$Buoy=buoy  
	return(df[df$Year==year,])
}

read_ndbc_month=function(buoy,month)
{
	con=url(paste("http://www.ndbc.noaa.gov/data/stdmet/",month,"/",buoy,".txt",sep=""))
	df=read.delim(con,row.names=NULL,skip=2,sep="",header=FALSE)  
	names(df)=c("Year","Month","Day","Hour","Minute","WDIR","WSPD","GST","WVHT","DPD","APD","MWD","PRES","ATMP","WTMP","DEWP","VIS","TIDE")
	df$Buoy=buoy
	return(df)
}
# get 2013 data from buoy in East Santa Barbara Channel
esb_2013=read_ndbc("46053",2013)
# store in Zc.accdb
if("esb"%in%sqlTables(con)$TABLE_NAME)sqlDrop(con,"esb")
sqlSave(con,esb_2013,"esb",rownames=FALSE)
# append Jan 2014
esb_jan=read_ndbc_month("46053","Jan")
sqlSave(con,esb_jan,"esb",append=TRUE,rownames=FALSE)
odbcClose(con)
