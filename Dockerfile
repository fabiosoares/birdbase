FROM python:3.12-slim

WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instalar dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar projeto dbt
COPY dbt_project.yml .
COPY packages.yml .
COPY profiles.yml .
COPY models/ models/
COPY macros/ macros/

# Instalar pacotes dbt
RUN dbt deps --profiles-dir .

# Comando padrão: dbt run
ENTRYPOINT ["dbt"]
CMD ["run", "--profiles-dir", ".", "--target", "prod"]
