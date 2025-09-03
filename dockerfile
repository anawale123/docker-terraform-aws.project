# STAGE 1: BUILD 
FROM python:3.8-slim AS build

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libmariadb-dev \
    pkg-config

COPY . .

RUN pip install flask redis

# STAGE 2: PRODUCTION 
FROM python:3.8-slim

WORKDIR /app

COPY --from=build /app /app

# Install dependencies in production
RUN pip install flask redis

EXPOSE 5000

CMD ["python", "app.py"]
