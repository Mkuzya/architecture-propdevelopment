# Таблица ролей и полномочий Kubernetes для PropDevelopment

## Роли и их полномочия

| Роль | Права роли | Группы пользователей |
|------|------------|---------------------|
| **cluster-admin** | • Полный доступ ко всем ресурсам кластера<br>• Управление узлами<br>• Управление namespace<br>• Доступ к секретам<br>• Управление RBAC | DevOps-инженеры<br>Специалист по ИБ |
| **namespace-admin** | • Полный доступ к namespace<br>• Управление подами<br>• Управление сервисами<br>• Доступ к секретам в namespace<br>• Управление ConfigMaps | Team Leads<br>Senior разработчики |
| **developer** | • Создание/удаление подов<br>• Просмотр логов<br>• Доступ к сервисам<br>• Управление ConfigMaps<br>• НЕ доступ к секретам | Разработчики<br>QA инженеры |
| **viewer** | • Только чтение ресурсов<br>• Просмотр подов<br>• Просмотр сервисов<br>• Просмотр логов<br>• НЕ доступ к секретам | Аналитики<br>Менеджеры проектов |
| **monitoring** | • Просмотр метрик<br>• Доступ к Prometheus<br>• Просмотр логов<br>• Создание алертов<br>• НЕ доступ к секретам | SRE инженеры<br>Мониторинг команда |
| **security-auditor** | • Просмотр всех ресурсов<br>• Доступ к секретам (только чтение)<br>• Просмотр RBAC<br>• Аудит логов<br>• НЕ возможность изменений | Специалист по ИБ<br>Аудиторы |

## Детализация полномочий

### cluster-admin
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-admin
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
- nonResourceURLs: ["*"]
  verbs: ["*"]
```

### namespace-admin
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: namespace-admin
rules:
- apiGroups: [""]
  resources: ["pods", "services", "secrets", "configmaps", "persistentvolumeclaims"]
  verbs: ["*"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets"]
  verbs: ["*"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses", "networkpolicies"]
  verbs: ["*"]
```

### developer
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "persistentvolumeclaims"]
  verbs: ["get", "list", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "create", "update", "patch", "delete"]
```

### viewer
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: viewer
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "persistentvolumeclaims"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list"]
```

### monitoring
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: monitoring
rules:
- apiGroups: [""]
  resources: ["pods", "services", "nodes"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["metrics.k8s.io"]
  resources: ["*"]
  verbs: ["get", "list"]
- apiGroups: ["monitoring.coreos.com"]
  resources: ["*"]
  verbs: ["get", "list", "create", "update", "patch"]
```

### security-auditor
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: security-auditor
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
```

## Группы пользователей

| Группа | Пользователи | Роли | Namespace |
|--------|--------------|------|-----------|
| **devops-team** | devops-1, devops-2, security-admin | cluster-admin | Все |
| **propdev-team** | team-lead-1, senior-dev-1 | namespace-admin | propdevelopment |
| **client-team** | dev-1, dev-2, qa-1 | developer | client-services |
| **hku-team** | dev-3, dev-4, qa-2 | developer | hku-services |
| **finance-team** | dev-5, qa-3 | developer | finance-services |
| **data-team** | dev-6, qa-4 | developer | data-services |
| **monitoring-team** | sre-1, sre-2 | monitoring | Все |
| **management** | manager-1, manager-2 | viewer | Все |
| **security-audit** | auditor-1, security-admin | security-auditor | Все |

## Принципы безопасности

1. **Принцип минимальных привилегий** - пользователи получают только необходимые права
2. **Разделение обязанностей** - разные роли для разных функций
3. **Регулярный аудит** - проверка прав доступа каждые 3 месяца
4. **Временные права** - выдача временных прав для специальных задач
5. **Логирование** - запись всех действий пользователей
