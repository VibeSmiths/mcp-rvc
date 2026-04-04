#!/bin/sh
# Start RVC API server in background, then preload first available model

python3 -m rvc_python api -p 5050 -l --device cuda:0 &
RVC_PID=$!

# Wait for server to be ready
echo "Waiting for RVC API to start..."
for i in $(seq 1 60); do
  if curl -sf http://localhost:5050/models > /dev/null 2>&1; then
    echo "RVC API ready."
    break
  fi
  sleep 1
done

# Preload first available model
MODELS=$(curl -sf http://localhost:5050/models 2>/dev/null)
FIRST_MODEL=$(echo "$MODELS" | python3 -c "import sys,json; m=json.load(sys.stdin).get('models',[]); print(m[0] if m else '')" 2>/dev/null)

if [ -n "$FIRST_MODEL" ]; then
  echo "Preloading model: $FIRST_MODEL"
  curl -sf -X POST "http://localhost:5050/models/$(python3 -c "import urllib.parse; print(urllib.parse.quote('$FIRST_MODEL'))")" > /dev/null 2>&1
  echo "Model preloaded."
else
  echo "No models found to preload."
fi

# Wait for the server process
wait $RVC_PID
