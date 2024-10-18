# PERFORMANCE EVALUATION 
BEGIN {
      packetsSent=0;
      packetsReceived=0;
}

{
      if($1=="s") {
	      packetsSent++;
      }

      else if($1=="r") {
      	packetsReceived++;
      }
}

END {
      printf("Total Number of Packets sent : %d\n", packetsSent);
      printf("Total Number of Packets Recieved : %d\n",packetsReceived);

      printf("Packet Delivery Ratio, PDR : %f", (packetsReceived/packetsSent)*100);
}

BEGIN {
      packNum = 0;
      totalNumOfBytes = 0;
}

{
      if($1=="s" && $4=="RTR"  && $7=="AODV") {
            packNum ++;
            totalNumOfBytes+=$8; 
      }

      if($1=="f" && $4=="RTR" && $7=="AODV") { 
            packNum ++;
            totalNumOfBytes+=$8;
      }
}                                          	

END {
      print(packNum, totalNumOfBytes);
}


# Packet Loss Ratio
BEGIN{ 
      dropped=0;
      packetsReceived=0;
      packetsSent=0;
}

{
      if($1=="s" && ($4=="AGT"||$4=="MAC")) {
            packetsSent++;
}

      else if($1=="D") {
            dropped++;
      }
}

END {
      printf("Total Number of Packets Dropped : %d\n",dropped);
      printf("Packet Loss Ratio : %f\n",(dropped/packetsSent)*100);
}


# Throughput
BEGIN {

      recvSize= 0
      beginn= 400
      endd= 0
}
  
{
      if (($4 == "AGT" || $4 == "IFQ") && ($1 == "s") && $8 >= 512) {
            
            if ($2 < beginn) {
                  beginn= $2
            }
      }

      if (($4 == "AGT" || $4 == "IFQ") && ($1 == "r") && $8 >= 512) {
            
            if ($2 > endd) {
                  endd= $2
            }

            recvSize+= $8
      }
}

END {
      printf("Simulation Start Time : %.2f\n", beginn)
      printf("Simulation stop time : %.2f\n", endd)
      printf("The Throughput = %.2f kbps\n",(recvSize/(endd-beginn))*(8/1000))
	printf "The Transmission Rate : %f\n", (((100 - ((dropped/packetsSent)*100)) * packetsSent) / endd) 
	printf ("Efficiency : %f\n", (100 -( (endd - beginn) / (((100 - ((dropped/packetsSent)*100)) * packetsSent) / (endd - beginn)))))
}