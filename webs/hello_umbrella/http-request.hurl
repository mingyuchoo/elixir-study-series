# GET /calc
# ------------------------------------------------
GET http://localhost:4000/api/calc

[QueryStringParams]
op: add
x1: 1
x2: 2

HTTP 200
[Asserts]
jsonpath "$.status" == "ok"
jsonpath "$.message" == "add"


# POST /calc
# ------------------------------------------------
POST http://localhost:4000/api/calc
Content-Type: application/json
{
  "op": "add",
  "x1": 1,
  "x2": 2
}

HTTP 200
[Asserts]
jsonpath "$.status" == "ok"
jsonpath "$.message" == "add"
