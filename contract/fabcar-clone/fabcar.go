// SPDX-License-Identifier: MIT

// 패키지 정의
package main

// 외부모듈 포함
import (
    "encoding/json"
    "fmt"
    
    "github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// 체인코드 객체정의
type SmartContract struct {
    contractapi.Contract
}

// 차종 구조체 정의
type Car struct{
    Make    string `json:"make"`
    Model   string `json:"model"`
    Colour  string `json:"colour"`
    Owner   string `json:"owner"`
}

// 차종 추가
func (s *SmartContract) CreateCar(ctx contractapi.TransactionContextInterface, carNumber string, make string, model string, colour string, owner string) error {
    // CAR 구조체 생성
    car := Car{ 
        Make:   make,
        Model:  model,
        Colour: colour,
        Owner:  owner,
    }
    // JSON 문서로 직렬화
    carAsBytes, _ := json.Marshal(car)
    // WORLD STATE 로 저장

    return ctx.GetStub().PutState(carNumber, carAsBytes)
}

// 차종 조회
func (s *SmartContract) QueryCar(ctx contractapi.TransactionContextInterface, carNumber string) (*Car, error) {
    // WORLD STATE 조회
    carAsBytes, err := ctx.GetStub().GetState(carNumber)

    // 오류체크
    if err != nil {
        return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
    }

    if carAsBytes == nil {
        return nil, fmt.Errorf("%s does not exist.", carNumber)
    }

    // 빈구조체 생성 후 JSON을 CAR구조체로 객체화
    car := new(Car)
    _ = json.Unmarshal(carAsBytes, car)

    // 생성된 구조체 반환
    return car, nil
}

// main
func main() {
    chaincode, err := contractapi.NewChaincode(new(SmartContract))

    if err != nil {
        fmt.Printf("Error create fabcar-clone chaincode: %s", err.Error())
        return
    }

    if err := chaincode.Start(); err != nil {
        fmt.Printf("Error starting fabcar-clone chaincode: %s", err.Error())
    }
}
