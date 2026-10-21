#!/usr/bin/env bash
set -e

CLUSTER_NAME="meu-cluster-local"

echo "=========================================================="
echo "🗑️  Removendo cluster Kind '${CLUSTER_NAME}'..."
echo "=========================================================="
kind delete cluster --name "${CLUSTER_NAME}"
echo "✔ Cluster '${CLUSTER_NAME}' removido com sucesso!"
