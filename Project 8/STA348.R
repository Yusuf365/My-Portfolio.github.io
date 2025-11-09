# Set seed for reproducibility
set.seed(42)
# Total time in years
T <- 2 
# number of time steps
n <- 1000  
# Time step size
dt <- T / n  
# Let initial Initial stock price
S0 <- 100       
# Drift component (expected return)
mu <- 0.05         
# Volatility diffusion component
lambda <- 2          
# Jump jump component
jump_mean <- -0.1    
# Mean jump size (e.g., -10% drop)
jump_sd <- 0.2       
# s.d. of jump sizes

# Time points
time <- seq(0, T, length.out = n + 1)

# Simulate BroBnian motion (diffusion)
B <- cumsum(rnorm(n, mean = 0, sd = sqrt(dt)))

# Simulate Poisson jumps
jumps <- rpois(n, lambda * dt)               # number of jumps in each time step
jump_sizes <- rnorm(sum(jumps), jump_mean, jump_sd) # Sizes of all jumps
J <- numeric(n + 1)                          # Initialize jump process
J[cumsum(jumps) + 1] <- jump_sizes           # Add jump sizes at jump times
J <- cumsum(J)                               # Cumulative sum for jump process

# Stock price (Lévy process model)
drift <- (mu - 0.5 * sigma^2) * time
diffusion <- sigma * c(0, B)
X <- drift + diffusion + J  # Log price process
S <- S0 * exp(X)            # Convert to actual stock prices
# Create a data frame for plotting
financial_levy_data <- data.frame(Time = time, StockPrice = S)
# Plot the simulated stock prices
plot(financial_levy_data$Time, financial_levy_data$StockPrice, type = "l", col = "blue", lBd = 2,
     main = "Simulated Stock Price Bith Lévy Process",
     xlab = "Time (Years)", ylab = "Stock Price")