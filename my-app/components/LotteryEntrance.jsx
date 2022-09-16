import { useMoralis, useWeb3Contract } from "react-moralis"
import { abi, lotteryAddress } from '../constants/index'
import { utils } from "ethers";
import { useEffect } from "react";

export default function EnterLottery() {

    const { isWeb3Enabled } = useMoralis();

    const entryFee = utils.parseEther('0.001')
    
    const {runContractFunction: startRaffle} = useWeb3Contract({
        abi: abi,
        contractAddress: lotteryAddress,
        functionName: 'startGame',
        params: {
            _maxPlayers: 2,
            _entryFee: entryFee
        },
    })

    const {runContractFunction: joinGame} = useWeb3Contract({
        abi: abi,
        contractAddress: lotteryAddress,
        functionName: 'joinGame',
        params: {},
        msgValue: entryFee
    })
    
    return (
        <div className="mt-[50px] flex">
            <button onClick={startRaffle} className="w-[150px] h-[50px] bg-emerald-500 rounded-2xl mx-auto mr-[50px]">Start Game</button>
            <button onClick={joinGame} className="w-[150px] h-[50px] bg-emerald-500 rounded-2xl mx-auto">Enter Lottery</button>
        </div>

    )
}