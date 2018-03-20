
  #' Get spirometry quality
  #'
  #' Gives quality measure from series of spirometry measures
  #'
  #' @param fev Vector of double. One or more values of FEV1.
  #' @param fvc Vector of double. One or more values of FVC.
  #' @return Character representing quality (possibilities are A,B,C,D,F).

  
  
# Based on the following criteria for grading...
# Quality grade	FEV1 or FVC
# A	3 acceptable trials within 5% or 100ml
# B	2 acceptable trials within 5% or 100ml
# C	2 acceptable trials within 10% or 150ml
# D	One acceptable trial
# F	No acceptable trials


nddspiro.quality <- function(fev, fvc) {
  
  # Ensure a maximum of three traces are given
  fev <- c(fev[1],fev[2],fev[3])
  fev <- fev[!is.na(fev)]
  fev <- sort(fev, decreasing=TRUE)
  
  # Remove any NA values
  fvc <- c(fvc[1],fvc[2],fvc[3])  
  fvc <- fvc[!is.na(fvc)]
  fev <- sort(fev, decreasing=TRUE)
  
  dfev <- abs(fev[1] - fev[2])
  dfvc <- abs(fvc[1] - fvc[2])
  
  if(length(fev)==0 | length(fvc)==0) return('F') # no traces usable
  if(is.na(dfev) | is.na(dfvc)) return('D')
  if(length(fev)==1 | length(fvc)==1) return('D') # only 1 FEV or FVC trace available
  
  if(((dfev <= fev[1]*0.05 | dfev<=0.1) & (dfvc <= fvc[1]*0.05 | dfvc<=0.1))) {
    if(length(fev)==3 & length(fvc==3)) return('A')
    if(length(fev)==2 | length(fvc==2)) return('B')
  }
  
  if(((dfev > fev[1]*0.10 & dfev>0.150) | (dfvc > fvc[1]*0.1 & dfvc>0.150))) return('D')
  
  return('C')
}