import os
import subprocess

# === CONFIGURATION ===
CHAINCODE_NAMES = ["counter", "voting", "supplychain"]

# === TEMPLATES ===
GO_MOD_TEMPLATE = """module {module_name}

go 1.18

require (
    github.com/hyperledger/fabric-contract-api-go v1.1.0
)

replace github.com/hyperledger/fabric-contract-api-go => github.com/hyperledger/fabric-contract-api-go v1.1.0
"""

MAIN_GO_TEMPLATE = """package main

import (
    "github.com/hyperledger/fabric-contract-api-go/contractapi"
    "{module_name}/{contract_file}"
)

func main() {
    chaincode, err := contractapi.NewChaincode(&{contract_type}.{contract_struct}SmartContract{{}})
    if err != nil {
        panic("Error creating chaincode: " + err.Error())
    }

    if err := chaincode.Start(); err != nil {
        panic("Error starting chaincode: " + err.Error())
    }
}
"""

CONTRACT_GO_TEMPLATE = """package {contract_file}

import (
    "encoding/json"
    "github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type {contract_struct}SmartContract struct {{
    contractapi.Contract
}}

type SampleAsset struct {{
    ID    string `json:"id"`
    Value string `json:"value"`
}}

func (s *{contract_struct}SmartContract) CreateAsset(ctx contractapi.TransactionContextInterface, id string, value string) error {{
    asset := SampleAsset{{ID: id, Value: value}}
    assetBytes, err := json.Marshal(asset)
    if err != nil {{
        return err
    }}
    return ctx.GetStub().PutState(id, assetBytes)
}}

func (s *{contract_struct}SmartContract) ReadAsset(ctx contractapi.TransactionContextInterface, id string) (*SampleAsset, error) {{
    data, err := ctx.GetStub().GetState(id)
    if err != nil {{
        return nil, err
    }}
    if data == nil {{
        return nil, nil
    }}
    var asset SampleAsset
    err = json.Unmarshal(data, &asset)
    if err != nil {{
        return nil, err
    }}
    return &asset, nil
}}
"""

# === FUNCTIONS ===

def create_directory_structure(base_dir):
    os.makedirs(base_dir, exist_ok=True)

def write_file(path, content):
    with open(path, "w") as f:
        f.write(content)

def generate_chaincode(name):
    print(f"🔧 Generating chaincode: {name}")
    base_dir = f"./{name}_chaincode"
    create_directory_structure(base_dir)

    # Write go.mod
    write_file(os.path.join(base_dir, "go.mod"), GO_MOD_TEMPLATE.format(module_name=name))

    # Write smart contract file
    contract_file = f"{name}.go"
    write_file(os.path.join(base_dir, contract_file), CONTRACT_GO_TEMPLATE.format(
        contract_file=name,
        contract_struct=name.capitalize()
    ))

    # Write main.go
    write_file(os.path.join(base_dir, "main.go"), MAIN_GO_TEMPLATE.format(
        module_name=name,
        contract_file=name,
        contract_type=name,
        contract_struct=name.capitalize()
    ))

    # Run go mod tidy & vendor
    subprocess.run(["go", "mod", "tidy"], cwd=base_dir, check=True)
    subprocess.run(["go", "mod", "vendor"], cwd=base_dir, check=True)

    print(f"✅ Chaincode '{name}' generated in: {base_dir}\n")

# === MAIN ===

if __name__ == "__main__":
    for chaincode_name in CHAINCODE_NAMES:
        generate_chaincode(chaincode_name)
