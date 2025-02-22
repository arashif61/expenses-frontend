<script setup lang="ts">
import { onMounted, ref } from "vue";
import { GChart } from 'vue-google-charts';
// import axios from "axios";

const loading = ref(true);

const chartData = [
  ['Month', '食料品', '日用品', '未分類'],
  ['2024/11', 1000, 400, 200],
  ['2024/12', 1170, 460, 250],
  ['2025/01', 660, 1120, 300],
  ['2025/02', 1030, 540, 350]
];
const chartOptions = {
  legend: { position: 'bottom' }
};

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
  <div id="contents">
    <GChart type="LineChart" :data="chartData" :options="chartOptions" />
  </div>
</template>
