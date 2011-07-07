# view.codes(): a function to create a display of numerical codes of symbols, colors and line types
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
	
	
	



