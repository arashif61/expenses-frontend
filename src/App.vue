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
      <q-btn flat label="倹約！" @click="goToRoute('home')" />
      <q-space />
      <q-tabs inline-label v-model="page">
        <q-tab name="home" icon="account_balance" label="入出金" />
        <q-tab name="summary" icon="summarize" label="サマリ" />
        <q-tab name="category" icon="category" label="カテゴリ" />
      </q-tabs>
    </q-toolbar>
    <router-view></router-view>
  </div>
</template>
