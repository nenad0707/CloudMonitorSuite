# 🌩️ CloudMonitorSuite - Azure Monitoring Solution for MovieCraft

![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat&logo=microsoftazure&logoColor=white)
![KQL](https://img.shields.io/badge/KQL-Query-Orange?style=flat&logo=code&logoColor=white)
![Bicep](https://img.shields.io/badge/Bicep-Declarative-5C2D91?style=flat&logo=azure&logoColor=white)
![AppInsights](https://img.shields.io/badge/Application%20Insights-Monitoring-blueviolet?style=flat&logo=azuredevops&logoColor=white)

**CloudMonitorSuite** is a **cloud monitoring and observability project** built for tracking, analyzing, and troubleshooting the behavior of the **MovieCraft application**.  
This solution leverages **Azure Application Insights**, **Log Analytics**, **Azure Workbooks**, and **Kusto Query Language (KQL)** to provide real-time telemetry, performance monitoring, and diagnostics for cloud-based applications.

---

## 📖 Table of Contents

- [🌩️ CloudMonitorSuite - Azure Monitoring Solution for MovieCraft](#️-cloudmonitorsuite---azure-monitoring-solution-for-moviecraft)
  - [📖 Table of Contents](#-table-of-contents)
  - [📚 Project Overview](#-project-overview)
  - [🛠️ Tech Stack \& Tools](#️-tech-stack--tools)
  - [📊 Monitoring Architecture](#-monitoring-architecture)
  - [🔍 Key Metrics \& Queries](#-key-metrics--queries)
  - [📈 Azure Workbook Dashboard](#-azure-workbook-dashboard)
  - [📂 KQL Queries](#-kql-queries)
  - [🚀 Deployment \& Cost Optimization](#-deployment--cost-optimization)
  - [📄 License](#-license)

---

## 📚 Project Overview

**CloudMonitorSuite** provides a fully automated Azure monitoring solution that tracks key metrics and behaviors for the **MovieCraft application**, even though the application is hosted externally on **SmarterASP.NET**. Telemetry is ingested via **Application Insights SDK**, allowing centralized observability over API performance, SQL dependencies, failed requests, and application exceptions.

This project was built to demonstrate **Designated Responsible Individual (DRI)** concepts, advanced monitoring, and cloud-first observability strategies.

---

## 🛠️ Tech Stack & Tools

- **Azure Application Insights**: Real-time telemetry and metrics.
- **Azure Log Analytics**: Centralized logging workspace.
- **Azure Workbooks**: Custom dashboards for live metrics.
- **Kusto Query Language (KQL)**: Advanced log queries.
- **Azure Bicep**: Infrastructure-as-Code for automated deployments.
- **GitHub Actions**: CI/CD pipelines for infrastructure deployment.
- **MovieCraft App**: Source of telemetry data.

---

## 📊 Monitoring Architecture

CloudMonitorSuite architecture consists of:

- ✅ Application Insights instance (`cloudMonitor-ai`)
- ✅ Log Analytics Workspace (`cloudMonitor-log`)
- ✅ Smart Detection and Anomaly Rules
- ✅ Custom Workbooks Dashboard
- ✅ Linked external MovieCraft application as telemetry source

![Architecture](docs/architecture-diagram.png)

---

## 🔍 Key Metrics & Queries

The monitoring solution tracks:

- Total requests and request trends
- Failure rates and failed endpoints
- Average response times
- Dependency response times (SQL, external APIs)
- Top 10 exceptions
- Most frequent warning/error logs

All queries are fully written in **KQL**, and stored under the [`/kql-queries`](./kql-queries) folder.

---

## 📈 Azure Workbook Dashboard

The following image represents the core monitoring dashboard built using Azure Workbooks:

![Workbook Dashboard](docs/azure-workbook.png)

The dashboard is structured into:

- **Summary Tiles** (Total Requests, Failures, Response Times)
- **Performance Charts** (Requests per Hour, Slowest Endpoints)
- **Dependency Charts** (Database & External APIs)
- **Errors & Exceptions** (Last 10 Exceptions, Top Warnings)

---

## 📂 KQL Queries

All Kusto Query Language queries used in this monitoring solution are available in the [KQL Queries folder](./kql-queries):

- `total-requests.kql`
- `failure-rate.kql`
- `average-response-time.kql`
- `requests-per-hour.kql`
- `slowest-endpoints.kql`
- `dependency-performance.kql`
- `exceptions.kql`
- `warning-error-logs.kql`

---

## 🚀 Deployment & Cost Optimization

This solution is fully deployed via **Azure Bicep** and automated through **GitHub Actions CI/CD**.  
To avoid any unnecessary Azure cost, this deployment operates under **free tier usage limits** for demo and educational purposes.

> No additional Azure cost is generated for demo deployment.

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE.txt](LICENSE.txt) file for details.

---

**CloudMonitorSuite demonstrates practical cloud monitoring, observability, and diagnostic capabilities on a real-world project using Azure-native tools.**
