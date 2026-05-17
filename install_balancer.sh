#!/bin/bash
# Amazon Linux 2023 - Balanceador HAProxy via Docker

sudo dnf update -y
sudo dnf install -y docker python3 python3-pip
sudo systemctl enable --now docker
pip3 install boto3

cat <<'GETTER' > /opt/get_parameter.py
import boto3
from botocore.exceptions import ClientError

def get_ssm_parameter(name: str, default: str = None) -> str:
    client = boto3.client("ssm", region_name="us-east-1")
    try:
        return client.get_parameter(Name=name)["Parameter"]["Value"]
    except ClientError as e:
        if e.response["Error"]["Code"] == "ParameterNotFound":
            return default
        raise

if __name__ == "__main__":
    api_ip = get_ssm_parameter("/iot/dev/api/public_ip", "localhost")
    print(f"API_IP={api_ip}")
GETTER

API_IP=$(python3 /opt/get_parameter.py 2>/dev/null | grep API_IP | cut -d= -f2)

sudo docker pull ${docker_user}/iot-balancer:latest
sudo docker run -d --restart=always --name balancer \
  -p 80:80 \
  -e API_IP="$${API_IP:-localhost}" \
  ${docker_user}/iot-balancer:latest
