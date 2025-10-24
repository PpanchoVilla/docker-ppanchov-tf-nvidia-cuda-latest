# NVIDIA GPU Monitoring & Jupyter Docker Stack

## What does this Docker stack contain?
- **Jupyter Lab** (Python, TensorFlow, Data Science)
- **Prometheus** (metrics collection)
- **nvidia-gpu-exporter** (metrics export from GPU)
- **Grafana** (metrics visualization and dashboards)

## Software Versions
- **Ubuntu**: 24.04
- **CUDA**: 12.6.2 (cuDNN devel)
- **TensorFlow**: 2.18.* (with CUDA support)
- **TensorFlow Probability**: 0.24.*
- **Python**: 3.12

## Installed Python Libraries
### Data Science & ML Core
- **numpy, scipy, pandas** - basic scientific computing
- **matplotlib, seaborn** - data visualization
- **scikit-learn** - machine learning algorithms
- **torch (PyTorch)** - deep learning framework
- **gymnasium** - reinforcement learning environment

### Finance & Trading
- **yfinance** - financial data from Yahoo Finance
- **TA-Lib** - technical analysis

### Monitoring & Development
- **nvitop** - NVIDIA GPU monitoring
- **wandb** - experiment tracking
- **tensorboard** - TensorFlow visualization
- **fastapi, uvicorn** - REST API development

### Jupyter & Notebooks
- **jupyterlab, notebook** - interactive environment
- **ipywidgets** - interactive widgets

## How to build and run

1. **Build & start** (in the root of the project):
```bash
docker compose up -d
```
(If a rebuild is needed, use: `docker compose build`)

2. **Stop**:
```bash
docker compose down
```

## Service description & access points

| Service | URL | Description |
|--------------------|-------------------------------|--------------------------|
| Jupyter Lab | http://localhost:8888 | Interactive Python Environment|
| Grafana | http://localhost:3000 | Dashboards, Visualizations |
| Prometheus | http://localhost:9090 | Metrics Collection |
| NVIDIA GPU Exporter | http://localhost:9835 | GPU Metrics for Prometheus |

- **Grafana login:** admin / admin
- **Dashboard import:** ID 14574 (NVIDIA GPU Metrics)
- **Prometheus data source:** URL `http://prometheus:9090`

## Docker components and architecture
- **tf-cuda container**: Main workspace with Jupyter Lab
- **prometheus container**: Metric collection and storage
- **grafana container**: Metric visualization, dashboards
- **nvidia-gpu-exporter container**: GPU metrics export for Prometheus
- **monitoring network**: Connects all services
- **persistent volumes**: `prometheus_data`, `grafana_data`

## Notes
- Workspace is mounted to `/workspace` in the container
- Supervisord.conf is mounted for dynamic Jupyter configuration
- All services run on localhost, ports can be edited in `docker-compose.yml`
- NVIDIA hardware and drivers are required for TensorFlow/GPU
- Containers are running as root to access NVIDIA runtime
- GPU monitoring works thanks to nvidia-gpu-exporter v1.2.0

---
For questions or problems, please contact the project manager.

So far, the combination that has worked best for me to run docker with a working gpu (RTX 3050 Laptop) is:
Ubuntu 24.04.3 LTS + nvidia-driver-570-open + nvidia-container-toolkit + docker-ce (without docker-desktop)

Pro importovani systemovych python balicku do venv : "python3 -m venv --system-site-packages my_project_venv"
Pro instalovani python balicku do systemu : "pip install xyz --break-system-packages"