library(tidyverse)


LS_cost = function(s) {
  return(
    2.635 + (17.37 * s) + (42.37 * s^2) - (21.43 * s^3) + (14.93 * s^4)
  )
}

LS_cost(0) #0 degrees
LS_cost(0.2679) #15 degrees

(LS_cost(0.2679) - LS_cost(0))/LS_cost(0.2679)


