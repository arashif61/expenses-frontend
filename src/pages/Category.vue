<script setup lang="ts">
import { onMounted, Ref, ref } from "vue";
import axios from "axios";
import CategoryRow from "../interface/CategoryRow";

const loading = ref(true);

const colorList = ["red", "pink", "purple", "deep-purple", "indigo", "blue", "light-blue",
  "cyan", "teal", "green", "light-green", "lime", "yellow", "amber", "orange", "deep-orange",
  "brown", "grey", "blue-grey"];

const iconList = [
  "local_grocery_store",
  "restaurant",
  "house",
  "electrical_services",
  "tv",
  "medication",
  "photo_camera",
  "library_books",
  "drive_eta",
  "account_balance_wallet",
  "help"
];

(async () => {
  console.log("Before create");
})();

const categoryList: Ref<CategoryRow[]> = ref([]);

(async () => {
  console.log("created");
})();

const getCategoryList = async () => {
  const result = await axios.get("/api/v1/category");
  categoryList.value = result.data.list;
}

onMounted(async () => {
  loading.value = true;

  console.log("mounted");

  await getCategoryList();

  loading.value = false;
});

const createDialog = ref(false);

const okay = async () => {
  if (inputId.value == null) {
    await axios.post("/api/v1/category", {
      name: inputName.value,
      icon: selectedIcon.value,
      color: selectedColor.value
    });

  } else {
    await axios.put(`/api/v1/category/${inputId.value}`, {
      name: inputName.value,
      icon: selectedIcon.value,
      color: selectedColor.value
    });
  }

  await getCategoryList();
}

const deleteCategory = async () => {
  const confirmResult = confirm('削除しますか？')
  if (confirmResult) {
    await axios.delete(`/api/v1/category/${inputId.value}`)
    await getCategoryList();
  }
}

const inputId: Ref<bigint | number | null> = ref(null);
const inputName = ref("");
const selectedColor = ref("");
const selectedIcon = ref("");

const selectColor = (color: string) => {
  if (selectedColor.value === color) {
    selectedColor.value = "";
  } else {
    selectedColor.value = color;
  }
};

const selectIcon = (icon: string) => {
  if (selectedIcon.value === icon) {
    selectedIcon.value = "";
  } else {
    selectedIcon.value = icon;
  }
};

const setDialogCreate = async () => {
  inputId.value = null;
  inputName.value = "";
  selectedIcon.value = "";
  selectedColor.value = "";
  createDialog.value = true;
}

const setDialogEdit = async (id: bigint | number) => {
  inputId.value = id;
  const result = await axios.get(`/api/v1/category/${id}`);
  const category = result.data.category;
  inputName.value = category.name;
  selectedIcon.value = category.icon;
  selectedColor.value = category.color;
  createDialog.value = true;
}
</script>

<template>
  <!-- <div><span class="text-h4">カテゴリ一覧</span></div> -->
  <div class="q-py-md">
    <q-chip clickable @click="setDialogCreate" color="white" text-color="primary" icon="add_circle">
      追加する
    </q-chip>
    <span v-for="category in categoryList">
      <q-chip clickable @click="setDialogEdit(category.id)" :color="category.color" text-color="white"
        :icon="category.icon">
        {{ category.name }}
      </q-chip>
    </span>
  </div>
  <q-dialog v-model="createDialog" persistent>
    <q-card>
      <q-card-section>
        <q-input v-model="inputName" label="カテゴリ名" />
        <div class="q-mt-sm">
          <div>アイコン</div>
          <span v-for="icon in iconList">
            <q-chip clickable text-color="black" :selected="selectedIcon === icon" @click="selectIcon(icon)">
              <q-icon :name="icon" />
            </q-chip>
          </span>
        </div>
        <div class="q-mt-sm">
          <div>カラー</div>
          <span v-for="color in colorList">
            <q-chip clickable :color="color" text-color="white" :selected="selectedColor === color"
              @click="selectColor(color)">
              {{ color }}
            </q-chip>
          </span>
        </div>
      </q-card-section>
      <q-card-actions align="right">
        <q-btn flat label="OK" color="primary" v-close-popup @click="okay" />
        <q-btn flat label="キャンセル" color="secondary" v-close-popup />
        <q-btn flat color="negative" v-close-popup @click="deleteCategory"><q-icon name="delete" /></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>
