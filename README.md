# High Availability Containerized Application Deployment

A fault-tolerant, scalable, and secure multi-tier web application deployed on Google Cloud Platform (GCP) using Docker Swarm.  
This project demonstrates best practices in system administration, automation, and cloud deployment with a focus on resilience, scalability, and data integrity.

---

## 📌 Project Overview

This project deploys a Flask-based web application backed by a PostgreSQL database, with Nginx acting as a reverse proxy and load balancer.  
The system automatically scales based on CPU usage, ensures high availability during failures, and preserves all data through persistent storage.

### Key Features

- **High Availability** – Multiple replicas with automatic recovery on failure.  
- **Load Balancing** – Even traffic distribution with Nginx in a dedicated container.  
- **Auto Scaling** – Custom Bash script dynamically adjusts replicas (3–6) based on CPU thresholds.  
- **Persistent Storage** – PostgreSQL database backed by Docker volumes + Linux LVM.  
- **Secure Secrets Management** – Docker secrets used for database credentials.  
- **Cloud Deployment** – Hosted on GCP Compute Engine with external access.

---

## 🛠️ Architecture
Client
│
▼
Nginx Reverse Proxy & Load Balancer
│
├── Flask Application (3–6 replicas)
│ └── Connects securely to PostgreSQL
│
▼
PostgreSQL Database (Persistent Storage via Docker Volumes + LVM)


### Technologies Used

- **Cloud:** Google Cloud Platform (GCP)  
- **Orchestration:** Docker Swarm  
- **Web Framework:** Flask (Python)  
- **Database:** PostgreSQL  
- **Load Balancer:** Nginx  
- **Automation:** Bash, systemd  
- **Storage:** Linux LVM, Docker Volumes  
- **Security:** Docker Secrets  

---

## ⚡ Features in Action

- **Automatic Recovery** – If a container fails, Docker Swarm reschedules it instantly.  
- **Resource Efficiency** – Scaling script adds or removes replicas based on CPU load.  
- **Data Safety** – Persistent volumes ensure no data loss during redeployment or restart.  
- **Real-World Testing** – Simulated failures and ApacheBench load testing to measure resilience.

---

## 🚀 Deployment Instructions

1. **Clone the Repository**

```bash
git clone https://github.com/FStresau/High-Availability-Containerized-Application-Deployment-Project.git
cd High-Availability-Containerized-Application-Deployment-Project

echo "your_db_password" | docker secret create postgres_password -

docker swarm init
docker stack deploy -c docker-stack.yml ha_app

chmod +x autoscale.sh
sudo systemctl enable autoscale.service
sudo systemctl start autoscale.service
```

📊 Testing & Results
Uptime: 100% during simulated container failures.

Scalability: Automatically scaled from 3 to 6 replicas during load tests.

Performance: Majority of HTTP requests completed under 2 seconds in ApacheBench stress test.

Data Integrity: PostgreSQL persistent volumes retained full dataset across restarts.

👥 Team
Name	Role
Frederic Stresau	Project Lead
Quy Pham	Application Deployment Lead
Jackson Harper	Data Management Lead
Simon Chummar	Infrastructure & Automation Lead

📈 Future Improvements
Containerize the auto-scaling script for easier integration.

Add user authentication to the web application.

Implement analytics dashboard for usage monitoring.





