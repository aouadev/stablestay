import { createRouter, createWebHistory } from "vue-router";
import ClientDashboard from "../pages/ClientDashboard.vue";

const routes = [
  {
    path: "/",
    name: "ClientDashboard",
    component: ClientDashboard,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
