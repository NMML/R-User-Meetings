# POSIXt - Portable Operating System Interface for uniX

# POSIXlt stores dates in a list
dt.lt <- as.POSIXlt("2011/08/23 6:05")
str(dt.lt)
dt.lt$mon
dt.lt$year

# POSIXct stores dates as character
dt.ct <- as.POSIXct("2011/08/23 6:05")
str(dt.ct)
dt.ct$mon

# ISOdatetime and ISOdate converts numerical to POSIXct
dt.iso <- ISOdatetime(2011, 8, 23, 6, 5, 0)
str(dt.iso)
dt.iso <- ISOdate(rep(2011, 4), c(1, 2, 3, 4), rep(c(15, 20), 2))

# strptime converts a formatted character date to POSIXlt
xmas <- strptime("12/25/2011", "%m/%d/%Y")

# strftime converts POSIXlt to character (as.character converts both POSXIXct and POSIXlt)
today <- strftime(dt.lt, format = "%Y-%m-%d %H hours, %M minutes")

# format both POSIXlt and POSIXct to character
format(dt.ct, "Year: %Y, Month: %m, Day: %d at %H%M", tz = "EST")

# Sys.time is today's date in POSIXct
today.ct <- Sys.time()

# time difference
xmas - today.ct

# specify units using difftime
sec.of.year <- difftime(today.ct, as.POSIXct("2011/1/1"), units = "secs")
str(sec.of.year)

# see units of difftime object
units(sec.of.year)

# convert units of difftime object
units(sec.of.year) <- "weeks"
str(sec.of.year)

# add units to date
dt.ct + as.difftime(2, units = "weeks")
dt.ct + as.difftime(3.5, units = "hours")

# extract date-specific values
weekdays(dt.iso)
months(dt.ct)
quarters(xmas)
julian(today.ct, "2011-1-1")

# other date/time packages: chron, date, gdata, etc.