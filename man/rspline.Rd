% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fun_rspline.R
\name{rspline}
\alias{rspline}
\title{Random splines}
\usage{
rspline(S, N = 1, Sigma = NULL, Theta = NULL, mthd = "RRM")
}
\arguments{
\item{S}{\code{Splinets}-object with \code{n+2} knots and of the order of smoothness \code{k}, representing the center of randomly simulated splines; 
When the number of splines in the object is bigger than one, only the first spline in the object is used.}

\item{N}{positive integer, size of the sample;}

\item{Sigma}{matrix; \itemize{
\item If \code{(n+2)x(n+2)} matrix, it controls correlations between derivatives of the same order at different knots.
\item If a positive number, it represents a diagonal \code{(n+2)x(n+2)} matrix with this number on the diagonal.
\item If a \code{n+2} vector, it 
represents a diagonal \code{(n+2)x(n+2)} matrix with the vector entries on the diagonal.
\item If \code{NULL} (default) represents the identity matrix.
}}

\item{Theta}{matrix; 
\itemize{
\item If  \code{(k+1)x(k+1)}, this controls correlations between different derivatives at each knot.
\item If a positive number, it represents a diagonal matrix with this number on the diagonal.
\item If a \code{k+1} vector, it 
represents a diagonal matrix with the vector entries on the diagonal.
\item If  \code{NULL} (default), it represents the \code{k+1} identity matrix;
}}

\item{mthd}{string, one of the three methods: RCC, CR-LC, CR-FC, to adjust random error matrix so it corresponds to a valid spline;}
}
\value{
A \code{Splinets}-object that contains \code{N} generated splines constituting an iid sample of splines;
}
\description{
The function simulates a random \code{Splinets}-object that is made of random splines with the center 
at the input spline and the matrix of derivatives has the added error term of the form 
\deqn{
\boldsymbol \Sigma^{1/2}\mathbf Z \boldsymbol \Theta^{1/2},
 } 
where  \eqn{\mathbf Z} is a \eqn{(n+2)\times (k+1)} matrix having iid standard normal variables
as its entries, while \eqn{\boldsymbol \Sigma} and \eqn{\boldsymbol \Theta} are matrix parameters. 
This matrix error term is then corrected by one of the methods and thus resulting in a matrix of derivatives at knots corresponding to a valid spline.
}
\section{References}{

Liu, X., Nassar, H., Podg\eqn{\mbox{\'o}}{o}rski, K. "Dyadic diagonalization of positive definite band matrices and efficient B-spline orthogonalization." Journal of Computational and Applied Mathematics (2022) <https://doi.org/10.1016/j.cam.2022.114444>.


Podg\eqn{\mbox{\'o}}{o}rski, K. (2021) 
"\code{Splinets} -- splines through the Taylor expansion, their support sets and orthogonal bases." <arXiv:2102.00733>.

 Nassar, H., Podg\eqn{\mbox{\'o}}{o}rski, K. (2023) "Splinets 1.5.0 -- Periodic Splinets." <arXiv:2302.07552>
}

\examples{
#-----------------------------------------------------#
#-------Simulation of a standard random splinet-------#
#-----------------------------------------------------#
n=17; k=4; xi=sort(runif(n+2)); xi[1]=0; xi[n+2]=1 
S=matrix(rnorm((n+2)*(k+1)),ncol=(k+1))
spl=construct(xi,k,S) #Construction of the mean spline

RS=rspline(spl)
graphsp=evspline(RS) #Evaluating the random spline
meansp=evspline(spl)
RS=rspline(spl,5) #Five more samples
graphsp5=evspline(RS)

m=min(graphsp[,2],meansp[,2],graphsp5[,2:6])
M=max(graphsp[,2],meansp[,2],graphsp5[,2:6])

plot(graphsp,type='l',ylim=c(m,M))
lines(meansp,col='red',lwd=3,lty=2) #the mean spline
for(i in 1:5){lines(graphsp5[,1],graphsp5[,i+1],col=i)}

#-----------------------------------------------------#
#------------Different construction method------------#
#-----------------------------------------------------#
RS=rspline(spl,8,mthd='CRLC'); graphsp8=evspline(RS)

m=min(graphsp[,2],meansp[,2],graphsp8[,2:6])
M=max(graphsp[,2],meansp[,2],graphsp8[,2:6])

plot(meansp,col='red',type='l',lwd=3,lty=2,ylim=c(m,M)) #the mean spline
for(i in 1:8){lines(graphsp8[,1],graphsp8[,i+1],col=i)}

#-----------------------------------------------------#
#-------Simulation of with different variances--------#
#-----------------------------------------------------#
Sigma=seq(0.1,1,n+2);Theta=seq(0.1,1,k+1)
RS=rspline(spl,N=10,Sigma=Sigma) #Ten samples
RS2=rspline(spl,N=10,Sigma=Sigma,Theta=Theta) #Ten samples
graphsp10=evspline(RS); graphsp102=evspline(RS2)

m=min(graphsp[,2],meansp[,2],graphsp10[,2:10])
M=max(graphsp[,2],meansp[,2],graphsp10[,2:10])

plot(meansp,type='l',ylim=c(m,M),col='red',lwd=3,lty=2) 
for(i in 1:10){lines(graphsp10[,1],graphsp10[,i+1],col=i)}

m=min(graphsp[,2],meansp[,2],graphsp102[,2:10])
M=max(graphsp[,2],meansp[,2],graphsp102[,2:10])

plot(meansp,type='l',ylim=c(m,M),col='red',lwd=3,lty=2) 
for(i in 1:10){lines(graphsp102[,1],graphsp102[,i+1],col=i)}

#-----------------------------------------------------#
#-------Simulation for the mean spline to be----------#
#------=----defined on incomplete supports------------#
#-----------------------------------------------------#
n=43; xi=seq(0,1,by=1/(n+1)); k=3; xi=sort(runif(n+2)); xi[1]=0; xi[n+2]=1;
support=list(matrix(c(2,14,25,43),ncol=2,byrow = TRUE))
ssp=new("Splinets",knots=xi,supp=support) #with partial support
nssp=is.splinets(ssp)$robject
nssp@smorder=3 #changing the order of the 'Splinets' object
m=sum(nssp@supp[[1]][,2]-nssp@supp[[1]][,1]+1) #the number of knots in the support
nssp@der=list(matrix(rnorm(m*(k+1)),ncol=(k+1)))  #the derivative matrix at random
spl=is.splinets(nssp)$robject
RS=rspline(spl,Sigma=0.05,Theta=c(1,0.5,0.3,0.05))
graphsp=evspline(RS);
meansp=evspline(spl)

m=min(graphsp[,2],meansp[,2],graphsp5[,2:6])
M=max(graphsp[,2],meansp[,2],graphsp5[,2:6])

plot(graphsp,type='l',ylim=c(m,M))
lines(meansp,col='red',lwd=3,lty=2) #the mean spline

}
\seealso{
\code{\link{is.splinets}} for diagnostics of the \code{Splinets}-objects;
\code{\link{construct}} for constructing a \code{Splinets}-object;
\code{\link{gather}}  for combining \code{Splinets}-objects into a bigger object;
\code{\link{subsample}}  for subsampling \code{Splinets}-objects;
\code{\link{plot,Splinets-method}} for plotting \code{Splinets}-objects;
}
