import '../../../transaction/domain/entities/transaction.dart';
import '../../../transfer/domain/entities/wallet_transfer.dart';
import '../entities/wallet.dart';

/// Live wallet balance:
/// seedBalance + income − expense + incoming transfers − outgoing transfers
int computeWalletBalance({
  required Wallet wallet,
  required List<Transaction> transactions,
  required List<WalletTransfer> transfers,
}) {
  var balance = wallet.seedBalance;

  for (final tx in transactions.where((t) => t.walletId == wallet.id)) {
    if (tx.type == TransactionType.income) {
      balance += tx.amount;
    } else {
      balance -= tx.amount;
    }
  }

  for (final transfer in transfers) {
    if (transfer.fromWalletId == wallet.id) balance -= transfer.amount;
    if (transfer.toWalletId == wallet.id) balance += transfer.amount;
  }

  return balance;
}
