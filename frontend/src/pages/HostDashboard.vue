<template>
  <div class="dashboard">
    <!-- Navbar -->
    <div class="navbar">
      <div class="logo">StableStay</div>
    </div>

    <!-- Hero -->
    <div class="hero">
      <img src="../assets/room1.jpg" alt="Hotel dashboard cover" />
      <div class="hero-text">
        <h1>Host Dashboard</h1>
        <p>Manage bookings and track payments</p>
      </div>
    </div>

    <!-- Main Card -->
    <div class="host-card">
      <div class="section-header">
        <h2>Overview</h2>
        <p>Your hotel activity at a glance</p>
      </div>

      <div class="stats-grid">
        <div class="stat-box">
          <span class="stat-title">Available Rooms</span>
          <span class="stat-value">12</span>
        </div>

        <div class="stat-box">
          <span class="stat-title">Booked Today</span>
          <span class="stat-value">3</span>
        </div>

        <div class="stat-box">
          <span class="stat-title">Occupied Rooms</span>
          <span class="stat-value">5</span>
        </div>

        <div class="stat-box">
          <span class="stat-title">Revenue Today</span>
          <span class="stat-value">240 USDC</span>
        </div>
      </div>

      <div class="recent-payment">
        <h3>Latest Payment Activity</h3>
        <div class="payment-summary">
          <div class="summary-row">
            <span>Property</span>
            <strong>Luxury Stay in Cannes</strong>
          </div>
          <div class="summary-row">
            <span>Guest</span>
            <strong>2 guests</strong>
          </div>
          <div class="summary-row">
            <span>Dates</span>
            <strong>Apr 3 - Apr 6</strong>
          </div>
          <div class="summary-row">
            <span>Paid with</span>
            <strong>ETH</strong>
          </div>
          <div class="summary-row">
            <span>Converted to</span>
            <strong>USDC</strong>
          </div>
          <div class="summary-row">
            <span>Status</span>
            <strong class="status success">Confirmed</strong>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay">
      <div class="modal-box">
        <h2>New Booking Received</h2>
        <p class="modal-subtitle">A new reservation has just been confirmed.</p>

        <div class="modal-details">
          <div class="summary-row">
            <span>Room</span>
            <strong>Sea View Suite</strong>
          </div>
          <div class="summary-row">
            <span>Guests</span>
            <strong>2 guests</strong>
          </div>
          <div class="summary-row">
            <span>Dates</span>
            <strong>Apr 3 - Apr 6</strong>
          </div>
          <div class="summary-row">
            <span>Paid with</span>
            <strong>ETH</strong>
          </div>
          <div class="summary-row">
            <span>Swapped to</span>
            <strong>USDC</strong>
          </div>
          <div class="summary-row">
            <span>Amount received</span>
            <strong>120 USDC</strong>
          </div>
          <div class="summary-row">
            <span>Status</span>
            <strong class="status success">Completed</strong>
          </div>
        </div>

        <button class="close-btn" @click="showModal = false">Close</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";

const showModal = ref(false);

onMounted(() => {
  showModal.value = true;
});
</script>

<style scoped>
.dashboard {
  font-family: Arial, sans-serif;
  background: #f5f7fa;
  min-height: 100vh;
  padding-bottom: 40px;
}

.navbar {
  height: 60px;
  display: flex;
  align-items: center;
  padding: 0 30px;
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.logo {
  font-size: 24px;
  font-weight: 700;
  color: #1a73e8;
}

.hero {
  position: relative;
  height: 280px;
  overflow: hidden;
}

.hero img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.hero-text {
  position: absolute;
  bottom: 24px;
  left: 40px;
  color: white;
}

.hero-text h1 {
  margin: 0;
  font-size: 32px;
}

.hero-text p {
  margin-top: 8px;
  font-size: 16px;
}

.host-card {
  max-width: 950px;
  margin: 40px auto;
  background: white;
  border-radius: 16px;
  padding: 28px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.12);
}

.section-header h2 {
  margin: 0;
  font-size: 26px;
}

.section-header p {
  margin-top: 8px;
  color: #666;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 18px;
  margin-top: 24px;
  margin-bottom: 32px;
}

.stat-box {
  background: #f8fafc;
  border-radius: 14px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  border: 1px solid #eceff3;
}

.stat-title {
  font-size: 14px;
  color: #666;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #1f2937;
}

.recent-payment h3 {
  margin-bottom: 18px;
  font-size: 20px;
}

.payment-summary,
.modal-details {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.summary-row span {
  color: #666;
}

.status.success {
  color: #16a34a;
}

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.modal-box {
  width: 100%;
  max-width: 520px;
  background: white;
  border-radius: 16px;
  padding: 28px;
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.18);
}

.modal-box h2 {
  margin-top: 0;
  margin-bottom: 8px;
}

.modal-subtitle {
  margin-top: 0;
  margin-bottom: 22px;
  color: #666;
}

.close-btn {
  margin-top: 24px;
  width: 100%;
  background: #1a73e8;
  color: white;
  border: none;
  padding: 14px;
  border-radius: 10px;
  font-size: 15px;
  cursor: pointer;
}

.close-btn:hover {
  opacity: 0.95;
}

@media (max-width: 900px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .hero-text {
    left: 20px;
    right: 20px;
  }

  .hero-text h1 {
    font-size: 26px;
  }
}

@media (max-width: 600px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }

  .host-card {
    margin: 20px 16px;
    padding: 20px;
  }

  .summary-row {
    flex-direction: column;
    gap: 6px;
  }
}
</style>
