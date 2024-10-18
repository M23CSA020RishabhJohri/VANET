# Create a simulator object
set ns [new Simulator]

# Define trace and nam file for simulation output
set tracefile [open out.tr w]
set namfile [open out.nam w]
$ns trace-all $tracefile
$ns namtrace-all $namfile

# Define a finish procedure to close the files at the end of the simulation
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}

# Define topology parameters
set numVehicles 10    ;# Number of vehicles
set numRSU 2          ;# Number of RSUs
set junctionDist 300   ;# Distance between junctions
set laneLength 500     ;# Length of each road section

# Create RSU and vehicle nodes
set rsu1 [$ns node]
set rsu2 [$ns node]

# Create vehicle nodes
for {set i 0} {$i < $numVehicles} {incr i} {
    set vehicle($i) [$ns node]
}

# First, create all TCP agents and sinks
for {set i 0} {$i < $numVehicles} {incr i} {
    set tcp($i) [new Agent/TCP]
    set sink($i) [new Agent/TCPSink]
}

# Attach TCP agents and sinks to the respective vehicles
for {set i 0} {$i < $numVehicles} {incr i} {
    # Attach agents to vehicles
    $ns attach-agent $vehicle($i) $tcp($i)
    $ns attach-agent $vehicle($i) $sink($i)
}

# Create V2V traffic between vehicle pairs
for {set i 0} {$i < $numVehicles} {incr i} {
    if {$i < [expr $numVehicles-1]} {
        $ns connect $tcp($i) $sink([expr $i+1])
    } else {
        # Connect last vehicle back to the first vehicle
        $ns connect $tcp($i) $sink(0)
    }

    # Start TCP traffic
    set cbr($i) [new Application/Traffic/CBR]
    $cbr($i) attach-agent $tcp($i)
    $ns at 1.0 "$cbr($i) start"
}

# Create V2R communication between vehicles and RSUs
for {set i 0} {$i < $numRSU} {incr i} {
    set rsu_tcp($i) [new Agent/TCP]
    set rsu_sink($i) [new Agent/TCPSink]
    $ns attach-agent $rsu($i) $rsu_tcp($i)
    $ns attach-agent $rsu($i) $rsu_sink($i)

    # Connect some vehicles to RSUs
    $ns connect $tcp($i) $rsu_sink($i)
}

# Define movement patterns (optional)
for {set i 0} {$i < $numVehicles} {incr i} {
    set xPos [expr $i * 50]
    set yPos 0
    $ns at 0.0 "$vehicle($i) setdest $xPos $yPos 10.0"
}

# Setup routing protocol (AODV to match AWK script)
$ns rtproto AODV

# Simulation end time
$ns at 10.0 "finish"

# Run the simulation
$ns run
