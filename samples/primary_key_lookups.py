#!/usr/bin/env python

from google.cloud import spanner
from alive_progress import alive_bar
import time, os
import numpy as np

NUMBER_OF_USERS = 2500

if __name__ == "__main__":

    query_times = []
    s = spanner.Client()
    instance = os.environ.get("GCP_SPANNER_INSTANCE")
    if instance is None:
        print("GCP_SPANNER_INSTANCE environment variable is not set")
        exit(1)
    database = os.environ.get("GCP_SPANNER_DATABASE")
    if database is None:
        print("GCP_SPANNER_DATABASE environment variable is not set")
        exit(1)

    instance = s.instance(instance)
    database = instance.database(database)
    with alive_bar(NUMBER_OF_USERS, title='Running queries') as bar:
        for i in range(NUMBER_OF_USERS):
            start = time.time_ns()
            with database.snapshot() as snapshot:
                snapshot.execute_sql(f"SELECT * FROM users WHERE id = {i}")
                end = time.time()
                query_times.append((time.time_ns() - start)/ 1_000_000)
                bar()

    query_times_np = np.array(query_times)
    print(f"\nDatabase Query Time Statistics:")
    print(f"Mean: {query_times_np.mean():.6f} ms")
    print(f"p95 : {np.percentile(query_times_np, 0.95):.6f} ms")
    print(f"p99 : {np.percentile(query_times_np, 0.99):.6f} ms")
