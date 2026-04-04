import { createRouter, createWebHistory } from "vue-router";
import ClientDashboard from "../pages/ClientDashboard.vue";
import HostDashboard from "../pages/HostDashboard.vue";

const routes = [
  {
    path: "/",
    name: "ClientDashboard",
    component: ClientDashboard,
  },
  {
    path: "/host-dashboard",
    name: "HostDashboard",
    component: HostDashboard,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
