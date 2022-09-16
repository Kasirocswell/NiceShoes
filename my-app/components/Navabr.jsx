import { ConnectButton } from "@web3uikit/web3"

export default function Navbar() {
    return (
        <div>
            <ConnectButton moralisAuth={false}/>
        </div>
    )
}