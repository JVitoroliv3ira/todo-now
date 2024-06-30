#!/bin/bash

CONTAINER_NAME=todonow-database

IMAGE_NAME=mcr.microsoft.com/mssql/server

IMAGE_VERSION=2019-latest

DATABASE_NAME=todonow

SA_USERNAME=sa

SA_PASSWORD=@myStrongPassword

PORT=1433

DBO_USERNAME=todonow
DBO_PASSWORD=@myStrongPassword

APP_USERNAME=dtodonow
APP_PASSWORD=@myStrongPassword

CONSULTA_USERNAME=todonow_consulta
CONSULTA_PASSWORD=@myStrongPassword

if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo "O container ${CONTAINER_NAME} já está rodando."
    exit 0
fi

if [ "$(docker ps -aq -f status=exited -f name=${CONTAINER_NAME})" ]; then
    echo "Removendo container existente ${CONTAINER_NAME}."
    docker rm ${CONTAINER_NAME}
fi

if [ -z "$(docker images -q ${IMAGE_NAME}:${IMAGE_VERSION})" ]; then
    echo "A imagem ${IMAGE_NAME}:${IMAGE_VERSION} não existe localmente. Baixando a imagem..."
    docker pull ${IMAGE_NAME}:${IMAGE_VERSION}
fi

echo "Iniciando o container ${CONTAINER_NAME}..."
docker run --network=host -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=${SA_PASSWORD}" \
   -p ${PORT}:1433 --name ${CONTAINER_NAME} \
   -d ${IMAGE_NAME}:${IMAGE_VERSION}

echo "Aguardando o SQL Server inicializar..."
sleep 20

echo "Criando o banco de dados ${DATABASE_NAME}..."
docker exec -it ${CONTAINER_NAME} /opt/mssql-tools/bin/sqlcmd -S localhost -U ${SA_USERNAME} -P ${SA_PASSWORD} -Q "CREATE DATABASE ${DATABASE_NAME};"

echo "Criando os usuários e concedendo permissões..."

docker exec -it ${CONTAINER_NAME} /opt/mssql-tools/bin/sqlcmd -S localhost -U ${SA_USERNAME} -P ${SA_PASSWORD} -d ${DATABASE_NAME} -Q "
CREATE LOGIN ${DBO_USERNAME} WITH PASSWORD = '${DBO_PASSWORD}';
CREATE USER ${DBO_USERNAME} FOR LOGIN ${DBO_USERNAME};
ALTER ROLE db_owner ADD MEMBER ${DBO_USERNAME};
CREATE LOGIN ${APP_USERNAME} WITH PASSWORD = '${APP_PASSWORD}';
CREATE USER ${APP_USERNAME} FOR LOGIN ${APP_USERNAME};
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO ${APP_USERNAME};
CREATE LOGIN ${CONSULTA_USERNAME} WITH PASSWORD = '${CONSULTA_PASSWORD}';
CREATE USER ${CONSULTA_USERNAME} FOR LOGIN ${CONSULTA_USERNAME};
GRANT SELECT ON SCHEMA::dbo TO ${CONSULTA_USERNAME};"

echo "O banco de dados ${DATABASE_NAME} e os usuários foram criados com sucesso no container ${CONTAINER_NAME}."
