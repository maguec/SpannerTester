#!/usr/bin/env python3

import os
from google.cloud import spanner
from faker import Faker
from typing import List, Any
from alive_progress import alive_bar

CUSTOMER_COUNT = 250000
BATCH_SIZE = 1000

def getClient(instance: str, database: str):
    s = spanner.Client()
    i = s.instance(instance)
    client = i.database(database)
    return client

def create_table(client: str, table_name: str, schema_definition: str):
    with alive_bar(1, title='Creating table ') as bar:
        ddl_statement = f"CREATE TABLE IF NOT EXISTS {table_name}({schema_definition})"
        operation = client.update_ddl([ddl_statement])
        operation.result()
        bar()

def chunk(data: List[Any], chunk_size: int=BATCH_SIZE) -> List[List[Any]]:
    return [data[i:i+chunk_size] for i in range(0, len(data), chunk_size)]

def genData() -> List[List[Any]]:
    data = []
    faker = Faker()
    with alive_bar(CUSTOMER_COUNT, title='Generating data') as bar:
        for i in range(CUSTOMER_COUNT):
            data.append((i, faker.first_name(), faker.last_name(), faker.email()))
            bar()
    return chunk(data)

def insertData(transaction: str, table: str, data: str):
    transaction.insert(
            table,
            columns=["id", "first_name", "last_name", "email"],
            values=data
        )


def load_data(client: str, table:str, data:str):
    with alive_bar(CUSTOMER_COUNT, title='Loading data   ') as bar:
        for chunk in data:
            client.run_in_transaction(lambda t: insertData(t, table, chunk))
            bar(BATCH_SIZE)
        

if __name__ == '__main__':
    instance = os.environ.get("GCP_SPANNER_INSTANCE")
    if instance is None:
        print("GCP_SPANNER_INSTANCE environment variable is not set")
        exit(1)
    database = os.environ.get("GCP_SPANNER_DATABASE")
    if database is None:
        print("GCP_SPANNER_DATABASE environment variable is not set")
        exit(1)

    client = getClient(instance, database)
    create_table(client, 'customers', 'id INT64 NOT NULL PRIMARY KEY, first_name STRING(255), last_name STRING(255), email STRING(255)')
    data = genData()
    load_data(client, 'customers', data)

