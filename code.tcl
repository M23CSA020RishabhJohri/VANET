# Basic parameters definition and Initialization
set val(chan)   Channel/WirelessChannel     ;# channel type
set val(prop)   Propagation/TwoRayGround    ;# radio-propagation model
set val(netif)  Phy/WirelessPhy             ;# network interface type
set val(mac)    Mac/802_11                  ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue     ;# interface queue type
set val(ll)     LL                          ;# link layer type
set val(ant)    Antenna/OmniAntenna         ;# antenna model
set val(ifqlen) 50                          ;# max packet in ifq
set val(nn)     16                          ;# number of mobilenodes
set val(rp)     AODV                        ;# routing protocol
set val(x)      2000                        ;# X dimension of topography
set val(y)      1500                        ;# Y dimension of topography
set val(stop)   100.0                       ;# time of simulation end


# Init        
# Simulator creation
set ns [new Simulator]

# Setting up the topography
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel


$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON


# Node Creation

set n0 [$ns node]
$n0 set X_ 480
$n0 set Y_ 780
$n0 set Z_ 0.0
$ns initial_node_pos $n0 60

set n1 [$ns node]
$n1 set X_ 1000
$n1 set Y_ 780
$n1 set Z_ 0.0
$ns initial_node_pos $n1 60

set n2 [$ns node]
$n2 set X_ 480
$n2 set Y_ 195
$n2 set Z_ 0.0
$ns initial_node_pos $n2 60

set n3 [$ns node]
$n3 set X_ 1000
$n3 set Y_ 195
$n3 set Z_ 0.0
$ns initial_node_pos $n3 60

set n4 [$ns node]
$n4 set X_ 320
$n4 set Y_ 369
$n4 set Z_ 0.0
$ns initial_node_pos $n4 40

set n5 [$ns node]
$n5 set X_ 440
$n5 set Y_ 369
$n5 set Z_ 0.0
$ns initial_node_pos $n5 40

set n6 [$ns node]
$n6 set X_ 520
$n6 set Y_ 369
$n6 set Z_ 0.0
$ns initial_node_pos $n6 40

set n7 [$ns node]
$n7 set X_ 959
$n7 set Y_ 600
$n7 set Z_ 0.0
$ns initial_node_pos $n7 40

set n8 [$ns node]
$n8 set X_ 1058
$n8 set Y_ 600
$n8 set Z_ 0.0
$ns initial_node_pos $n8 40

set n9 [$ns node]
$n9 set X_ 1133
$n9 set Y_ 600
$n9 set Z_ 0.0
$ns initial_node_pos $n9 40

set n10 [$ns node]
$n10 set X_ 840
$n10 set Y_ 573
$n10 set Z_ 0.0
$ns initial_node_pos $n10 40

set n11 [$ns node]
$n11 set X_ 840
$n11 set Y_ 461
$n11 set Z_ 0.0
$ns initial_node_pos $n11 40

set n12 [$ns node]
$n12 set X_ 840
$n12 set Y_ 360
$n12 set Z_ 0.0
$ns initial_node_pos $n12 40

set n13 [$ns node]
$n13 set X_ 590
$n13 set Y_ 142
$n13 set Z_ 0.0
$ns initial_node_pos $n13 40

set n14 [$ns node]
$n14 set X_ 590
$n14 set Y_ 55
$n14 set Z_ 0.0
$ns initial_node_pos $n14 40

set n15 [$ns node]
$n15 set X_ 590
$n15 set Y_ -42
$n15 set Z_ 0.0
$ns initial_node_pos $n15 40

# Setting up node movement
$ns at 11 " $n4 setdest 1100 369 50 " 
$ns at 11 " $n5 setdest 1100 369 50 " 
$ns at 11 " $n6 setdest 1100 369 50 "
$ns at 3 " $n7 setdest 400 600 50 " 
$ns at 3 " $n8 setdest 400 600 50 " 
$ns at 3 " $n9 setdest 400 600 50 " 
$ns at 2 " $n10 setdest 840 10 60 " 
$ns at 2 " $n11 setdest 840 10 60 " 
$ns at 2 " $n12 setdest 840 10 60 " 
$ns at 18 " $n13 setdest 590 900 60 " 
$ns at 18 " $n14 setdest 590 900 60 " 
$ns at 18 " $n15 setdest 590 900 60 " 


# *** ALL TCP CONNECTIONS COME HERE ***

# *** Vehicle 2 RSU (V2R) ***

set tcp1 [new Agent/TCP]
$ns attach-agent $n13 $tcp1
set sink4 [new Agent/TCPSink]
$ns attach-agent $n2 $sink4
$ns connect $tcp1 $sink4
$tcp1 set packetSize_ 1500

set tcp3 [new Agent/TCP]
$ns attach-agent $n15 $tcp3
set sink9 [new Agent/TCPSink]
$ns attach-agent $n2 $sink9
$ns connect $tcp3 $sink9
$tcp3 set packetSize_ 1500

set tcp31 [new Agent/TCP]
$ns attach-agent $n4 $tcp31
set sink25 [new Agent/TCPSink]
$ns attach-agent $n0 $sink25
$ns connect $tcp31 $sink25
$tcp31 set packetSize_ 1500

set tcp32 [new Agent/TCP]
$ns attach-agent $n5 $tcp32
set sink26 [new Agent/TCPSink]
$ns attach-agent $n0 $sink26
$ns connect $tcp32 $sink26
$tcp32 set packetSize_ 1500

set tcp33 [new Agent/TCP]
$ns attach-agent $n6 $tcp33
set sink27 [new Agent/TCPSink]
$ns attach-agent $n0 $sink27
$ns connect $tcp33 $sink27
$tcp33 set packetSize_ 1500

set tcp34 [new Agent/TCP]
$ns attach-agent $n7 $tcp34
set sink10 [new Agent/TCPSink]
$ns attach-agent $n2 $sink10
$ns connect $tcp34 $sink10
$tcp34 set packetSize_ 1500

set tcp2 [new Agent/TCP]
$ns attach-agent $n14 $tcp2
set sink12 [new Agent/TCPSink]
$ns attach-agent $n2 $sink12
$ns connect $tcp2 $sink12
$tcp2 set packetSize_ 1500

set tcp35 [new Agent/TCP]
$ns attach-agent $n8 $tcp35
set sink17 [new Agent/TCPSink]
$ns attach-agent $n3 $sink17
$ns connect $tcp35 $sink17
$tcp35 set packetSize_ 1500

set tcp36 [new Agent/TCP]
$ns attach-agent $n9 $tcp36
set sink8 [new Agent/TCPSink]
$ns attach-agent $n2 $sink8
$ns connect $tcp36 $sink8
$tcp36 set packetSize_ 1500

set tcp37 [new Agent/TCP]
$ns attach-agent $n10 $tcp37
set sink24 [new Agent/TCPSink]
$ns attach-agent $n1 $sink24
$ns connect $tcp37 $sink24
$tcp37 set packetSize_ 1500

set tcp38 [new Agent/TCP]
$ns attach-agent $n11 $tcp38
set sink14 [new Agent/TCPSink]
$ns attach-agent $n3 $sink14
$ns connect $tcp38 $sink14
$tcp38 set packetSize_ 1500

set tcp39 [new Agent/TCP]
$ns attach-agent $n12 $tcp39
set sink20 [new Agent/TCPSink]
$ns attach-agent $n1 $sink20
$ns connect $tcp39 $sink20
$tcp39 set packetSize_ 1500

set tcp40 [new Agent/TCP]
$ns attach-agent $n13 $tcp40
set sink30 [new Agent/TCPSink]
$ns attach-agent $n0 $sink30
$ns connect $tcp40 $sink30
$tcp40 set packetSize_ 1500

set tcp41 [new Agent/TCP]
$ns attach-agent $n14 $tcp41
set sink29 [new Agent/TCPSink]
$ns attach-agent $n0 $sink29
$ns connect $tcp41 $sink29
$tcp41 set packetSize_ 1500

set tcp42 [new Agent/TCP]
$ns attach-agent $n15 $tcp42
set sink28 [new Agent/TCPSink]
$ns attach-agent $n0 $sink28
$ns connect $tcp42 $sink28
$tcp42 set packetSize_ 1500

set tcp43 [new Agent/TCP]
$ns attach-agent $n7 $tcp43
set sink18 [new Agent/TCPSink]
$ns attach-agent $n3 $sink18
$ns connect $tcp43 $sink18
$tcp43 set packetSize_ 1500

set tcp44 [new Agent/TCP]
$ns attach-agent $n8 $tcp44
set sink11 [new Agent/TCPSink]
$ns attach-agent $n2 $sink11
$ns connect $tcp44 $sink11
$tcp44 set packetSize_ 1500

set tcp45 [new Agent/TCP]
$ns attach-agent $n9 $tcp45
set sink16 [new Agent/TCPSink]
$ns attach-agent $n3 $sink16
$ns connect $tcp45 $sink16
$tcp45 set packetSize_ 1500

set tcp46 [new Agent/TCP]
$ns attach-agent $n10 $tcp46
set sink13 [new Agent/TCPSink]
$ns attach-agent $n3 $sink13
$ns connect $tcp46 $sink13
$tcp46 set packetSize_ 1500

set tcp47 [new Agent/TCP]
$ns attach-agent $n11 $tcp47
set sink19 [new Agent/TCPSink]
$ns attach-agent $n1 $sink19
$ns connect $tcp47 $sink19
$tcp47 set packetSize_ 1500

set tcp48 [new Agent/TCP]
$ns attach-agent $n12 $tcp48
set sink15 [new Agent/TCPSink]
$ns attach-agent $n3 $sink15
$ns connect $tcp48 $sink15
$tcp48 set packetSize_ 1500

set tcp49 [new Agent/TCP]
$ns attach-agent $n4 $tcp49
set sink23 [new Agent/TCPSink]
$ns attach-agent $n1 $sink23
$ns connect $tcp49 $sink23
$tcp49 set packetSize_ 1500

set tcp50 [new Agent/TCP]
$ns attach-agent $n5 $tcp50
set sink21 [new Agent/TCPSink]
$ns attach-agent $n1 $sink21
$ns connect $tcp50 $sink21
$tcp50 set packetSize_ 1500

set tcp51 [new Agent/TCP]
$ns attach-agent $n6 $tcp51
set sink22 [new Agent/TCPSink]
$ns attach-agent $n1 $sink22
$ns connect $tcp51 $sink22
$tcp51 set packetSize_ 1500

set tcp54 [new Agent/TCP]
$ns attach-agent $n13 $tcp54
set sink54 [new Agent/TCPSink]
$ns attach-agent $n0 $sink54
$ns connect $tcp54 $sink54
$tcp54 set packetSize_ 1500

set tcp55 [new Agent/TCP]
$ns attach-agent $n14 $tcp55
set sink55 [new Agent/TCPSink]
$ns attach-agent $n0 $sink55
$ns connect $tcp55 $sink55
$tcp55 set packetSize_ 1500

set tcp56 [new Agent/TCP]
$ns attach-agent $n15 $tcp56
set sink56 [new Agent/TCPSink]
$ns attach-agent $n0 $sink56
$ns connect $tcp56 $sink56
$tcp56 set packetSize_ 1500

# *** Vehicle 2 RSU (V2R) ***

# *** Vehicle 2 Vehicle (V2V) ***

set tcp52 [new Agent/TCP]
$ns attach-agent $n13 $tcp52
set sink52 [new Agent/TCPSink]
$ns attach-agent $n6 $sink52
$ns connect $tcp52 $sink52
$tcp52 set packetSize_ 1500

set tcp53 [new Agent/TCP]
$ns attach-agent $n7 $tcp53
set sink53 [new Agent/TCPSink]
$ns attach-agent $n12 $sink53
$ns connect $tcp53 $sink53
$tcp53 set packetSize_ 1500

set tcp57 [new Agent/TCP]
$ns attach-agent $n7 $tcp57
set sink57 [new Agent/TCPSink]
$ns attach-agent $n8 $sink57
$ns connect $tcp57 $sink57
$tcp57 set packetSize_ 1500

set tcp58 [new Agent/TCP]
$ns attach-agent $n8 $tcp58
set sink58 [new Agent/TCPSink]
$ns attach-agent $n9 $sink58
$ns connect $tcp58 $sink58
$tcp58 set packetSize_ 1500


# *** Vehicle 2 Vehicle (V2V) ***


# *** ALL FTP APPLICATIONS OVER THE TCP CONNECTIONS COME HERE ***

# *** For Vehicle 2 RSU (V2R) ***


set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp2
$ns at 1.0 "$ftp0 start"
$ns at 20.0 "$ftp0 stop"

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp40
$ns at 1.0 "$ftp1 start"
$ns at 20.0 "$ftp1 stop"

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp1
$ns at 1.0 "$ftp2 start"
$ns at 20.0 "$ftp2 stop"

set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp41
$ns at 1.0 "$ftp3 start"
$ns at 20.0 "$ftp3 stop"

set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp42
$ns at 1.0 "$ftp4 start"
$ns at 20.0 "$ftp4 stop"

set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp3
$ns at 1.0 "$ftp5 start"
$ns at 20.0 "$ftp5 stop"

set ftp6 [new Application/FTP]
$ftp6 attach-agent $tcp36
$ns at 1.0 "$ftp6 start"
$ns at 20.0 "$ftp6 stop"

set ftp7 [new Application/FTP]
$ftp7 attach-agent $tcp45
$ns at 1.0 "$ftp7 start"
$ns at 20.0 "$ftp7 stop"

set ftp8 [new Application/FTP]
$ftp8 attach-agent $tcp35
$ns at 1.0 "$ftp8 start"
$ns at 20.0 "$ftp8 stop"

set ftp9 [new Application/FTP]
$ftp9 attach-agent $tcp44
$ns at 1.0 "$ftp9 start"
$ns at 20.0 "$ftp9 stop"

set ftp10 [new Application/FTP]
$ftp10 attach-agent $tcp34
$ns at 1.0 "$ftp10 start"
$ns at 20.0 "$ftp10 stop"

set ftp11 [new Application/FTP]
$ftp11 attach-agent $tcp43
$ns at 1.0 "$ftp11 start"
$ns at 20.0 "$ftp11 stop"

set ftp12 [new Application/FTP]
$ftp12 attach-agent $tcp37
$ns at 1.0 "$ftp12 start"
$ns at 12.0 "$ftp12 stop"

set ftp13 [new Application/FTP]
$ftp13 attach-agent $tcp46
$ns at 1.0 "$ftp13 start"
$ns at 12.0 "$ftp13 stop"

set ftp14 [new Application/FTP]
$ftp14 attach-agent $tcp47
$ns at 1.0 "$ftp14 start"
$ns at 20.0 "$ftp14 stop"

set ftp15 [new Application/FTP]
$ftp15 attach-agent $tcp38
$ns at 1.0 "$ftp15 start"
$ns at 20.0 "$ftp15 stop"

set ftp16 [new Application/FTP]
$ftp16 attach-agent $tcp39
$ns at 1.0 "$ftp16 start"
$ns at 20.0 "$ftp16 stop"

set ftp17 [new Application/FTP]
$ftp17 attach-agent $tcp48
$ns at 1.0 "$ftp17 start"
$ns at 20.0 "$ftp17 stop"

set ftp18 [new Application/FTP]
$ftp18 attach-agent $tcp33
$ns at 1.0 "$ftp18 start"
$ns at 20.0 "$ftp18 stop"

set ftp19 [new Application/FTP]
$ftp19 attach-agent $tcp51
$ns at 1.0 "$ftp19 start"
$ns at 20.0 "$ftp19 stop"

set ftp20 [new Application/FTP]
$ftp20 attach-agent $tcp50
$ns at 1.0 "$ftp20 start"
$ns at 20.0 "$ftp20 stop"

set ftp21 [new Application/FTP]
$ftp21 attach-agent $tcp32
$ns at 1.0 "$ftp21 start"
$ns at 20.0 "$ftp21 stop"

set ftp22 [new Application/FTP]
$ftp22 attach-agent $tcp49
$ns at 1.0 "$ftp22 start"
$ns at 20.0 "$ftp22 stop"

set ftp23 [new Application/FTP]
$ftp23 attach-agent $tcp31
$ns at 1.0 "$ftp23 start"
$ns at 20.0 "$ftp23 stop"

set ftp54 [new Application/FTP]
$ftp54 attach-agent $tcp54
$ns at 1.0 "$ftp54 start"
$ns at 30.0 "$ftp54 stop"

set ftp55 [new Application/FTP]
$ftp55 attach-agent $tcp55
$ns at 1.0 "$ftp55 start"
$ns at 30.0 "$ftp55 stop"

set ftp56 [new Application/FTP]
$ftp56 attach-agent $tcp56
$ns at 1.0 "$ftp56 start"
$ns at 30.0 "$ftp56 stop"

# *** For Vehicle 2 RSU (V2R) ***


# *** For Vehicle 2 Vehicle (V2V) ***

set ftp52 [new Application/FTP]
$ftp52 attach-agent $tcp52
$ns at 1.0 "$ftp52 start"
$ns at 20.0 "$ftp52 stop"

set ftp53 [new Application/FTP]
$ftp53 attach-agent $tcp53
$ns at 1.0 "$ftp53 start"
$ns at 20.0 "$ftp53 stop"

set ftp57 [new Application/FTP]
$ftp57 attach-agent $tcp57
$ns at 1.0 "$ftp57 start"
$ns at 30.0 "$ftp57 stop"

set ftp58 [new Application/FTP]
$ftp58 attach-agent $tcp58
$ns at 1.0 "$ftp58 start"
$ns at 30.0 "$ftp58 stop"

# *** For Vehicle 2 Vehicle (V2V) ***

proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exec awk -f throughput.awk out.tr &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
