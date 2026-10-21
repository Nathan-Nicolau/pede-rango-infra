#!/usr/bin/env bash
set -e

CLUSTER_NAME="meu-cluster-local"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=========================================================="
echo "🏗️  [1/4] Verificando / Criando Cluster Kind '${CLUSTER_NAME}'..."
echo "=========================================================="
if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
    echo "✔ Cluster '${CLUSTER_NAME}' já existe. Pulando criação..."
else
    kind create cluster --name "${CLUSTER_NAME}" --config "${INFRA_DIR}/kind/kind-config.yaml"
fi

echo ""
echo "=========================================================="
echo "🌐 [2/4] Instalando Ingress NGINX Controller para Kind..."
echo "=========================================================="
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "⏳ Aguardando o pod do Ingress NGINX ficar pronto (Ready)..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

echo ""
echo "=========================================================="
echo "📊 [3/4] Instalando Metrics Server (Suporte a HPA)..."
echo "=========================================================="
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch -n kube-system deployment metrics-server --type=json \
  -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]' || true

echo ""
echo "=========================================================="
echo "⛵ [4/4] Instalando Helm Charts (API + DB + Web)..."
echo "=========================================================="
helm upgrade --install pede-rango-api "${INFRA_DIR}/charts/pede-rango-api"
helm upgrade --install pede-rango-web "${INFRA_DIR}/charts/pede-rango-web"

echo ""
echo "✅ Infraestrutura base provisionada com sucesso!"
echo "💡 Próximo passo: execute './scripts/deploy-all.sh' (ou 'deploy-rango') para compilar e carregar as imagens no cluster."
