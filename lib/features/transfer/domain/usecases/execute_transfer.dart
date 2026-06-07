import '../../../transaction/domain/repositories/transaction_repository.dart';
import '../../../wallets/domain/repositories/wallet_repository.dart';
import '../../../wallets/domain/utils/wallet_balance.dart';
import '../entities/wallet_transfer.dart';
import '../repositories/transfer_repository.dart';

class InsufficientBalanceException implements Exception {
  final String message;
  InsufficientBalanceException(this.message);

  @override
  String toString() => message;
}

class ExecuteTransfer {
  final TransferRepository transferRepo;
  final WalletRepository walletRepo;
  final TransactionRepository transactionRepo;

  ExecuteTransfer(this.transferRepo, this.walletRepo, this.transactionRepo);

  Future<void> call(WalletTransfer transfer) async {
    if (transfer.fromWalletId == transfer.toWalletId) {
      throw Exception('Dompet asal dan tujuan harus berbeda');
    }
    if (transfer.amount <= 0) {
      throw Exception('Jumlah transfer harus lebih dari 0');
    }

    final fromWallet = walletRepo.getWalletById(transfer.fromWalletId);
    if (fromWallet == null) {
      throw Exception('Dompet asal tidak ditemukan');
    }

    final toWallet = walletRepo.getWalletById(transfer.toWalletId);
    if (toWallet == null) {
      throw Exception('Dompet tujuan tidak ditemukan');
    }

    final transactions = await transactionRepo.getAllTransactions();
    final transfers = transferRepo.getAllTransfers();

    final balance = computeWalletBalance(
      wallet: fromWallet,
      transactions: transactions,
      transfers: transfers,
    );

    if (balance < transfer.amount) {
      throw InsufficientBalanceException(
        'Saldo tidak cukup di ${fromWallet.name}',
      );
    }

    await transferRepo.saveTransfer(transfer);
  }
}
