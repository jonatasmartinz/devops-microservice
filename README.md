```md
# DevOps Microservice Challenge – GCP

Este repositório contém a implementação completa de um desafio técnico para DevOps Pleno, 
cobrindo todas as etapas esperadas de um fluxo moderno de DevOps: aplicação, containerização, 
Kubernetes, Infraestrutura como Código (IaC) e CI/CD, com foco em boas práticas e segurança (DevSecOps).

O projeto foi desenhado para que qualquer pessoa consiga executá-lo no próprio projeto GCP, 
utilizando suas próprias credenciais, sem exposição de segredos.

---

## Visão Geral da Arquitetura

- Aplicação: Python + FastAPI (stateless)
- Containerização: Docker
- Orquestração: Kubernetes (GKE)
- Manifests Kubernetes: Kustomize (base + overlay)
- Infraestrutura como Código: Terraform
- CI/CD: GitHub Actions
- Cloud Provider: Google Cloud Platform (GCP)
- Autenticação: OIDC / Workload Identity (sem chaves estáticas)

---

## Estrutura do Repositório
.
├── app/ # Código da aplicação
│ └── main.py
├── infra/ # Terraform (VPC, GKE, Artifact Registry, IAM)
│ ├── backend.tf
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── terraform.tfvars.example
├── k8s/
│ ├── base/ # Manifests Kubernetes base
│ │ ├── deployment.yaml
│ │ ├── service.yaml
│ │ ├── ingress.yaml
│ │ ├── namespace.yaml
│ │ └── kustomization.yaml
│ └── overlays/
│ └── gcp/ # Overlay específico para GCP
│ └── kustomization.yaml
├── scripts/
│ └── smoke_test.sh # Smoke test HTTP (200)
├── .github/workflows/
│ ├── ci.yaml # CI (App + Terraform + Security scans)
│ └── cd-gcp.yaml # CD automático + manual (Terraform + Deploy GKE)
├── Dockerfile
├── requirements.txt
├── .dockerignore
├── .gitignore
└── README.md

````

---

## Funcionalidades da Aplicação

O microserviço expõe os seguintes endpoints HTTP:

| Método | Endpoint   | Descrição                   |
|------|------------|-----------------------------|
| GET  | `/`        | Retorna Hello World         |
| GET  | `/health`  | Liveness probe              |
| GET  | `/ready`   | Readiness probe             |
| GET  | `/version` | Versão do serviço           |

A aplicação é **stateless**, configurada via variáveis de ambiente e preparada para execução em Kubernetes, incluindo probes e limites de recursos.

---

## Execução Local

### Sem Docker
```bash
pip install -r requirements.txt
python -m uvicorn app.main:app --port 8080
````

A aplicação ficará disponível em:

```
http://localhost:8080
```

### Com Docker

```bash
docker build -t hello-ms:local .
docker run -p 8080:8080 hello-ms:local
```

---

## Kubernetes (GKE)

Os manifests Kubernetes utilizam **Kustomize**, permitindo reutilização do YAML base e customização por ambiente sem duplicação de arquivos.

Deploy manual no cluster:

```bash
kubectl apply -k k8s/overlays/gcp
```

---

## Infraestrutura como Código (Terraform)

O diretório `infra/` contém o código Terraform responsável por provisionar:

* VPC e Subnet dedicadas (VPC-native)
* GKE (Standard, com hardening básico)
* Artifact Registry (Docker)
* Service Account para CI/CD
* IAM seguindo o princípio de **least privilege**
* Workload Identity (OIDC)
* Shielded Nodes habilitados

### Executar Terraform

```bash
cd infra
cp terraform.tfvars.example terraform.tfvars
# Ajuste o project_id para o seu projeto GCP

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

> Observação: o `terraform apply` requer **billing habilitado** no projeto GCP.

---

## CI/CD (GitHub Actions)

### CI – `ci.yaml`

Executado automaticamente em `push` e `pull_request`:

* Validação da aplicação
* Docker build
* Terraform fmt / validate
* Scans de segurança de IaC (tfsec e checkov)

### CD – `cd-gcp.yaml`

Executado automaticamente em **push na branch `main`** e também manualmente (`workflow_dispatch`):

* Terraform apply
* Build e push da imagem no Artifact Registry
* Deploy no GKE via Kustomize
* Verificação de rollout
* **Smoke test automatizado (HTTP 200)**

---

## Pré-requisitos

* Projeto GCP com billing habilitado
* Permissões para criar VPC, GKE, Artifact Registry e IAM
* GitHub Actions habilitado

### Secrets necessários no GitHub

Configurar em **Settings → Actions → Secrets**:

| Secret                     | Descrição                       |
| -------------------------- | ------------------------------- |
| `GCP_PROJECT_ID`           | Project ID do GCP               |
| `GCP_WORKLOAD_ID_PROVIDER` | Workload Identity Provider      |
| `GCP_SERVICE_ACCOUNT`      | Service Account usado pelo OIDC |

> Nenhuma chave JSON é utilizada. A autenticação é feita via **OIDC**, conforme boas práticas de segurança.

---