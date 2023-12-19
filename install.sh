#!/bin/bash

mysql_procedure_directory="./src/database/mysql/procedure"

for sql_file in "$mysql_procedure_directory/*.sql";do
  echo $sql_file
done

echo "Welcome to the RailwayEmpire Installer!"

if ! command -v curl > /dev/null 2>&1; then
  echo "Please install curl before proceeding!"
  exit 1
fi

echo "Searching for Bun Runtime..."

if ! command -v bun > /dev/null 2>&1; then
    echo "Bun was not found! Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "Bun found: $(which bun)"
fi

echo "Searching for MYSQL..."

if ! command -v mysql > /dev/null 2>&1; then
  echo "Mysql was not found! Installing Mysql..."
else
  echo "Mysql found: $(which mysql)"
fi

echo "Setting up Database..."

echo "Creating Tables.."

echo "Loading Stored Procedures..."

echo "Loading Events..."

echo "Done."

echo "Installing dependencies..."

bun install

echo "Done."
