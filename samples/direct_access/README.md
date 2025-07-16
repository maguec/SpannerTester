# Direct Access

An example of the benefits of the direct access path

## Clone the directory

```bash
git clone https://github.com/maguec/SpannerTester.git
cd SpannerTester
```

## Check to make sure direct path is available

```bash
/tmp/dp_check  --service=spanner.googleapis.com --ipv4_only
```

This should return PASSED

## Load the data

```bash
cd samples
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
./create_and_load_customer_table.py

```
## Run the SELECT benchmark

```bash
cd cd direct_access/
go run access.go  --count 10000
```

## Enable Direct Access

```bash
export GOOGLE_SPANNER_ENABLE_DIRECT_ACCESS=true
```

## Run the SELECT benchmark with direct access

```bash
go run access.go  --count 10000
``````

## Sample results

| Metric | direct | using FE |
| --    | -- | -- |
| Max   |51.823227ms| 27.636844ms |
| Min   |1.266239ms | 2.277549ms |
| P95   |2.794582ms | 4.589833ms |
| P99   |3.205891ms | 6.822763ms |
| P99.9 |4.476011ms | 9.903133ms |


