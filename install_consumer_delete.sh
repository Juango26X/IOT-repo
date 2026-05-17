#!/bin/bash
# Amazon Linux 2023 - Consumer DELETE via Docker

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
    db_host = get_ssm_parameter("/iot/dev/postgres/public_ip", "localhost")
    mq_host = get_ssm_parameter("/iot/dev/rabbitmq/public_ip", "localhost")
    print(f"DB_HOST={db_host}")
    print(f"MQ_HOST={mq_host}")
GETTER

DB_HOST=$(python3 /opt/get_parameter.py 2>/dev/null | grep DB_HOST | cut -d= -f2)
MQ_HOST=$(python3 /opt/get_parameter.py 2>/dev/null | grep MQ_HOST | cut -d= -f2)

sudo docker pull ${docker_user}/iot-worker-delete:latest
sudo docker run -d --restart=always --name worker_delete \
  -e DB_HOST="$${DB_HOST}" \
  -e DB_PORT=5432 \
  -e DB_NAME=orders_db \
  -e DB_USER=postgres \
  -e DB_PASSWORD=postgres \
  -e RABBITMQ_HOST="$${MQ_HOST}" \
  -e RABBITMQ_PORT=5672 \
  -e RABBITMQ_USER=admin \
  -e RABBITMQ_PASSWORD=password123 \
  ${docker_user}/iot-worker-delete:latest
