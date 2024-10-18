# Initialize the simulator
set ns [new Simulator]

# Open the trace file for analysis
set tracefile [open out.tr w]
$ns trace-all $tracefile

# Open the NAM (Network Animator) file
set namfile [open out.nam w]
$ns namtrace-all $namfile

# Define finish procedure to close files after simulation ends
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}

# Wireless settings (fix for the "chan" variable issue)
# Define the channel type and wireless-specific parameters
set val(chan)           Channel/WirelessChannel  ;# Channel type
set val(prop)           Propagation/TwoRayGround ;# Propagation model
set val(netif)          Phy/WirelessPhy          ;# Network interface
set val(mac)            Mac/802_11               ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue  ;# Interface queue type
set val(ll)             LL                       ;# Link layer type
set val(ant)            Antenna/OmniAntenna      ;# Antenna model
set val(x)              500                      ;# X dimension of the topography
set val(y)              500                      ;# Y dimension of the topography

# Configure wireless node parameters
$ns node-config -adhocRouting AODV \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen 50 \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -channelType $val(chan) \
                -topoInstance [new Topography] \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF

# Create wireless topology
$ns set-topography [new Topography]
$ns topography load_flatgrid $val(x) $val(y)

# Set up a topology for the smart city with 2 RSUs and vehicles
set rsu1 [$ns node]  ;# Roadside Unit 1
set rsu2 [$ns node]  ;# Roadside Unit 2

# Define vehicles
set vehicle1 [$ns node]
set vehicle2 [$ns node]
set vehicle3 [$ns node]
set vehicle4 [$ns node]

# Define link parameters (delay and bandwidth)
set bw 2Mb
set delay 10ms

# Add communication links (for V2V and V2R communication)
$ns simplex-link $rsu1 $vehicle1 $bw $delay DropTail
$ns simplex-link $rsu1 $vehicle2 $bw $delay DropTail
$ns simplex-link $rsu2 $vehicle3 $bw $delay DropTail
$ns simplex-link $rsu2 $vehicle4 $bw $delay DropTail
$ns simplex-link $vehicle1 $vehicle2 $bw $delay DropTail
$ns simplex-link $vehicle3 $vehicle4 $bw $delay DropTail

# Define TCP agents (for V2V and V2R communication)
set tcp1 [new Agent/TCP]
$ns attach-agent $vehicle1 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $vehicle2 $sink1
$ns connect $tcp1 $sink1

set tcp2 [new Agent/TCP]
$ns attach-agent $vehicle3 $tcp2

set sink2 [new Agent/TCPSink]
$ns attach-agent $vehicle4 $sink2
$ns connect $tcp2 $sink2

# Start communication
$ns at 1.0 "$tcp1 start"
$ns at 1.5 "$tcp2 start"

# Define CBR traffic for vehicles to RSUs (V2R communication)
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $tcp1

set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.005
$cbr2 attach-agent $tcp2

# Performance measurement: Packet Delivery Ratio, Packet Loss, Throughput

# Monitor packet delivery and loss for vehicles
set pd-monitor [$ns monitor-queue $vehicle1 $vehicle2]
set pd-monitor2 [$ns monitor-queue $vehicle3 $vehicle4]

# Throughput calculation
proc calculate_throughput {queue} {
    set totalBytes 0
    set startTime 0
    set endTime 0
    foreach {t bytes} [$queue get-bytes] {
        if {$startTime == 0} {
            set startTime $t
        }
        set endTime $t
        set totalBytes [expr $totalBytes + $bytes]
    }
    set throughput [expr $totalBytes * 8 / ($endTime - $startTime)]
    return $throughput
}

# Finish and run the simulation
$ns at 10.0 "finish"
$ns run
