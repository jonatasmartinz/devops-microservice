#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-microservice}"
INGRESS_NAME="${INGRESS_NAME:-hello-ms}"
PATH_CHECK="${PATH_CHECK:-/health}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-300}"
SLEEP_SECONDS="${SLEEP_SECONDS:-5}"

echo "[smoke] namespace=${NAMESPACE} ingress=${INGRESS_NAME} path=${PATH_CHECK}"

deadline=$(( $(date +%s) + TIMEOUT_SECONDS ))

get_addr() {
  kubectl -n "${NAMESPACE}" get ingress "${INGRESS_NAME}" \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true
}

ADDR="$(get_addr)"
while [[ -z "${ADDR}" ]]; do
  if (( $(date +%s) > deadline )); then
    echo "[smoke] ERROR: Ingress address not assigned within ${TIMEOUT_SECONDS}s"
    kubectl -n "${NAMESPACE}" get ingress "${INGRESS_NAME}" -o yaml || true
    exit 1
  fi
  echo "[smoke] waiting for ingress address..."
  sleep "${SLEEP_SECONDS}"
  ADDR="$(get_addr)"
done

URL="http://${ADDR}${PATH_CHECK}"
echo "[smoke] testing ${URL}"

while true; do
  code="$(curl -s -o /dev/null -w "%{http_code}" "${URL}" || true)"
  if [[ "${code}" == "200" ]]; then
    echo "[smoke] OK: ${URL} -> 200"
    exit 0
  fi

  if (( $(date +%s) > deadline )); then
    echo "[smoke] ERROR: ${URL} -> HTTP ${code} (timeout)"
    exit 1
  fi

  echo "[smoke] retry... got HTTP ${code}"
  sleep "${SLEEP_SECONDS}"
done
