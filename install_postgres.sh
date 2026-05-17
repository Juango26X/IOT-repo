#!/bin/bash
# Amazon Linux 2023 - Instalar PostgreSQL 15

sudo dnf update -y
sudo dnf install -y postgresql15-server

sudo postgresql-setup --initdb

sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf

echo "host    all             all             0.0.0.0/0               scram-sha-256" | sudo tee -a /var/lib/pgsql/data/pg_hba.conf

sudo systemctl enable postgresql
sudo systemctl start postgresql

# Crear BD y tablas igual que en el docker-compose (init.sql)
sudo -u postgres psql << SQL
ALTER USER postgres WITH PASSWORD 'postgres';
CREATE DATABASE orders_db OWNER postgres;
\c orders_db
CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY,
    operacion VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    payload JSONB,
    result JSONB,
    error TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SQL
