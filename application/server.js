// SPDX-License-Identifier: MIT

'use strict';

const express = require('express')
const app = express()
const port = 3000

const fs = require('fs')
const path = require('path')


// fabric 연동설정 -- fabric library포함, connection 프로파일 읽기, 객체화, 지갑주소지정
const { Gateway, Wallets } = require('fabric-network');
const ccpPath = path.resolve(__dirname, '..', 'network', 'organizations', 'connection-org1.json')
let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf-8'))
const walletPath = path.join(process.cwd(), 'wallet')
// 익스프레스 설정 - bodyparser
app.use(express.json())
app.use(express.urlencoded({extended:true}))


app.get('/', (req,res) => {
  res.sendFile(__dirname+'/views/index.html')
})
app.get('/create', (req, res) => {
  res.sendFile(__dirname+'/views/create.html')
})
app.get('/query', (req, res) => {
  res.sendFile(__dirname+'/views/query.html')
})


// REST UI
app.post('/car', async (req, res) => {
    // 요청문서에서 param 꺼내기
    const cid = req.body.carid;
    const make = req.body.carmake;
    const model = req.body.carmodel;
    const color = req.body.carcolor;
    const owner = req.body.carowner;

    const gateway = new Gateway();
    try {
        //지갑생성과 appUser사용자확인
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        //게이트웨이 연결 -> 채널연결 -> 체인코드 객체생성
        const identity = await wallet.get('appUser')
        if (!identity) {
            console.log('An identity for the user appUser does not exist in the wallet')
            res.send('An identity for the user appUser does not exist in the wallet')
            return;
        }
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost:true}})
        const network = await gateway.getNetwork('mychannel')
        const contract = network.getContract('basic')
        
        //트랜젝션 제출
        await contract.submitTransaction('CreateCar', cid, make, model, color, owner)
        console.log('Transaction has been submitted')

        // 클라이언트 응답
        res.send('Transaction has been submitted')

    } catch (error) {
      console.error(`Failed to submit transaction: ${error}`);
      res.send(`Failed to submit transaction: ${error}`)
    } finally {
        await gateway.disconnect();
      }
    }
)

app.get('/car', async (req, res) => {
    
    // 요청문서에서 param 꺼내기
    const cid = req.query.carid

    const gateway = new Gateway();

    try {
        // 지갑생성과 appUser사용자확인
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        const identity = await wallet.get('appuUser');
        if(!identity) {
            console.log('An identity for the user appUser does not exist');
            res.send('An identity for the user appUser does not exist in the wallet');
            return;
        }
        // 게이트웨이연결 -> 채널연결 -> 체인코드 객체생성
        await gateway.connet(ccp, { wallet, identity: 'appUser', discovery: { enabled:true, asLocalhost: true } });
        const network = await gateway.getNetwork('mychannel');
        const contract = network.getContract('basic');
        // 트랜젝션 제출
        const result = await contract.evaluateTransaction('QueryCar', cid);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        
        // 클라이언트 응답
        res.send(`Transaction has been evaluated, result is: ${result.toString()}`);
    
    } catch (error){
        console.error(`Failed to evaluate transaction: ${error}`);
        res.send(`Faild to evaluate transaction: ${error}`);
    } finally {
        await gateway.disconnect();
    }
})

app.listen(port, () => {
  console.log(`Fabcar app listening on port ${port}`)
})
