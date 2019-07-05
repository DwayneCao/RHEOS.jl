#!/usr/bin/env julia
using RHEOS
using PyPlot

# Produces exactly the same result if ϵ is replace with σ as generated data is placed in both
# step test
# foo = stepgen(1000.0, 100.0)
# bar = stepgen(1000.0, 500.0)
# baz = foo - bar
# plot(baz.t, baz.ϵ)

# # ramp test
foo = rampgen(1000.0, 100.0, 200.0)
bar = rampgen(1000.0, 500.0, 700.0)
baz = 2*foo - bar
plot(baz.t, baz.ϵ)

# # oscillator test
# foo = singen(1000.0, 1/50; phase = -pi/2)
# bar = rampgen(1000.0, 10.0, 400.0) - rampgen(1000.0, 400.0, 800.0)
# baz = foo*bar
# plot(baz.t, baz.ϵ)

# # repeat test
# foo = -stepgen(170.0, 125.0; stepsize = 0.001)
# bar = repeatdata(foo, 5)
# plot(bar.t, bar.ϵ, "--")
show()

# complicated test with noise
# stepup = stepgen(50.0, 25.0; stepsize = 0.05, t_trans = 2.5)

# osci = 0.1*singen(50.0, 0.2; stepsize = 0.05)
# rampup = rampgen(50.0, 25.5, 37.5; stepsize = 0.05)
# rampdown = -rampgen(50.0, 37.5, 49.5; stepsize = 0.05)

# combined = osci*(rampup + rampdown) + stepup

# repeated = repeatdata(combined, 3)
# noisyrepeated = repeated + 0.01*noisegen(150.0; seed = 1, stepsize = 0.05)

# plot(repeated.t, repeated.ϵ)
# plot(noisyrepeated.t, noisyrepeated.ϵ, alpha = 0.7)
# show()