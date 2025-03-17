cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100- $1 } ')
echo "CPU USAGE: $cpu_usage%"

#check if cpu usage exceeds 70%
if (( $(echo "$cpu_usage >70" | bc -l) )); then
	echo  "CPU usage exceeded 70%, creating a new vm in gcp..."
	gcloud compute instances create assignment3-vm-$(date +%s) --project='my-project-453309' --zone=us-central1-a --machine-type=n1-standard-1 --image-project=ubuntu-os-cloud --image-family=ubuntu-2004-lts
fi
