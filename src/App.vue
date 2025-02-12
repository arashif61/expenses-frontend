<script setup lang="ts">
import { Ref, ref, watch } from "vue";
import { useRouter, useRoute } from 'vue-router';

const router = useRouter();
const route = useRoute();

const page: Ref<string> = ref(route.name?.toString() || "");

function goToRoute(routeName: string) {
  router.push({ name: routeName });
}

watch(route, (newRoute) => {
  if (newRoute.name) {
    page.value = newRoute.name.toString();
  }
});

watch(page, (newPage) => {
  if (route.name !== newPage) {
    goToRoute(newPage);
  }
});
</script>

<template>
  <div class="q-pa-md">
    <q-toolbar class="bg-primary text-white shadow-2 rounded-borders q-mb-sm">
      <q-btn flat round dense>
        <q-icon name="menu" />
        <q-menu>
          <q-list>
            <q-item clickable v-ripple :active="page === 'home'" @click="page = 'home'"
              active-class="bg-primary text-white">
              <q-item-section avatar>
                <q-icon name="account_balance" />
              </q-item-section>
              <q-item-section>入出金</q-item-section>
            </q-item>
          </q-list>
          <q-list>
            <q-item clickable v-ripple :active="page === 'summary'" @click="page = 'summary'"
              active-class="bg-primary text-white">
              <q-item-section avatar>
                <q-icon name="summarize" />
              </q-item-section>
              <q-item-section>サマリ</q-item-section>
            </q-item>
          </q-list>
          <q-list>
            <q-item clickable v-ripple :active="page === 'category'" @click="page = 'category'"
              active-class="bg-primary text-white">
              <q-item-section avatar>
                <q-icon name="category" />
              </q-item-section>
              <q-item-section>カテゴリ</q-item-section>
            </q-item>
          </q-list>
        </q-menu>
      </q-btn>
      <q-btn flat label="倹約！" @click="goToRoute('home')" />
    </q-toolbar>
    <router-view></router-view>
  </div>
</template>
