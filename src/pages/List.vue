<script setup lang="ts">
import { onMounted, ref, computed, watch, Ref } from "vue";
import axios from "axios";
import { QTableColumn } from "quasar";
import DepositWithdrawalRow from "../interface/DepositWithdrawalRow";
import CategoryRow from "../interface/CategoryRow";

const loading = ref(true);
const createDialog = ref(false);
const selectedRow: Ref<DepositWithdrawalRow | null> = ref(null);
const balance = ref(0);

(async () => {
  console.log("Before create");
})();

const columns: QTableColumn<DepositWithdrawalRow>[] = [
  {
    name: 'date', align: 'left', label: '日付', field: 'date',
    format: (val: string | number | Date) => new Date(val).toLocaleDateString("ja-JP", {
      day: "2-digit"
    })
  },
  { name: 'categoryId', label: '', field: 'categoryId', align: 'left', style: "max-width: 34px;" },
  {
    name: 'content', align: 'left', label: '内容', field: 'content',
    style: "max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"
  },
  { name: 'amount', align: 'right', label: '金額', field: 'amount', format: (val: number) => val.toLocaleString() },
]
const depositWithdrawalList: Ref<DepositWithdrawalRow[]> = ref([]);
const yearMonthList = ref([]);
const options: Ref<CategoryRow[]> = ref([]);

const initialPagination = {
  rowsPerPage: 100
}

const getDepositWithdrawalList = async (yearMonth: string) => {
  const result = await axios.get(`/api/v1/depositWithdrawal?date=${yearMonth}`);
  depositWithdrawalList.value = result.data.list;
  const balanceResult = await axios.get("/api/v1/balance");
  balance.value = balanceResult.data.balance;
}

const searchContent = ref("");
const filter = computed(() => {
  return {
    searchContent: searchContent.value
  }
});
const filteringData = (rows: readonly any[]) => {
  let retRows = rows
  if (filter.value.searchContent.length > 0) {
    retRows = retRows.filter(row => row.content.toLowerCase().includes(filter.value.searchContent.toLowerCase()))
  }

  return retRows
}

const selectedYearMonth = ref();

(async () => {
  console.log("created");
})();

onMounted(async () => {
  loading.value = true;

  console.log("mounted");
  getDepositWithdrawalList(new Date().toLocaleDateString("ja-JP", {
    year: "numeric", month: "2-digit"
  }).replaceAll('/', '-'));
  const resultYearMonths = await axios.get(`/api/v1/yearMonth`);
  yearMonthList.value = resultYearMonths.data.yearMonthList;
  selectedYearMonth.value = resultYearMonths.data.yearMonthList[0];

  const categoryResultList = await axios.get("/api/v1/category");
  options.value = categoryResultList.data.list;

  loading.value = false;
});

watch(selectedYearMonth, async (newYearMonth) => {
  getDepositWithdrawalList(newYearMonth.id);
});

const onCategoryChange = async (row: any, newCategoryId: any) => {
  const index = depositWithdrawalList.value.findIndex((item: any) => item === row);
  await axios.put("/api/v1/depositWithdrawalCategory", {
    date: depositWithdrawalList.value[index].date,
    content: depositWithdrawalList.value[index].content,
    amount: depositWithdrawalList.value[index].amount,
    categoryId: newCategoryId
  });

  getDepositWithdrawalList(selectedYearMonth.value.id);
};

const getOption = (categoryId: number): { id: number | bigint, color: string, icon: string, name: string } => {
  return options.value.filter(item => categoryId == item.id)[0]
}

const setDialogCreate = async (row: DepositWithdrawalRow) => {
  selectedRow.value = row;
  createDialog.value = true;
}

const setDate = (date: string | undefined) => {
  if (date == undefined) {
    return "N/A";
  }
  return new Date(date).toLocaleDateString("ja-JP", {
    year: "numeric", month: "2-digit",
    day: "2-digit"
  });
}

</script>

<template>
  <div class="row justify-between">
    <div><span class="text-h5">残高: ¥{{ balance.toLocaleString() }}</span></div>
    <div class="row"><q-select borderless v-model="selectedYearMonth" :options="yearMonthList" option-label="label"
        option-value="id" label="年月" class="q-mr-lg" />
      <q-input dense debounce="300" v-model="searchContent" placeholder="内容">
        <template v-slot:append>
          <q-icon name="close" @click="searchContent = ''" class="cursor-pointer" />
        </template>
      </q-input>
    </div>
  </div>
  <div>
    <q-table v-if="!loading" flat bordered dense :rows="depositWithdrawalList" :columns="columns" row-key="id"
      :pagination="initialPagination" :filter="filter" :filter-method="filteringData">
      <template v-slot:body-cell-categoryId="props">
        <q-td :props="props">
          <q-avatar @click="setDialogCreate(props.row)" round size="sm" text-color="white"
            :color="getOption(props.row.categoryId).color" :icon="getOption(props.row.categoryId).icon">
          </q-avatar>
        </q-td>
      </template>
    </q-table>
  </div>

  <q-dialog v-model="createDialog">
    <q-card>
      <q-card-section class="row items-center q-pb-none">
        <div class="text-h6">カテゴリ変更</div>
        <q-space />
        <q-btn icon="close" flat round dense v-close-popup />
      </q-card-section>
      <q-card-section>
        <div class="q-mt-sm">
          <div>日付: {{ setDate(selectedRow?.date) }}</div>
          <div>内容: {{ selectedRow?.content }}</div>
          <div>金額: {{ selectedRow?.amount }}</div>
          <span v-for="category in options">
            <q-chip clickable text-color="white" :selected="selectedRow?.categoryId === category.id" v-close-popup
              :color="category.color" @click="onCategoryChange(selectedRow, category.id)">
              <q-icon :name="category.icon" />
              {{ category.name }}
            </q-chip>
          </span>
        </div>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>
