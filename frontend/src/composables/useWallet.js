import { ref } from "vue";
import { BrowserProvider, formatEther } from "ethers";

const address = ref(null);
const balance = ref(null);
const chainId = ref(null);
const signer = ref(null);
const provider = ref(null);
const isConnected = ref(false);

async function connectWallet() {
  if (!window.ethereum) {
    alert("MetaMask n'est pas installé");
    return;
  }

  try {
    provider.value = new BrowserProvider(window.ethereum);

    await window.ethereum.request({
      method: "eth_requestAccounts",
    });

    signer.value = await provider.value.getSigner();

    address.value = await signer.value.getAddress();

    const network = await provider.value.getNetwork();
    chainId.value = Number(network.chainId);

    const rawBalance = await provider.value.getBalance(address.value);

    balance.value = formatEther(rawBalance);

    isConnected.value = true;
  } catch (error) {
    console.error(error);
  }
}

export function useWallet() {
  return {
    address,
    balance,
    chainId,
    isConnected,
    connectWallet,
  };
}
