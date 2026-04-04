<template>
  <div class="dashboard">
    <div class="navbar">
      <div class="logo">StableStay</div>

      <div class="wallet-box" v-if="isConnected">
        <span class="wallet-address">{{ shortAddress }}</span>
      </div>
    </div>

    <div class="hero">
      <img src="../assets/room1.jpg" />
      <div class="hero-text">
        <h1>Luxury Stay in Cannes</h1>
      </div>
    </div>

    <div class="product-card">
      <img class="room-image" src="../assets/room2.jpg" />

      <div class="location">📍 Cannes</div>

      <div class="info-bar">
        <div class="info">👤 2 guests</div>
        <div class="info">📅 Apr 3 - Apr 6</div>
      </div>

      <div class="features">
        <span class="badge">Wifi</span>
        <span class="badge">Parking</span>
        <span class="badge">Air conditioning</span>
      </div>

      <div class="wallet-details" v-if="isConnected">
        <p><strong>Address:</strong> {{ address }}</p>
        <p><strong>Chain ID:</strong> {{ chainId }}</p>
        <p><strong>Balance:</strong> {{ balance }} ETH</p>
      </div>

      <p v-if="networkError" class="error">Please switch to Sepolia testnet.</p>

      <p v-if="errorMessage" class="error">
        {{ errorMessage }}
      </p>

      <div class="payment">
        <div class="price">Total: 120 USDC</div>

        <button class="pay-btn" @click="handlePayClick">
          {{ isConnected ? "Continue to Payment" : "Connect Wallet" }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { BrowserProvider, formatEther } from "ethers";

const address = ref("");
const balance = ref("");
const chainId = ref(null);
const isConnected = ref(false);
const errorMessage = ref("");

const SEPOLIA_CHAIN_ID = 11155111;

const shortAddress = computed(() => {
  if (!address.value) return "";
  return `${address.value.slice(0, 6)}...${address.value.slice(-4)}`;
});

const networkError = computed(() => {
  return isConnected.value && chainId.value !== SEPOLIA_CHAIN_ID;
});

async function connectWallet() {
  errorMessage.value = "";

  try {
    if (!window.ethereum) {
      errorMessage.value = "MetaMask is not installed.";
      return;
    }

    const provider = new BrowserProvider(window.ethereum);

    await window.ethereum.request({
      method: "eth_requestAccounts",
    });

    const signer = await provider.getSigner();
    const userAddress = await signer.getAddress();
    const network = await provider.getNetwork();
    const rawBalance = await provider.getBalance(userAddress);

    address.value = userAddress;
    chainId.value = Number(network.chainId);
    balance.value = Number(formatEther(rawBalance)).toFixed(4);
    isConnected.value = true;
  } catch (error) {
    console.error(error);
    errorMessage.value = error?.message || "Wallet connection failed.";
  }
}

async function handlePayClick() {
  if (!isConnected.value) {
    await connectWallet();
    return;
  }

  if (networkError.value) {
    errorMessage.value = "Please switch MetaMask to Sepolia before continuing.";
    return;
  }

  alert("Wallet connected. Next step: payment flow.");
}
</script>

<style scoped>
.dashboard {
  font-family: Arial, sans-serif;
  background: #f5f7fb;
  min-height: 100vh;
}

.navbar {
  height: 60px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 30px;
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.logo {
  font-size: 25px;
  font-weight: bold;
  color: #1a73e8;
}

.wallet-box {
  background: #eef4ff;
  color: #1a73e8;
  padding: 8px 14px;
  border-radius: 20px;
  font-weight: 600;
  font-size: 14px;
}

.hero {
  position: relative;
  height: 300px;
  overflow: hidden;
}

.hero img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.hero-text {
  position: absolute;
  bottom: 20px;
  left: 40px;
  color: white;
  font-size: 28px;
  font-weight: bold;
}

.product-card {
  max-width: 500px;
  margin: 40px auto;
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
}

.room-image {
  width: 100%;
  border-radius: 10px;
}

.location {
  margin-top: 10px;
  font-weight: bold;
}

.info-bar {
  display: flex;
  justify-content: space-between;
  margin: 15px 0;
}

.features {
  margin-bottom: 15px;
}

.badge {
  background: #eee;
  padding: 6px 10px;
  border-radius: 6px;
  margin-right: 6px;
}

.wallet-details {
  background: #f8faff;
  border: 1px solid #e2ebff;
  border-radius: 10px;
  padding: 12px;
  margin-bottom: 15px;
  font-size: 14px;
  word-break: break-word;
}

.payment {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.price {
  font-weight: bold;
  font-size: 18px;
}

.pay-btn {
  background: #4caf50;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
}

.pay-btn:hover {
  opacity: 0.95;
}

.error {
  color: #d93025;
  font-size: 14px;
  margin-bottom: 12px;
}
</style>
