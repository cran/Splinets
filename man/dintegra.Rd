% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fun_dintegra.R
\name{dintegra}
\alias{dintegra}
\title{Calculating the definite integral of a spline.}
\usage{
dintegra(object, sID = NULL)
}
\arguments{
\item{object}{\code{Splinets}-object;}

\item{sID}{vector of integers, the indicies specifying for which splines in the \code{Splinets}-object 
the definite integral is to be evaluated; If \code{sID=NULL}, then the definite integral of all splines in the object 
are calculated. The default is \code{NULL}.}
}
\value{
A \code{length(sID) x 2} matrix, with the first column holding the id of splines and the second 
column holding the corresponding definite integrals.
}
\description{
The function calculates the definite integrals of the splines in an input  \code{Splinets}-object.
}
\section{References}{

Liu, X., Nassar, H., Podg\eqn{\mbox{\'o}}{o}rski, K. "Dyadic diagonalization of positive definite band matrices and efficient B-spline orthogonalization." Journal of Computational and Applied Mathematics (2022) <https://doi.org/10.1016/j.cam.2022.114444>.


Podg\eqn{\mbox{\'o}}{o}rski, K. (2021) 
"\code{Splinets} -- splines through the Taylor expansion, their support sets and orthogonal bases." <arXiv:2102.00733>.

 Nassar, H., Podg\eqn{\mbox{\'o}}{o}rski, K. (2023) "Splinets 1.5.0 -- Periodic Splinets." <arXiv:2302.07552>
}

\examples{
#------------------------------------------#
#--- Example with common support ranges ---#
#------------------------------------------#
n=23; k=4
set.seed(5)
xi=sort(runif(n+2)); xi[1]=0; xi[n+2]=1
# generate a random matrix S
S=matrix(rnorm((n+2)*(k+1)),ncol=(k+1))
# construct the spline
spl=construct(xi,k,S) #constructing the first correct spline
spl=gather(spl,construct(xi,k,S,mthd='CRFC')) #the second and the first ones
spl=gather(spl,construct(xi,k,S,mthd='CRLC')) #the third is added

plot(spl)
dintegra(spl, sID = c(1,3))
dintegra(spl)
plot(spl,sID=c(1,3))

#---------------------------------------------#
#--- Examples with different support ranges---#
#---------------------------------------------#

n=25; k=2
xi=seq(0,1,by=1/(n+1))
#Defining support ranges for three splines
supp=matrix(c(2,12,4,20,6,25),byrow=TRUE,ncol=2)
#Initial random matrices of the derivative for each spline
set.seed(5)
SS1=matrix(rnorm((supp[1,2]-supp[1,1]+1)*(k+1)),ncol=(k+1)) 
SS2=matrix(rnorm((supp[2,2]-supp[2,1]+1)*(k+1)),ncol=(k+1)) 
SS3=matrix(rnorm((supp[3,2]-supp[3,1]+1)*(k+1)),ncol=(k+1)) 
spl=construct(xi,k,SS1,supp[1,]) #constructing the first correct spline
nspl=construct(xi,k,SS2,supp[2,])
spl=gather(spl,nspl) #the second and the first ones
nspl=construct(xi,k,SS3,supp[3,])
spl=gather(spl,nspl) #the third is added

plot(spl)
dintegra(spl, sID = 1)
dintegra(spl)

#The third order case
n=40; xi=seq(0,1,by=1/(n+1)); k=3; 
support=list(matrix(c(2,12,15,27,30,40),ncol=2,byrow = TRUE))
sp=new("Splinets",knots=xi,smorder=k,supp=support) 
m=sum(sp@supp[[1]][,2]-sp@supp[[1]][,1]+1) #the number of knots in the support
sp@der=list(matrix(rnorm(m*(k+1)),ncol=(k+1))); sp1 = is.splinets(sp)[[2]] 

support=list(matrix(c(2,13,17,30),ncol=2,byrow = TRUE))
sp=new("Splinets",knots=xi,smorder=k,supp=support) 
m=sum(sp@supp[[1]][,2]-sp@supp[[1]][,1]+1) #the number of knots in the support
sp@der=list(matrix(rnorm(m*(k+1)),ncol=(k+1))); sp2 = is.splinets(sp)[[2]] 

sp = gather(sp1,sp2)
dintegra(sp)
plot(sp)

lcsp=lincomb(sp,matrix(c(-1,1),ncol=2))
dintegra(lcsp)                  #linearity of the integral
dintegra(sp2)-dintegra(sp1)
}
\seealso{
\code{\link{integra}} for generating the indefinite integral; 
\code{\link{deriva}} for generating derivative functions of splines;
}
