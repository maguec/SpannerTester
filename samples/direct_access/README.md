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

```
## 

## Enable Direct Access

```bash
export GOOGLE_SPANNER_ENABLE_DIRECT_ACCESS=true
```



