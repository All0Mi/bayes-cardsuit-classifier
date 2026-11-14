function pdf = normpdf(x, mu, sig)
  % computes 1D normal distribution for x: ~N(mu,sig)
  % Use Probability density function of a normal Gaussian distribution
  % Return the normal distribution has an exponential shape:
  % mu is mean and sig is variance
  pdf = exp(-(x - mu).^2/(2 * sig.^2)) / sqrt(2*pi*sig.^2);
end
