#!/bin/sh

set -Eeuo pipefail

echo "Building the container image..."
podman build -t multi-cluster-app:latest .

echo "Running it..."
podman run -d --rm --name multi-cluster-app -p 8080:8080 multi-cluster-app:latest
trap "podman stop multi-cluster-app" EXIT

echo "Testing it..."
sleep 2
curl -s -o /dev/null -w "HTTP status code: %{http_code}\n"  http://localhost:8080/

echo "Pushing to Quay.io..."
podman tag multi-cluster-app:latest quay.io/nmasse_itix/multi-cluster-app:latest
podman push quay.io/nmasse_itix/multi-cluster-app:latest
