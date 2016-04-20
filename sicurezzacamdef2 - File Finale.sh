#direttiva per il kernel linux di creare il nodo per controllare gpio n 4
echo "4" > /sys/class/gpio/export
#imposta il gpio4 come input digitale
echo "in" > /sys/class/gpio/gpio4/direction

while true;  do
#controlla di disabilitare il gpio4 precedentemente configurato
 	trap 'echo "4" > /sys/class/gpio/unexport' 0
	stat=`cat /sys/class/gpio/gpio4/value`
	while [ $stat = "1" ]
	do
			d=`date +%d%m%y`
			t=`date +%T`
			raspistill -o $t$d.jpg -w 1024 -h 768 -q 30
			echo "MOVEMENT DETECTION " | mail -s “ATTENTCION” email@address.com
			echo "MOVEMENT DETECTION $t $d"
			echo "MOVEMENT DETECTION $t $d" >> /home/pi/log$d.txt
			
			
			mpack -s "ATTENCTION!" $t$d.jpg email@address.com
			raspivid -o $t$d.h264 -t 10000 
			
#Si invia tramite le api un messaggio sul channel #random di slack, il quale è identificato tramite un webhook (url finale), vengono passati i parametri, come username, testo, icona, tutti in formato JSON
			
#curl -X POST --data-urlencode 'payload={"token”:”TOKEN API OF SLACK“,”channel": #random","username": “yourusername”,”text": "This is just for veryfing the Send Message Api ","icon_emoji": ":ghost:"}' WEBHOOK OF SLACK API JUST SEPARATE WITH A SPACE 



			stat="0"
			sleep 5
	done
done
exit 0
