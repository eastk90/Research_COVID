library(tidyverse)
#Power calculation.
alpha <- 0.05
g <- 4 # number of groups
df <- g-1 # df = (2-1)(g-1)
p0 = 0.85 # recovery rate under the null. estimated from district_wise.csv.
d <- 0.05
n <- 100
N <- n*g


p0s <- rep(p0, g)
p1s <- c(p0, p0+d, p0+2*d, rep(p0, g-3))

w <- sqrt( sum( (p1s-p0s)^2/p0s ) )
#chis <- N*w^2

cutoff <- qchisq(1-alpha, df)
1-pchisq(cutoff, df, ncp=N*w^2)
pwr.chisq.test(w, N , df, sig.level = alpha)


##3T vs 1C-----------------------------------------
alpha <- c(0.05, 0.1, 0.2)

#3T vs 1C
p0 = 0.85 # recovery rate under the null. estimated from district_wise.csv.

g <- 4 # number of groups
df <- g-1 # df = (2-1)(g-1)
d <- 0.01
p0s <- rep(p0, g)
p1s <- c(p0, p0+d, p0+2*d, rep(p0, g-3))
w <- sqrt( sum( (p1s-p0s)^2/p0s ) )

n <- seq(100,10000, 100)
N <- n*g

len <- length(N)
results <- data.frame(N=as.vector(t(replicate(3, N))), power=rep(NA, 3*len), alpha=rep(alpha, len))

j <- 0
for (size in N){
  cutoff <- qchisq(1-alpha, df)
  power <- 1-pchisq(cutoff, df, ncp=size*w^2)
  results[c(j+1, j+2, j+3),2] <- power
  j <- j+3
}
results$alpha <- as.factor(results$alpha)
ggplot(results, aes(x=N, y=power, color=alpha))+
  geom_line(size = 2)+
  xlab("Total Sample Size") + ylab("Power")+
  theme(axis.title.x = element_text(size=20),
        axis.title.y = element_text(size=20),
        legend.title = element_text(size=20, face="bold"),
        legend.text = element_text(size=15),
        axis.text = element_text(size = 13)
        )


##3T vs 3C-----------------------------------------
alpha <- c(0.05, 0.1, 0.2)

#3T vs 3C
p0 = 0.85 # recovery rate under the null. estimated from district_wise.csv.

g <- 6 # number of groups
df <- g-1 # df = (2-1)(g-1)
d <- 0.03
e <- 0.01
p0s <- rep(p0, g)
p1s <- c(p0, p0+d, p0+2*d, p0-e, p0, p0+e)
w <- sqrt( sum( (p1s-p0s)^2/p0s ) )

n <- seq(100,1000, 100)
N <- n*g

len <- length(N)
results <- data.frame(N=as.vector(t(replicate(3, N))), power=rep(NA, 3*len), alpha=rep(alpha, len))

j <- 0
for (size in N){
  cutoff <- qchisq(1-alpha, df)
  power <- 1-pchisq(cutoff, df, ncp=size*w^2)
  results[c(j+1, j+2, j+3),2] <- power
  j <- j+3
}
results$alpha <- as.factor(results$alpha)
ggplot(results, aes(x=N, y=power, color=alpha))+
  geom_line(size = 2)+
  xlab("Total Sample Size") + ylab("Power")+
  theme(axis.title.x = element_text(size=20),
        axis.title.y = element_text(size=20),
        legend.title = element_text(size=20, face="bold"),
        legend.text = element_text(size=15),
        axis.text = element_text(size = 13)
  )

##3T vs 2C-----------------------------------------
alpha <- c(0.05, 0.1, 0.2)

#3T vs 2C
p0 = 0.85 # recovery rate under the null. estimated from district_wise.csv.

g <- 5 # number of groups
df <- g-1 # df = (2-1)(g-1)
d <- 0.03
e <- 0.01
p0s <- rep(p0, g)
p1s <- c(p0, p0+d, p0+2*d, p0-e, p0+e)
w <- sqrt( sum( (p1s-p0s)^2/p0s ) )

n <- seq(100,1000, 100)
N <- n*g

len <- length(N)
results <- data.frame(N=as.vector(t(replicate(3, N))), power=rep(NA, 3*len), alpha=rep(alpha, len))

j <- 0
for (size in N){
  cutoff <- qchisq(1-alpha, df)
  power <- 1-pchisq(cutoff, df, ncp=size*w^2)
  results[c(j+1, j+2, j+3),2] <- power
  j <- j+3
}
results$alpha <- as.factor(results$alpha)
ggplot(results, aes(x=N, y=power, color=alpha))+
  geom_line(size = 2)+
  xlab("Total Sample Size") + ylab("Power")+
  theme(axis.title.x = element_text(size=20),
        axis.title.y = element_text(size=20),
        legend.title = element_text(size=20, face="bold"),
        legend.text = element_text(size=15),
        axis.text = element_text(size = 13)
  )


##2T vs 2C-----------------------------------------
alpha <- c(0.05, 0.1, 0.2)

#3T vs 2C
p0 = 0.85 # recovery rate under the null. estimated from district_wise.csv.

g <- 4 # number of groups
df <- g-1 # df = (2-1)(g-1)
d <- 0.03
e <- 0.01
p0s <- rep(p0, g)
p1s <- c(p0, p0+d, p0-e, p0+e)
w <- sqrt( sum( (p1s-p0s)^2/p0s ) )

n <- seq(100,3000, 100)
N <- n*g

len <- length(N)
results <- data.frame(N=as.vector(t(replicate(3, N))), power=rep(NA, 3*len), alpha=rep(alpha, len))

j <- 0
for (size in N){
  cutoff <- qchisq(1-alpha, df)
  power <- 1-pchisq(cutoff, df, ncp=size*w^2)
  results[c(j+1, j+2, j+3),2] <- power
  j <- j+3
}
results$alpha <- as.factor(results$alpha)
ggplot(results, aes(x=N, y=power, color=alpha))+
  geom_line(size = 2)+
  xlab("Total Sample Size") + ylab("Power")+
  theme(axis.title.x = element_text(size=20),
        axis.title.y = element_text(size=20),
        legend.title = element_text(size=20, face="bold"),
        legend.text = element_text(size=15),
        axis.text = element_text(size = 13)
  )

#









df <- 2
N <- 20
alpha <- 0.05
w <- 0.366213

#chis <- N*w^2

cutoff <- qchisq(1-alpha, df)
1-pchisq(cutoff, df, ncp=N*w^2)





df <- 2
N <- 140
alpha <- 0.01
w <- 0.3
pwr.chisq.test(w, N , df , sig.level = alpha)
pwr.chisq.test(w=0.3, N=140 , df=2 , sig.level = 0.01)
#chis <- N*w^2

cutoff <- qchisq(1-alpha, df)
N*w^2
1-pchisq(cutoff, df, ncp=N*w^2)


?pwr.chisq.test
1-pchisq(cutoff, df, ncp=5)
1-pchisq(cutoff, df, ncp=3.9416)
3.9416
N*w^2


library(pwr)
pwr.chisq.test(w=0.3, N=140 , df=2 , sig.level = 0.01)
