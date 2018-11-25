#! /usr/bin/env Rscript
#SBATCH -p shared
#SBATCH --mem 2g
#SBATCH -t 0-06:00
#SBATCH -c 10
#SBATCH -a 1-10      # Array of 10 jobs, with ids 1, 2, ...10
#SBATCH -o out_%A_%a.out   # standard output
#SBATCH -e err_%A_%a.out   # standard error

# %A and %a replacement strings for the master job ID and task ID
library(parallel)

boot_onestep <- function(i) {
  didx <- mtcars[sample(1:nrow(mtcars), replace = TRUE, nrow(mtcars)), ]
  xidx <- cbind(1, didx$wt, didx$hp); yidx <- didx$mpg
  coeffidx <- solve(t(xidx) %*% xidx) %*% t(xidx) %*% yidx
  return(t(coeffidx))
}

id <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))
system.time(b <- t(mcmapply(boot_onestep, 1:10000, mc.cores = id))

