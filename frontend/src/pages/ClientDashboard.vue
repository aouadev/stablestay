<template>
  <div class="dashboard">
    <div class="navbar">
      <div class="logo">StableStay</div>
    </div>
    <!-- HERO IMAGE -->
    <div class="hero">
      <img src="../assets/room1.jpg" />
      <div class="hero-text">
        <h1>Luxury Stay in Cannes</h1>
      </div>
    </div>

    <!-- PRODUCT CARD -->
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

      <div class="payment">
        <div class="price">Total: 120 USDC</div>

        <button class="pay-btn">Pay with Crypto</button>
      </div>
    </div>
  </div>
</template>

<script setup></script>

<style scoped>
.dashboard {
  font-family: Arial;
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
  margin: -60px auto 40px auto;
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
}
.product-card {
  max-width: 500px;
  margin: 40px auto;
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
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
}

.navbar {
  height: 60px;
  display: flex;
  align-items: center;
  padding: 0 30px;
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.logo {
  font-size: 25px;
  font-weight: bold;
  color: #2c3e50;
}
</style>
