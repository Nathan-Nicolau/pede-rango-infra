#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETOS_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
API_DIR="${PROJETOS_DIR}/pede-rango-api"
WEB_DIR="${PROJETOS_DIR}/pede-rango-web"

echo "=========================================================="
echo "🚀 [1/2] Deploy Local Backend: pede-rango-api"
echo "=========================================================="
(cd "${API_DIR}" && ./deploy-local.sh)

echo ""
echo "=========================================================="
echo "🚀 [2/2] Deploy Local Frontend: pede-rango-web"
echo "=========================================================="
(cd "${WEB_DIR}" && ./deploy-local.sh)

echo ""
echo "=========================================================="
echo "✅ Ecossistema Pede-Rango atualizado e em execução!"
echo "🌐 Frontend Web: http://app.pede-rango.local"
echo "⚙️  Backend API:  http://api.pede-rango.local/actuator/health"
echo "=========================================================="
