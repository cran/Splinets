#-------------------------------------------------------------#
#-------Generating an object from the class 'Splinets'--------#
#-------------------------------------------------------------#
#The most generic generation of an object of class 'Splinets':
sp=new("Splinets") #a generic format for 'Splinets' object
sp
#The most important SLOTs of 'Splinets' - the default values
sp@knots
sp@degree
sp@der
sp@supp

set.seed(5); n=13; xi=sort(runif(n+2)); xi[1]=0;xi[n+2]=1
sp@knots=xi #randomly assigned knots

#Changing the degree and intializing Taylor coefficients
ssp=new("Splinets",knots=xi,degree=2)
ssp@taylor

#Equidistant case
ssp=new("Splinets",knots=seq(0,1,1/(n+1)),degree=3)
ssp@taylor
ssp@equid