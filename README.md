# Highly Available AWS 3-Tier Architecture:

This project is a classic, enterprise-grade network setup for a website. It is called a "3-Tier" architecture because it separates the website into three distinct layers: the public front-end, the private application servers, and the hidden database.

This setup is designed to be Highly Available (if a server crashes, the website stays online) and Highly Secure (hackers cannot reach the database directly). The entire network is built from scratch using Terraform.

# How It Works (The 3 Tiers):
 The Web Tier (Public):
When a user visits the website, they hit an Application Load Balancer (ALB). The load balancer's job is to distribute traffic evenly across multiple web servers. If one web server breaks, the load balancer stops sending people to it.

The Application Tier (Private):
This is where the actual code runs. These servers are placed in private subnets, meaning they do not have public IP addresses and cannot be accessed directly from the internet. They can only talk to the Load Balancer and the Database.

The Database Tier (Private):
This holds the website's data using Amazon RDS (Relational Database Service). It is locked down in the deepest part of the private network. Only the Application servers are allowed to talk to it.

Bonus: Auto Scaling & NAT Gateways

Auto Scaling: If the website gets a sudden spike in traffic, AWS will automatically create new servers to handle the load, and delete them when traffic goes back down.

NAT Gateway: Because our private servers don't have internet access, they use a NAT Gateway to safely reach out to the internet to download software updates without exposing themselves to incoming attacks.

 # Tech Stack Used :

 Infrastructure as code: Terraform

Networking: AWS VPC, Public/Private Subnets, Route Tables, NAT Gateways

Compute: Amazon EC2, Auto Scaling Groups, Application Load Balancer

Database: Amazon RDS (MySQL)

# How to Deploy :

Clone this repository.
 git clone [https://github.com/joshijay45/aws-multiaz-3-tier-architecture.git]

Run terraform init to set up your environment.

Run terraform apply -auto-approve to build the network.

Copy the Load Balancer's URL from the terminal output and paste it into your browser to see the live website!

Note: Run terraform destroy when finished to avoid NAT Gateway charges.