import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'
import Navbar from '../components/Navabr'
import EnterLottery from '../components/LotteryEntrance'
import { useState } from 'react'

export default function Home() {

  const [isLoggedIn, setIsLoggedIn] = useState(false);
  return (
    <div className='w-screen h-screen flex flex-col'>
      <Head>
        <title>Nice Shoes Lottery</title>
        <meta name="description" content="Nice Shoes Decentralized Lottery" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Navbar />
      <h1 className='flex text-6xl mx-auto mt-[100px]'>Welcome to the Nice Shoes Lottery</h1> 
      <EnterLottery />
    </div>
  )
}
