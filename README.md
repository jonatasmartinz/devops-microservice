# Hello World Microservice

Microserviço simples desenvolvido em Python utilizando FastAPI, criado como parte de um desafio técnico DevOps.

A aplicação foi construída seguindo boas práticas de containerização e preparada para execução em ambientes Kubernetes.

---

## Funcionalidades

- Endpoint raiz retornando "Hello World"
- Health check para liveness
- Readiness check para disponibilidade
- Endpoint de versão da aplicação

---

## Endpoints

| Método | Endpoint   | Descrição                    |
|------|------------|------------------------------|
| GET  | `/`        | Retorna Hello World          |
| GET  | `/health`  | Liveness probe               |
| GET  | `/ready`   | Readiness probe              |
| GET  | `/version` | Versão do serviço            |

---

## Executar localmente

```bash
pip install -r requirements.txt
python -m uvicorn app.main:app --port 8080
