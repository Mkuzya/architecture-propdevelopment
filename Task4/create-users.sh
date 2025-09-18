#!/bin/bash

# Скрипт для создания пользователей Kubernetes
# PropDevelopment - Создание пользователей для RBAC

set -e

echo "=== Создание пользователей Kubernetes для PropDevelopment ==="

# Создание директории для сертификатов
mkdir -p certs

# Функция для создания пользователя
create_user() {
    local username=$1
    local group=$2
    local namespace=$3
    
    echo "Создание пользователя: $username"
    
    # Создание приватного ключа
    openssl genrsa -out certs/${username}.key 2048
    
    # Создание CSR (Certificate Signing Request)
    openssl req -new -key certs/${username}.key -out certs/${username}.csr -subj "/CN=${username}/O=${group}"
    
    # Создание сертификата (самоподписанный для демонстрации)
    openssl x509 -req -in certs/${username}.csr -signkey certs/${username}.key -out certs/${username}.crt -days 365
    
    # Создание kubeconfig для пользователя
    kubectl config set-credentials ${username} \
        --client-certificate=certs/${username}.crt \
        --client-key=certs/${username}.key \
        --embed-certs=true
    
    # Установка контекста
    kubectl config set-context ${username}-context \
        --cluster=minikube \
        --user=${username} \
        --namespace=${namespace}
    
    echo "Пользователь $username создан успешно"
}

# Создание namespace'ов
echo "Создание namespace'ов..."
kubectl create namespace propdevelopment --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace client-services --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace hku-services --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace finance-services --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace data-services --dry-run=client -o yaml | kubectl apply -f -

# DevOps команда (cluster-admin)
echo "=== Создание DevOps команды ==="
create_user "devops-1" "devops-team" "default"
create_user "devops-2" "devops-team" "default"
create_user "security-admin" "devops-team" "default"

# PropDevelopment команда (namespace-admin)
echo "=== Создание PropDevelopment команды ==="
create_user "team-lead-1" "propdev-team" "propdevelopment"
create_user "senior-dev-1" "propdev-team" "propdevelopment"

# Client Services команда (developer)
echo "=== Создание Client Services команды ==="
create_user "dev-1" "client-team" "client-services"
create_user "dev-2" "client-team" "client-services"
create_user "qa-1" "client-team" "client-services"

# HKU Services команда (developer)
echo "=== Создание HKU Services команды ==="
create_user "dev-3" "hku-team" "hku-services"
create_user "dev-4" "hku-team" "hku-services"
create_user "qa-2" "hku-team" "hku-services"

# Finance Services команда (developer)
echo "=== Создание Finance Services команды ==="
create_user "dev-5" "finance-team" "finance-services"
create_user "qa-3" "finance-team" "finance-services"

# Data Services команда (developer)
echo "=== Создание Data Services команды ==="
create_user "dev-6" "data-team" "data-services"
create_user "qa-4" "data-team" "data-services"

# Monitoring команда (monitoring)
echo "=== Создание Monitoring команды ==="
create_user "sre-1" "monitoring-team" "default"
create_user "sre-2" "monitoring-team" "default"

# Management (viewer)
echo "=== Создание Management команды ==="
create_user "manager-1" "management" "default"
create_user "manager-2" "management" "default"

# Security Audit (security-auditor)
echo "=== Создание Security Audit команды ==="
create_user "auditor-1" "security-audit" "default"

echo "=== Все пользователи созданы успешно ==="
echo "Сертификаты сохранены в директории: certs/"
echo ""
echo "Для переключения на пользователя используйте:"
echo "kubectl config use-context <username>-context"
echo ""
echo "Примеры:"
echo "kubectl config use-context devops-1-context"
echo "kubectl config use-context dev-1-context"
echo "kubectl config use-context manager-1-context"
