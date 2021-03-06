# Simulated annealing algorithm

# network = network data set
# population = vector with population numbers
# p = number of hospitals to place
# grannar = number of neigbours to pick
# tmax = number of iterations

sa <- function(network,population,p,grannar,tmax){
  emax <- -Inf #no solutions good enough
  
  # standardize for population
  scpop <- 1/sum(population) 
  # standardize for distance
  scdist <- 1/mean(as.matrix(network))
  
  N <- ncol(network)
  
  s <- sample(1:N,p,replace=FALSE) #sample to choose
                                      #initial nodes
  e <- energy(s,network,population)  #the energy of this solution
  
  t <- tmax #to count the number of iterations
  
  best <- s #the best solution so far
  
  while(t>0 && e>emax){
    sn <- neighbour(s,N,grannar) #pick a neighbour
    en <- energy(sn,network,population) #cost of neigbour
    
    if(en<e || runif(1)<P(scpop*scdist*(en-e),t/tmax)){
      s <- sn
      e <- en
    }
    if(en<e){
      best <- sn
    }
    t <- t-1
  }
  # Calculate energy of best (i.e. the distance of this solution)
  best_en <- energy(best,network,population)
  
  # Vector of nodes and energy as result
  results <- c(best_en,best)
  return(results)
}

# neighbour-function: picks a neighbour to the current solution
# s = current solution
# N = number of hospital nodes
# grannar = number of neighbours to pick
neighbour <- function(s,N,grannar){
  index <- sample(1:length(s),grannar,replace=FALSE)
  nygranne <- sample(1:N,grannar,replace=FALSE)
  
  s[index] <- nygranne
  return(s)
}

# Test
itShouldPickARandomNeighbour <- function(){
  s <- c(1,2,876,321,1)
  granne <- neighbour(s,1579,1)
  #print(granne)
  #print(s)
  gold <- 1
  d <- sum(granne != s)
  stopifnot(d == gold)
}

itShouldPickARandomNeighbour()

# energy-function: calculates the energy of the current solution
# s = current solution
# newtork = network data set
# population = vector with population numbers

energy <- function(s,network,population){
  #Go through every row and find which hosptital
  #that row has a minimum distance to
  a <- network[,s[1]]
  for(i in 2:length(s)){
    a <- pmin(a,network[,s[i]])
  }
  
  #Minimum distances
  mindist <- a
  #Minimum distance * population
  mindistpop <- mindist*population
  
  return(sum(mindistpop))
}

P <- function(diffe,rt){
  #P is the probability of doing a "jump" when 
  #en is larger than e
  fluff <- (1/(1+max(0,diffe))*rt)
  return(fluff)
}

# Test
itShouldReturnAValueBetween0and1 <- function(){
  value <- P(5,(9999/10000))
  return(value)
  stopifnot(0<=value && value<=1)
}

itShouldReturnAValueBetween0and1()

itShouldPlace2Hospitals <- function(){
  d <- data.frame(col=matrix(runif(12*4,1,100),
                                      ncol=12,nrow=4))
  po <- c(10,20,30,10)
  
  two_sa <- sa(network=d,
               population=po,
               p=2,
               grannar=1,
               tmax=100)
  #print(two_sa)
  #print(energy(two_sa,d,po)*mean(as.matrix(d)))
}

itShouldPlace2Hospitals()



