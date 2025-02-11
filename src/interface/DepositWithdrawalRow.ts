interface DepositWithdrawalRow {
  id: number | bigint,
  date: string,
  content: string,
  amount: number | bigint,
  categoryId: number | bigint
}

export default DepositWithdrawalRow;
