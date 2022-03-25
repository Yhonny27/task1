#!/bin/bash
a=100
b=0
frequency1=60
frequency2=300
filename=message

#Recuperar/Obtener mensaje del Topic (enviado por el Cloud Scheduler)
sleep $frequency1;
until [ $a -lt $b ]; do
gcloud pubsub subscriptions pull subscription_task1 --format=json
        for pubsub in $(gcloud pubsub subscriptions pull subscription_task1 --format=json)
        do
        sudo touch $filename.json && echo $pubsub >> $filename.json
        mv $filename.json /
        done
gsutil cp /$filename.json gs://bucket22_task1/
sleep  $frequency2;
let  b=$b+1
done
