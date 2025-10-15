#!/usr/bin/env bash
set -euo pipefail

# Ensure NVIDIA runtime env vars
export NVIDIA_VISIBLE_DEVICES=all
export NVIDIA_DRIVER_CAPABILITIES=all

# Run a quick, non-interactive TensorFlow check in /workspace as root (do not fail startup on error)
echo "[entrypoint] Running TensorFlow quick check"
cd /workspace || true
python3 - <<'PY' || true
import sys
try:
	import tensorflow as tf
	print("TensorFlow version:", tf.__version__)
	print("GPU available:", tf.config.list_physical_devices('GPU'))
except Exception as e:
	print("TensorFlow check failed:", e, file=sys.stderr)
	# continue startup even if TF check fails
PY

# Start supervisord to run Jupyter
echo "[entrypoint] Starting supervisord"
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf


