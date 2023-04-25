using Plots
using Random

Random.seed!(3334)

global currentPhase = "SlowStart"

rtt = 200
rttValues = [1.0]

cwndValues = [0]

ssth = 28

temp = 1

cwnd = 2

while last(rttValues) <= 25.0
    while currentPhase == "SlowStart"
        push!(cwndValues, last(cwndValues) + cwnd)
        cwnd = cwnd*2
        push!(rttValues, last(rttValues) + 1.0)
        if last(cwndValues) >= ssth 
             currentPhase = "CongestionAvoidance"
        end
    end

    while currentPhase == "CongestionAvoidance"
        push!(cwndValues, last(cwndValues) + 1)
        push!(rttValues, last(rttValues) + 1.0)
        if rand() < 0.3
            currentPhase = "Timeout"
        end
    end

    if currentPhase == "Timeout"
        push!(cwndValues, round(last(cwndValues)/2))
        push!(rttValues, last(rttValues) + 1.0)
        currentPhase = "SlowStart"
        cwnd = 2
    end
end

plot(rttValues, cwndValues, color="black", fontfamily="Computer Modern", legend=:topleft, label = "cwnd")
title!("Изменение размера окна перегрузки")
xlabel!("RTT [сек.]")
ylabel!("Размер окна [сег.]")
savefig("/text/plot.png")