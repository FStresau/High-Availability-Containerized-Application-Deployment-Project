#!/bin/bash

# Configuration parameters
SERVICE_NAME="myapp_app"
MIN_REPLICAS=3
MAX_REPLICAS=6
SCALE_UP_THRESHOLD=40.0      # if average CPU > 30%, scale up
SCALE_DOWN_THRESHOLD=20.0    # if average CPU < 15%, scale down

# Loop indefinitely
while true; do
    # Initialize sum and count
    cpu_usage_sum=0
    container_count=0
  
    # Get container IDs for the service (using the service name filter)
    container_ids=$(docker ps --filter "name=${SERVICE_NAME}" --format "{{.ID}}")
  
    # For each container, get the CPU usage percentage
    for cid in $container_ids; do
        # Get CPU usage (removing the "%" sign)
        cpu=$(docker stats $cid --no-stream --format "{{.CPUPerc}}" | sed 's/%//g')
        cpu_usage_sum=$(echo "$cpu_usage_sum + $cpu" | bc)
        container_count=$((container_count + 1))
    done
  
    # Calculate average CPU usage, if any containers are running
    if [ "$container_count" -gt 0 ]; then
        avg_cpu=$(echo "scale=2; $cpu_usage_sum / $container_count" | bc)
    else
        avg_cpu=0
    fi
  
    echo "Average CPU usage: ${avg_cpu}%"
  
    # Get the current replica count for the service
    current_replicas=$(docker service ls --filter "name=${SERVICE_NAME}" --format "{{.Replicas}}" | cut -d'/' -f1)
    # If no replicas found, fall back to the minimum
    if [ -z "$current_replicas" ]; then
        current_replicas=$MIN_REPLICAS
    fi
  
    echo "Current replicas: $current_replicas"
  
    new_replicas=$current_replicas
  
    # Check if we need to scale up
    if (( $(echo "$avg_cpu > $SCALE_UP_THRESHOLD" | bc -l) )); then
        if [ $current_replicas -lt $MAX_REPLICAS ]; then
            new_replicas=$((current_replicas + 1))
            echo "CPU usage high. Scaling up..."
        fi
    # Check if we need to scale down  
    elif (( $(echo "$avg_cpu < $SCALE_DOWN_THRESHOLD" | bc -l) )); then
        if [ $current_replicas -gt $MIN_REPLICAS ]; then
            new_replicas=$((current_replicas - 1))
            echo "CPU usage low. Scaling down..."
        fi
    fi
  
    # Apply scaling if there's a change in replica count
    if [ $new_replicas -ne $current_replicas ]; then
        echo "Scaling service $SERVICE_NAME to $new_replicas replicas"
        docker service scale ${SERVICE_NAME}=$new_replicas
    else
        echo "No scaling action required."
    fi
  
    # Wait for 20 seconds before checking again (adjust as needed)
    sleep 20
done

