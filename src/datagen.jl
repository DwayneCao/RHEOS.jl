#!/usr/bin/env julia
using PyPlot
import Base: +, -, *

###############################
#~ Definitions and Overloads ~#
###############################

struct RheologyArtificial

    # original data
    data::Array{Float64,1}
    t::Array{Float64,1}

    # constant sample rate step size
    stepsize::Float64

    # operations applied, stores history of which functions (including arguments)
    log::Array{String,1}

end

function +(self1::RheologyArtificial, self2::RheologyArtificial)

    @assert self1.stepsize==self2.stepsize "Step size must be same for both datasets"

    # get time array
    if length(self1.t) >= length(self2.t)
        t  = self1.t
    else
        t = self2.t
    end

    # init data array and fill by summing over each argument's indices
    data = zeros(length(t))

    # sum with last value propagating (hanging)
    for i in 1:length(t)

        if i<=length(self1.t)
            data[i] += self1.data[i]
        else
            data[i] += self1.data[end]
        end

        if i<=length(self2.t)
            data[i] += self2.data[i]
        else
            data[i] += self2.data[end]
        end

    end

    # log
    log = vcat(self1.log, self2.log, ["previous two logs added"])

    RheologyArtificial(data, t, self1.stepsize, log)

end

function -(self1::RheologyArtificial, self2::RheologyArtificial)

    @assert self1.stepsize==self2.stepsize "Step size must be same for both datasets"

    # get time array
    if length(self1.t) >= length(self2.t)
        t  = self1.t
    else
        t = self2.t
    end

    # init data array and fill by summing over each argument's indices
    data = zeros(length(t))

    # sum with last value propagating (hanging)
    for i in 1:length(t)

        if i<=length(self1.t)
            data[i] += self1.data[i]
        else
            data[i] += self1.data[end]
        end

        if i<=length(self2.t)
            data[i] -= self2.data[i]
        else
            data[i] -= self2.data[end]
        end

    end

    # log
    log = vcat(self1.log, self2.log, ["previous two logs added"])

    RheologyArtificial(data, t, self1.stepsize, log)

end

function *(self1::RheologyArtificial, self2::RheologyArtificial)

    @assert self1.stepsize==self2.stepsize "Step size must be same for both datasets"

    # get time array
    if length(self1.t) >= length(self2.t)
        t  = self1.t
    else
        t = self2.t
    end

    # init data array and fill by summing over each argument's indices
    data = zeros(length(t))

    # sum with last value propagating (hanging)
    for i in 1:length(t)

        if i<=length(self1.t) && i<=length(self2.t)
            data[i] = self1.data[i]*self2.data[i]

        elseif i<=length(self1.t) && i>length(self2.t)
            data[i] = self1.data[i]

        elseif i>length(self1.t) && i<=length(self2.t)
            data[i] = self2.data[i]

        end

    end

    # log
    log = vcat(self1.log, self2.log, ["previous two logs added"])

    RheologyArtificial(data, t, self1.stepsize, log)

end


#####################
#~ Data Generators ~#
#####################

"""
    stepdata(t_total::Float64, t_on::Float64; t_trans::Float64 = (t_total - t_on)/100.0, amplitude::Float64 = 1.0, baseval::Float64 = 0.0, stepsize::Float64 = 0.5)

Generate RheologyArtificial struct with a step function approximated by a logisitic function.
"""
function stepdata(t_total::Float64, 
                  t_on::Float64;
                  t_trans::Float64 = (t_total - t_on)/100.0,
                  amplitude::Float64 = 1.0,
                  baseval::Float64 = 0.0,
                  stepsize::Float64 = 0.5, )

    t = collect(0:stepsize:t_total)

	k = 10.0/t_trans

	data = baseval + amplitude./(1 + exp.(-k*(t-t_on)))

    RheologyArtificial(data, t, stepsize, ["stepdata: t_total: $t_total, t_on: $t_on, t_trans: $t_trans, amplitude: $amplitude, baseval: $baseval, stepsize: $stepsize"])

end

"""
    rampdata(t_total::Float64, t_start::Float64, t_stop::Float64; amplitude::Float64 = 1.0, baseval::Float64 = 0.0, stepsize::Float64 = 0.5)

Generate RheologyArtificial struct with a ramp function.
"""
function rampdata(t_total::Float64,
                  t_start::Float64,
                  t_stop::Float64;
                  amplitude::Float64 = 1.0,
                  baseval::Float64 = 0.0,
                  stepsize::Float64 = 0.5 )

    t = collect(0:stepsize:t_total)

    m = amplitude/(t_stop - t_start)

    data = baseval + zeros(length(t))

    for (i, v) in enumerate(t)

        if t_start<=v<=t_stop
            data[i] += data[i-1] + stepsize*m
        elseif v>t_stop
            data[i] = data[i-1]
        end

    end

    RheologyArtificial(data, t, stepsize, ["rampdata: t_total: $t_total, t_start: $t_start, t_stop: $t_stop, amplitude: $amplitude, baseval: $baseval, stepsize: $stepsize"])

end

"""
    oscillatordata(t_total::Float64, frequency::Float64; t_start::Float64 = 0.0, phase::Float64 = 0.0, amplitude::Float64 = 1.0, baseval::Float64 = 0.0, stepsize::Float64 = 0.5)

Generate RheologyArtificial struct with a sinusoidal function.
"""
function oscillatordata(t_total::Float64,
                        frequency::Float64;
                        t_start::Float64 = 0.0,
                        phase::Float64 = 0.0,
                        amplitude::Float64 = 1.0,
                        baseval::Float64 = 0.0,
                        stepsize::Float64 = 0.5 )

    t = collect(0:stepsize:t_total)

    data = baseval + zeros(length(t))

    for (i, v) in enumerate(t)

        if v>=t_start
            data[i] += amplitude*sin(2*π*frequency*(v - t_start) + phase)
        end

    end

    RheologyArtificial(data, t, stepsize, ["oscillatordata: t_total: $t_total, frequency: $frequency, t_start: $t_start, phase: $phase, amplitude: $amplitude, baseval: $baseval, stepsize: $stepsize"])

end

function repeatdata()
# just repeats data given data for n cycles
end

# # step test
# foo = stepdata(800.0, 100.0; baseval = 0.0, stepsize = 0.5)
# bar = stepdata(850.0, 500.0; amplitude = -1.0)
# baz = foo + bar
# plot(baz.t, baz.data)

# # ramp test
# foo = rampdata(800.0, 100.0, 200.0; baseval = 0.0)
# bar = rampdata(825.0, 500.0, 700.0; amplitude = -1.0)
# baz = foo - bar
# plot(baz.t, baz.data)

# # oscillator test
foo = oscillatordata(800.0, 1/50; phase = -90.0)
bar = rampdata(800.0, 10.0, 400.0) - rampdata(825.0, 400.0, 800.0)
baz = foo*bar
plot(baz.t, baz.data)


show()