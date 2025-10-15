# NVIDIA GPU Monitoring & Jupyter Docker Stack

## Co obsahuje tento Docker stack?
- **Jupyter Lab** (Python, TensorFlow, Data Science)
- **Prometheus** (sběr metrik)
- **nvidia-gpu-exporter** (export metrik z GPU)
- **Grafana** (vizualizace metrik)

## Verze softwaru
- **Ubuntu**: 24.04
- **CUDA**: 12.6.2 (cuDNN devel)
- **TensorFlow**: 2.18.* (s CUDA podporou)
- **Python**: 3.12

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

## Poznámky
- Workspace je mountován do `/workspace` v kontejneru.
- Všechny služby běží na localhost, porty lze upravit v `docker-compose.yml`.
- Pro TensorFlow/GPU je potřeba NVIDIA hardware a ovladače.

---
V případě dotazů nebo problémů kontaktujte správce projektu.
