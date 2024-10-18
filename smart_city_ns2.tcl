# Initialize the simulator
set ns [new Simulator]

# Open the trace file for analysis
set tracefile [open out.tr w]
$ns trace-all $tracefile

# Open the NAM (Network Animator) file
set namfile [open out.nam w]
$ns namtrace-all $namfile

# Create an instance of God (General Operations Director)
create-god 10  ;# Specify the number of mobile nodes

# Wireless settings
set val(chan)           [new Channel/WirelessChannel] ;# Channel type
set val(prop)           Propagation/TwoRayGround      ;# Propagation model
set val(netif)          Phy/WirelessPhy               ;# Network interface
set val(mac)            Mac/802_11                    ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue       ;# Interface queue type
set val(ll)             LL                            ;# Link layer type
set val(ant)            Antenna/OmniAntenna           ;# Antenna model
set val(x)              500                           ;# X dimension of the topography
set val(y)              500                           ;# Y dimension of the topography

# Configure wireless node parameters
$ns node-config -adhocRouting AODV \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen 50 \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -channel $val(chan) \
                -topoInstance [new Topography] \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF

# Set the topography
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create RSUs and vehicle nodes as mobile nodes
set rsu1 [$ns node]  ;# Roadside Unit 1
set rsu2 [$ns node]  ;# Roadside Unit 2

set vehicle1 [$ns node]
set vehicle2 [$ns node]
set vehicle3 [$ns node]
set vehicle4 [$ns node]

# Set up movement for mobile nodes
$ns at 0.0 "$vehicle1 setdest 100 100 10.0"
$ns at 0.0 "$vehicle2 setdest 200 200 10.0"
$ns at 0.0 "$vehicle3 setdest 300 300 10.0"
$ns at 0.0 "$vehicle4 setdest 400 400 10.0"

# Add communication links
set bw 2Mb
set delay 10ms
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

# Finish and run the simulation
$ns at 10.0 "finish"
$ns run
