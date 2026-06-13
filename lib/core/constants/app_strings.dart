class AppStrings {
  AppStrings._();

  static const appName = 'Saku';
  static const appMotto = 'Catat. Pantau. Hemat.\nSemua di saku Anda.\n SAKU';

  // Tab
  static const tabHome = 'Beranda';
  static const tabAdd = 'Tambah';
  static const tabHistory = 'Riwayat';
  static const tabReport = 'Laporan';

  // Beranda
  static const recentTransactions = 'Transaksi Terbaru';
  static const seeAll = 'Lihat Semua';
  static const balance = 'Saldo';
  static const income = 'Pemasukan';
  static const expense = 'Pengeluaran';
  static const noTransactions = 'Belum ada transaksi';
  static const startTracking = 'Ketuk + untuk mencatat transaksi pertama Anda';

  // Tambah Transaksi
  static const newTransaction = 'Transaksi Baru';
  static const amount = 'Jumlah';
  static const category = 'Kategori';
  static const date = 'Tanggal';
  static const notes = 'Catatan';
  static const save = 'Simpan';
  static const cancel = 'Batal';
  static const optionalNotes = 'Tambahkan catatan (opsional)';
  static const selectCategory = 'Pilih kategori';
  static const enterAmount = 'Masukkan jumlah lebih dari 0';

  // Riwayat
  static const history = 'Riwayat';
  static const all = 'Semua';

  // Cari
  static const search = 'Cari';
  static const searchTransactions = 'Cari Transaksi';
  static const searchHint = 'Cari transaksi...';
  static const searchEmptyHint =
      'Cari berdasarkan kategori, catatan, atau jumlah';
  static const searchNoResults = 'Tidak ada hasil untuk';

  // Laporan
  static const report = 'Laporan';
  static const totalIncome = 'Total Pemasukan';
  static const totalExpense = 'Total Pengeluaran';
  static const netBalance = 'Saldo Bersih';
  static const categoryBreakdown = 'Rincian Kategori';
  static const dailySpending = 'Pengeluaran Harian';
  static const reset = 'Atur Ulang';
  static const clearAllData = 'Hapus Semua Data';
  static const clearAllDataConfirm =
      'Semua transaksi akan dihapus permanen.\nTindakan ini tidak dapat dibatalkan.';
  static const clearAllDataAction = 'Hapus Semua';

  // Pengaturan / umum
  static const settings = 'Pengaturan';
  static const delete = 'Hapus';
  static const confirmDelete = 'Hapus transaksi ini?';
  static const confirm = 'Konfirmasi';
  static const addTransaction = 'Tambah Transaksi';

  // Settings — sections
  static const sectionAppearance = 'Tampilan';
  static const sectionNotifications = 'Notifikasi';
  static const sectionData = 'Data';
  static const sectionAbout = 'Tentang';

  // Settings — appearance
  static const theme = 'Tema';
  static const themeSystem = 'Sistem';
  static const themeLight = 'Terang';
  static const themeDark = 'Gelap';

  // Settings — notifications
  static const dailyReminder = 'Pengingat Harian';
  static const reminderTime = 'Waktu Notifikasi';

  // Settings — data
  static const exportCsv = 'Ekspor Data (CSV)';
  static const exportSuccess = 'Data berhasil diekspor';

  // Settings — about
  static const appVersion = 'Versi Aplikasi';
  static const builtWith = 'Dibuat oleh';

  // Wallet
  static const wallets = 'Dompet';
  static const allWallets = 'Semua';
  static const wallet = 'Dompet';
  static const walletBalance = 'Saldo Dompet';
  static const addWallet = 'Tambah Dompet';
  static const editWallet = 'Edit Dompet';
  static const walletName = 'Nama Dompet';
  static const walletNameHint = 'cth. Kas, BCA, Dana';
  static const walletNameRequired = 'Nama dompet tidak boleh kosong';
  static const walletIcon = 'Ikon';
  static const walletInitialBalance = 'Saldo Awal';
  static const walletInitialBalanceHint =
      'Saldo sebelum menggunakan aplikasi ini';
  static const deleteWallet = 'Hapus Dompet';
  static const deleteWalletConfirm =
      'Dompet ini akan dihapus. Transaksi yang terhubung tidak akan terhapus.';
  static const setAsDefault = 'Jadikan Utama';
  static const noWallets = 'Belum ada dompet';
  static const noWalletsSubtitle =
      'Tambahkan dompet untuk mulai mengelola keuangan Anda';
  static const noTransactionsForWallet = 'Belum ada transaksi di dompet ini';

  // Budget
  static const budget = 'Budget';
  static const setBudget = 'Atur Budget';
  static const budgetLimit = 'Limit Budget';
  static const budgetMonth = 'Bulan';
  static const budgetEnterLimit = 'Masukkan limit lebih dari 0';
  static const noBudgets = 'Belum ada budget untuk bulan ini';
  static const budgetTotalLimit = 'Total Limit';
  static const budgetTotalSpent = 'Terpakai';
  static const budgetRemaining = 'Sisa';
  static const budgetOverLimit = 'Melebihi budget';
  static const budgetThisMonth = 'Bulan ini';
  static const budgetAlertNearLimit = 'budget mendekati limit';
  static const budgetAlertExceeded = 'budget melebihi limit';
  static const budgetVsActual = 'Budget vs Aktual';
  static const budgetSetLink = 'Atur budget untuk bulan ini →';

  // Transfer
  static const transfer = 'Transfer';
  static const transferAction = 'Transfer Sekarang';
  static const transferFrom = 'Dari';
  static const transferTo = 'Ke';
  static const transferHistory = 'Riwayat Transfer';
  static const transferSuccess = 'Transfer berhasil';
  static const transferDifferentWallets = 'Pilih dompet yang berbeda';
  static const transferEnterAmount = 'Masukkan jumlah lebih dari 0';
  static const transferNeedTwoWallets =
      'Butuh minimal 2 dompet untuk melakukan transfer';
  static const transferNotesHint = 'Tambahkan catatan (opsional)';
  static const transferUndoTitle = 'Batalkan transfer?';
  static const transferUndoConfirm =
      'Transfer ini akan dihapus dan saldo dompet akan disesuaikan.';
  static const noTransfers = 'Belum ada transfer';
  static const transferTab = 'Transfer';

  // Error
  static const errorPrefix = 'Terjadi kesalahan';
  static const failedToSave = 'Gagal menyimpan';
}
