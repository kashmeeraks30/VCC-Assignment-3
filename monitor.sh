cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100- $1 } ')
echo "CPU USAGE: $cpu_usage%"

existing_vm=$(gcloud compute instances list --format="value(name)" | grep -w "assignment3-vm")

#check if cpu usage exceeds 75% and create a new vm if the utilization exceeds 75%
if (( $(echo "$cpu_usage >75" | bc -l) )); then
        if [[ -z "$existing_vm" ]]; then
        echo  "CPU usage exceeded 75%, creating a new vm in gcp..."
        gcloud compute instances create assignment3-vm --project='my-project-453309' --zone=us-central1-a --machine-type=n1-standard-1 --image-project=ubuntu>
        else
        echo "vm instance already running"
        fi
#check if cpu usage is less than 40% and delete the created vm if the utilization is less than 40%
elif (( $(echo "$cpu_usage <40" | bc -l) )); then
        if [[ -n "$existing_vm" ]]; then        
        gcloud compute instances delete assignment3-vm --zone=us-central1-a 
        else
        echo "No running vm instances available to delete."
        fi
fi


