# Create TCP/FTP connections between vehicles and RSUs (V2R communication)
set tcp [new Agent/TCP]
$ns attach-agent $node(0) $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $rsu(0) $sink
$ns connect $tcp $sink

# Create Application/FTP for V2R communication
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP
$ns at 1.0 "$ftp start"  ;# Schedule the FTP application to start at time 1.0

# Create vehicle-to-vehicle communication (V2V)
set tcp2 [new Agent/TCP]
$ns attach-agent $node(1) $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $node(2) $sink2
$ns connect $tcp2 $sink2

# Create Application/FTP for V2V communication
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP
$ns at 2.0 "$ftp2 start"  ;# Schedule the second FTP application to start at time 2.0
