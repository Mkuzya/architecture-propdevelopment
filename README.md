# PropDevelopment - Архитектурный проект

Проект по архитектуре и безопасности для компании PropDevelopment - крупной строительной компании, входящей в топ-3 застройщиков страны.

## Описание проекта

PropDevelopment предоставляет клиентам услуги, связанные с покупкой недвижимости и обслуживанием жилых комплексов. Компания работает с двумя категориями клиентов:
- **Клиенты** - потенциальные покупатели жилья
- **Собственники** - владельцы недвижимости, приобретенной у компании

## Структура проекта

Проект состоит из 5 заданий, каждое в отдельной директории:

- **Task1** - Разработка проверочного листа по безопасности данных
- **Task2** - Разработка и заполнение проверочного листа для бизнес-систем
- **Task3** - Внешние интеграции (Smart Home сервисы)
- **Task4** - Защита доступа к кластеру Kubernetes (RBAC)
- **Task5** - Управление трафиком внутри кластера Kubernetes (Network Policies)

---

## Task 1: Разработка проверочного листа по безопасности данных

### Цель
Разработать проверочный лист по безопасности данных для решения ключевой проблемы компании.

### Выполненные задачи
1. Анализ диаграммы и описания системы PropDevelopment
2. Классификация данных по стандартам ISO/IEC 27001 и 27002:
   - Публичные данные
   - Внутренние данные
   - Конфиденциальные данные
   - Секретные данные
3. Определение рисков для каждой категории данных
4. Оценка рисков (незначительный-значительный-критический)
5. Визуализация результатов в виде mindmap

### Файлы
- `data-security-mindmap.drawio` - диаграмма mindmap с анализом безопасности данных

---

## Task 2: Разработка и заполнение проверочного листа для бизнес-систем

### Цель
Составить проверочный лист безопасности для бизнес-систем компании.

### Выполненные задачи
1. Анализ схемы и описания системы
2. Идентификация систем и изучение их работы с точки зрения безопасности
3. Выбор разделов для проверочного листа на основе проблем компании
4. Оформление в виде Markdown-таблицы
5. Заполнение всех полей с достаточными данными

### Файлы
- security-checklist.md

---

## Task 3: Внешние интеграции

### Цель
Расширить бизнес-функции PropDevelopment за счет интеграции с партнерскими сервисами "Умный дом".

### Выполненные задачи
1. Подготовка диаграммы контекста в модели C4
2. Обновление диаграммы контейнеров PropDevelopment
3. Формирование списка требований для внешних интеграций:
   - Требования к безопасности
   - Протоколы аутентификации и авторизации
   - Организация взаимодействия между системами

### Интегрируемые сервисы
- **Интеллектуальный домофон** - с биометрическим распознаванием
- **Интеллектуальный шлагбаум** - с распознаванием номерных знаков

### Файлы
- `context-diagram-smart-home.drawio` - диаграмма контекста
- `container-diagram-smart-home.drawio` - обновленная диаграмма контейнеров
- `integration-requirements.md` - требования к интеграциям

---

## Task 4: Защита доступа к кластеру Kubernetes (RBAC)

### Цель
Организовать ролевой доступ к Kubernetes для пользователей кластера.

### Выполненные задачи
1. Поднятие пустого Minikube
2. Определение ролей и их полномочий
3. Создание скриптов для создания пользователей
4. Создание скриптов для создания ролей
5. Создание скриптов для связывания пользователей с ролями

### Роли
- **admin** - полный доступ к кластеру
- **developer** - доступ к разработке и деплою
- **monitoring** - доступ к мониторингу
- **viewer** - только просмотр ресурсов

### Файлы
- `roles-table.md` - таблица с описанием ролей
- `create-users.sh` - скрипт создания пользователей
- `create-roles.sh` - скрипт создания ролей
- `bind-roles.sh` - скрипт связывания пользователей с ролями

---

## Task 5: Управление трафиком внутри кластера Kubernetes

### Цель
Разграничить трафик между сервисами в кластере Kubernetes с помощью Network Policies.

### Выполненные задачи
1. Развертывание 4 сервисов Nginx в namespace `propdevelopment`
2. Назначение меток для сервисов:
   - `front-end`
   - `back-end-api`
   - `admin-front-end`
   - `admin-back-end-api`
3. Создание сетевых политик для bidirectional трафика
4. Применение политик и тестирование

### Сетевая архитектура
- **Разрешенный трафик**: `front-end` ↔ `back-end-api`, `admin-front-end` ↔ `admin-back-end-api`
- **Запрещенный трафик**: `front-end` ↔ `admin-back-end-api`, `admin-front-end` ↔ `back-end-api`, `front-end` ↔ `admin-front-end`, `back-end-api` ↔ `admin-back-end-api`

### Файлы
- `non-admin-api-allow.yaml` - файл с сетевыми политиками

---

## Команды для проверки Task 5

### Предварительные требования
- Установленный Minikube
- kubectl настроен для работы с Minikube

### 1. Создание namespace и развертывание сервисов

```bash
# Создать namespace
kubectl create namespace propdevelopment

# Развернуть сервисы с метками
kubectl run front-end-app --image=nginx --labels role=front-end --expose --port 80 -n propdevelopment
kubectl run back-end-api-app --image=nginx --labels role=back-end-api --expose --port 8080 -n propdevelopment
kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end --expose --port 80 -n propdevelopment
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api --expose --port 8080 -n propdevelopment
```

### 2. Применение сетевых политик

```bash
# Применить политики
kubectl apply -f Task5/non-admin-api-allow.yaml
```

### 3. Проверка статуса ресурсов

```bash
# Проверить поды
kubectl get pods -n propdevelopment

# Проверить сервисы
kubectl get services -n propdevelopment

# Проверить Network Policies
kubectl get networkpolicies -n propdevelopment
```

### 4. Тестирование трафика

#### Проверка разрешенного трафика (front-end → back-end-api)
```bash
kubectl run test-$(date +%s) --rm -i -t --image=alpine -n propdevelopment -- sh -c 'apk add --no-cache curl && curl -s --connect-timeout 2 http://front-end-app:80'
```

#### Проверка разрешенного трафика (admin-front-end → admin-back-end-api)
```bash
kubectl run test-$(date +%s) --rm -i -t --image=alpine -n propdevelopment -- sh -c 'apk add --no-cache curl && curl -s --connect-timeout 2 http://admin-front-end-app:80'
```

#### Проверка запрещенного трафика (front-end → admin-back-end-api)
```bash
kubectl run test-$(date +%s) --rm -i -t --image=alpine -n propdevelopment -- sh -c 'apk add --no-cache curl && curl -s --connect-timeout 2 http://admin-back-end-api-app:8080'
```

### 5. Очистка ресурсов

```bash
# Удалить все ресурсы
kubectl delete namespace propdevelopment
```
