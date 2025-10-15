FROM nvidia/cuda:12.6.2-cudnn-devel-ubuntu24.04

# Noninteractive APT
ENV DEBIAN_FRONTEND=noninteractive

# Base tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget git vim nano tzdata \
    python3 python3-pip python3-venv python3-dev build-essential \
    libssl-dev libffi-dev pkg-config \
    mc supervisor \
    && rm -rf /var/lib/apt/lists/*

# Configure pip for better download performance
RUN pip config set global.timeout 300 && \
    pip config set global.retries 5 && \
    pip config set global.index-url https://pypi.org/simple/

# Skip pip upgrade (system packages already installed)
# RUN python3 -m pip install --upgrade pip wheel setuptools --break-system-packages

# TensorFlow with CUDA support (pip wheels for cu12) - split into smaller chunks
RUN pip install --no-cache-dir --timeout 300 --retries 5 \
    "tensorflow[and-cuda]==2.18.*" --break-system-packages

RUN pip install --no-cache-dir --timeout 300 --retries 5 \
    "tensorflow-probability~=0.24" --break-system-packages

# JupyterLab and data science stack
RUN pip install --no-cache-dir --timeout 300 --retries 5 \
    jupyterlab notebook ipywidgets \
    numpy scipy pandas matplotlib seaborn scikit-learn \
    tensorboard tensorboard-plugin-profile --break-system-packages

# nvitop and additional dependencies
RUN pip install --no-cache-dir --timeout 300 --retries 5 \
    nvitop fastapi uvicorn --break-system-packages

# Create workspace directory (image will run as root)
RUN mkdir -p /workspace
WORKDIR /workspace
WORKDIR /workspace

# Expose ports: Jupyter 8888, nvitop-exporter 9000
EXPOSE 8888 8889 9000

# Copy entrypoint and supervisor config
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod +x /usr/local/bin/entrypoint.sh


ENV JUPYTER_PORT=8888

# Install development/runtime pip packages at build time so they are available system-wide
RUN pip install --no-cache-dir --timeout 300 --retries 5 \
    yfinance matplotlib pandas --break-system-packages || true

# Ensure system site-packages are visible even inside venvs and Jupyter kernels
RUN python3 - <<'PY'
import site, os
try:
    sys_paths = site.getsitepackages()
except Exception:
    sys_paths = []
target = None
if sys_paths:
    target = sys_paths[0]
else:
    # fallback
    target = os.path.join(os.path.dirname(site.__file__), 'site-packages')
pth = os.path.join(target, 'sitecustomize.py')
os.makedirs(target, exist_ok=True)
content = '''import sys, site
try:
    system_sites = site.getsitepackages()
except Exception:
    system_sites = []
for p in system_sites:
    if p not in sys.path:
        sys.path.append(p)
'''
open(pth, 'w').write(content)
print('wrote', pth)
PY

USER root
# Final entrypoint (run as root)
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
