# Define the simulation environment
set ns [new Simulator]
set tracefile [open out.tr w]
$ns trace-all $tracefile

set nf [open out.nam w]
$ns namtrace-all $nf

# Define a topology
set num_nodes 10   ;# Total number of vehicles
set rsu_nodes 2    ;# Number of RSUs

# Create Nodes
for {set i 0} {$i < $num_nodes} {incr i} {
    set node($i) [$ns node]
}

for {set i 0} {$i < $rsu_nodes} {incr i} {
    set rsu($i) [$ns node]
}

# Define TCP as the transmission model
Agent/TCP set packetSize_ 1000
Agent/TCP set window_ 32

# Create TCP/FTP connections between vehicles and RSUs (V2R communication)
set tcp [new Agent/TCP]
$ns attach-agent $node(0) $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $rsu(0) $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP
$ftp start 1.0

# Create vehicle-to-vehicle communication (V2V)
set tcp2 [new Agent/TCP]
$ns attach-agent $node(1) $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $node(2) $sink2
$ns connect $tcp2 $sink2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP
$ftp2 start 2.0

# Define mobility
$node(0) set X_ 10.0
$node(0) set Y_ 10.0
$node(1) set X_ 50.0
$node(1) set Y_ 50.0
$node(2) set X_ 100.0
$node(2) set Y_ 100.0

$rsu(0) set X_ 200.0
$rsu(0) set Y_ 200.0

$rsu(1) set X_ 300.0
$rsu(1) set Y_ 300.0

# Use AODV routing protocol for both V2V and V2R communication
$ns node-config -adhocRouting AODV

# Simulation parameters
$ns at 50.0 "finish"

# Finish function
proc finish {} {
    global ns tracefile nf
    $ns flush-trace
    close $tracefile
    close $nf
    exec nam out.nam &
    exit 0
}

# Start the simulation
$ns run
