import { createRouter, createWebHistory } from 'vue-router';
import List from "./pages/List.vue";
import Category from "./pages/Category.vue";
import Summary from "./pages/Summary.vue";

const routes = [
  { path: '/', name: 'home', component: List },
  { path: '/category', name: 'category', component: Category },
  { path: '/summary', name: 'summary', component: Summary },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router;