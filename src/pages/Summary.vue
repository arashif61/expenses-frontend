<script setup lang="ts">
import { onMounted, ref } from "vue";
// import axios from "axios";

const loading = ref(true);

(async () => {
  console.log("Before create");
})();

(async () => {
  console.log("created");
})();

onMounted(async () => {
  loading.value = true;

  console.log("mounted");

  loading.value = false;
});

</script>

<template>
  <div>準備中</div>
</template>
