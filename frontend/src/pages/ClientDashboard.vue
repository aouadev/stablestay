<template>
  <div class="dashboard">
    <div class="navbar">
      <div class="logo">StableStay</div>

      <div class="wallet-box" v-if="isConnected">
        {{ shortAddress }}
      </div>
    </div>

    <div class="hero">
      <img src="../assets/room1.jpg" alt="Luxury room" />
      <div class="hero-text">
        <h1>Luxury Stay in Cannes</h1>
      </div>
    </div>

    <div class="product-card">
      <img class="room-image" src="../assets/room2.jpg" alt="Room preview" />

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
        <p><strong>Balance:</strong> {{ balance }} ETH</p>
      </div>

      <p v-if="errorMessage" class="error">
        {{ errorMessage }}
      </p>

      <div v-if="txHash" class="success-box">
        <p class="success-title">Payment sent successfully.</p>
        <p class="success-text">
          Transaction:
          <a :href="etherscanUrl" target="_blank" rel="noopener noreferrer">
            {{ txHash }}
          </a>
        </p>
      </div>

      <div class="payment-actions">
        <button class="connect-btn" @click="connectWallet" :disabled="isPaying">
          Connect Wallet
        </button>

        <button
          class="pay-btn"
          @click="payWithETH"
          :disabled="isPaying || !isConnected"
        >
          {{ isPaying ? "Processing..." : "Pay with Crypto" }}
        </button>
      </div>

      <div class="payment">
        <div class="price">Total: 0.001 ETH</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { BrowserProvider, formatEther, parseEther } from "ethers";

const HOTEL_ADDRESS = "0x23d9DBaCCfbcb16324d0E0abde8a52b6711E28db";
const PRICE_ETH = "0.001";

const address = ref("");
const balance = ref("");
const isConnected = ref(false);
const isPaying = ref(false);
const errorMessage = ref("");
const txHash = ref("");

const shortAddress = computed(() => {
  if (!address.value) return "";
  return `${address.value.slice(0, 6)}...${address.value.slice(-4)}`;
});

const etherscanUrl = computed(() => {
  if (!txHash.value) return "";
  return `https://sepolia.etherscan.io/tx/${txHash.value}`;
});

function isPlaceholder(value) {
  return !value || value.includes("YOUR_HOTEL_ADDRESS");
}

async function getProvider() {
  if (!window.ethereum) {
    throw new Error("MetaMask is not installed.");
  }

  return new BrowserProvider(window.ethereum);
}

async function loadWalletData() {
  const provider = await getProvider();
  const signer = await provider.getSigner();
  const userAddress = await signer.getAddress();
  const rawBalance = await provider.getBalance(userAddress);

  address.value = userAddress;
  balance.value = Number(formatEther(rawBalance)).toFixed(4);
  isConnected.value = true;
}

async function connectWallet() {
  errorMessage.value = "";
  txHash.value = "";

  try {
    if (!window.ethereum) {
      throw new Error("MetaMask is not installed.");
    }

    await window.ethereum.request({
      method: "wallet_requestPermissions",
      params: [{ eth_accounts: {} }],
    });

    await window.ethereum.request({
      method: "eth_requestAccounts",
    });

    await loadWalletData();

    if (window.ethereum && !window.__stableStayWalletListenersAdded) {
      window.ethereum.on("accountsChanged", async () => {
        await resetAndReload();
      });

      window.ethereum.on("chainChanged", async () => {
        await resetAndReload();
      });

      window.__stableStayWalletListenersAdded = true;
    }
  } catch (error) {
    console.error(error);
    errorMessage.value = error?.message || "Wallet connection failed.";
  }
}

async function resetAndReload() {
  errorMessage.value = "";
  txHash.value = "";

  try {
    const accounts = await window.ethereum.request({ method: "eth_accounts" });

    if (!accounts || accounts.length === 0) {
      address.value = "";
      balance.value = "";
      isConnected.value = false;
      return;
    }

    await loadWalletData();
  } catch (error) {
    console.error(error);
  }
}

async function payWithETH() {
  errorMessage.value = "";
  txHash.value = "";

  try {
    if (!isConnected.value) {
      throw new Error("Please connect your wallet first.");
    }

    if (isPlaceholder(HOTEL_ADDRESS)) {
      throw new Error("Hotel wallet address is missing.");
    }

    const currentBalance = Number(balance.value || 0);
    if (currentBalance < Number(PRICE_ETH)) {
      throw new Error("Insufficient ETH balance.");
    }

    isPaying.value = true;

    const provider = await getProvider();
    const signer = await provider.getSigner();

    const tx = await signer.sendTransaction({
      to: HOTEL_ADDRESS,
      value: parseEther(PRICE_ETH),
    });

    txHash.value = tx.hash;

    await tx.wait();
    await loadWalletData();
  } catch (error) {
    console.error(error);
    errorMessage.value =
      error?.reason ||
      error?.shortMessage ||
      error?.message ||
      "Payment failed.";
  } finally {
    isPaying.value = false;
  }
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
  gap: 12px;
}

.info {
  font-size: 14px;
}

.features {
  margin-bottom: 15px;
}

.badge {
  display: inline-block;
  background: #eee;
  padding: 6px 10px;
  border-radius: 6px;
  margin-right: 6px;
  margin-bottom: 6px;
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

.payment-actions {
  display: flex;
  gap: 12px;
  margin-top: 20px;
}

.payment {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 16px;
}

.price {
  font-weight: bold;
  font-size: 18px;
}

.connect-btn,
.pay-btn {
  flex: 1;
  color: white;
  border: none;
  padding: 10px 18px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
}

.connect-btn {
  background: #1a73e8;
}

.pay-btn {
  background: #4caf50;
}

.connect-btn:disabled,
.pay-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.error {
  color: #d93025;
  font-size: 14px;
  margin-bottom: 12px;
}

.success-box {
  margin-bottom: 14px;
  padding: 12px;
  border-radius: 10px;
  background: #eef8f0;
  border: 1px solid #cde8d2;
}

.success-title {
  color: #188038;
  font-weight: 700;
  margin-bottom: 6px;
}

.success-text {
  color: #188038;
  font-size: 14px;
  word-break: break-word;
}

.success-text a {
  color: #1565c0;
  text-decoration: underline;
}
</style>
