# NVIDIA GPU Monitoring & Jupyter Docker Stack

## Co obsahuje tento Docker stack?
- **Jupyter Lab** (Python, TensorFlow, Data Science)
- **Prometheus** (sběr metrik)
- **nvidia-gpu-exporter** (export metrik z GPU)
- **Grafana** (vizualizace metrik a dashboardy)

## Verze softwaru
- **Ubuntu**: 24.04
- **CUDA**: 12.6.2 (cuDNN devel)
- **TensorFlow**: 2.18.* (s CUDA podporou)
- **TensorFlow Probability**: 0.24.*
- **Python**: 3.12

## Nainstalované Python knihovny
### Data Science & ML Core
- **numpy, scipy, pandas** - základní vědecké výpočty
- **matplotlib, seaborn** - vizualizace dat
- **scikit-learn** - machine learning algoritmy
- **torch (PyTorch)** - deep learning framework
- **gymnasium** - reinforcement learning prostředí

### Finance & Trading
- **yfinance** - finanční data z Yahoo Finance
- **TA-Lib** - technická analýza

### Monitoring & Development
- **nvitop** - monitoring NVIDIA GPU
- **wandb** - experiment tracking
- **tensorboard** - TensorFlow vizualizace
- **fastapi, uvicorn** - REST API vývoj

### Jupyter & Notebooks
- **jupyterlab, notebook** - interaktivní prostředí
- **ipywidgets** - interaktivní widgety

## Jak vytvořit a spustit

1. **Build & start** (v root složce projektu):
   ```bash
   docker compose up -d
   ```
   (Pokud je potřeba rebuild, použij: `docker compose build`)

2. **Zastavení**:
   ```bash
   docker compose down
   ```

## Popis služeb & přístupové body

| Služba                | URL                       | Popis                       |
|-----------------------|---------------------------|-----------------------------|
| Jupyter Lab           | http://localhost:8888     | Interaktivní Python prostředí|
| Grafana               | http://localhost:3000     | Dashboardy, vizualizace     |
| Prometheus            | http://localhost:9090     | Sběr metrik                 |
| NVIDIA GPU Exporter   | http://localhost:9835     | Metriky z GPU pro Prometheus |

- **Grafana login:** admin / admin
- **Import dashboardu:** ID 14574 (NVIDIA GPU Metrics)
- **Prometheus data source:** URL `http://prometheus:9090`

## Docker komponenty a architektura
- **tf-cuda kontejner**: Hlavní pracovní prostředí s Jupyter Lab
- **prometheus kontejner**: Sběr a ukládání metrik
- **grafana kontejner**: Vizualizace metrik, dashboardy
- **nvidia-gpu-exporter kontejner**: Export GPU metrik pro Prometheus
- **monitoring síť**: Propojuje všechny služby
- **persistentní volumes**: `prometheus_data`, `grafana_data`

## Poznámky
- Workspace je mountován do `/workspace` v kontejneru
- Supervisord.conf je mountován pro dynamickou konfiguraci Jupyter
- Všechny služby běží na localhost, porty lze upravit v `docker-compose.yml`
- Pro TensorFlow/GPU je potřeba NVIDIA hardware a ovladače
- Kontejnery běží jako root pro přístup k NVIDIA runtime
- GPU monitoring funguje díky nvidia-gpu-exporter v1.2.0

---
V případě dotazů nebo problémů kontaktujte správce projektu.



Nejlepe se mi prozatim pro beh dockeru s funkcni gpu (RTX 3050 Laptop) osvedcila kombinace : 
Ubuntu 24.04.3 LTS + nvidia-driver-570-open + nvidia-container-toolkit + docker-ce (bez docker-desktop)
