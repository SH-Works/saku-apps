import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/providers/transaction_provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        toolbarHeight: 64,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          // ─── Tampilan ───────────────────────────────────────────
          const _SectionHeader(label: AppStrings.sectionAppearance),
          _Section(
            children: [
              _SettingsTile(
                title: AppStrings.theme,
                bottom: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text(AppStrings.themeSystem),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text(AppStrings.themeLight),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text(AppStrings.themeDark),
                        ),
                      ],
                      selected: {settings.themeMode},
                      showSelectedIcon: false,
                      onSelectionChanged: (s) => ref
                          .read(settingsProvider.notifier)
                          .setThemeMode(s.first),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ─── Notifikasi ──────────────────────────────────────────
          const _SectionHeader(label: AppStrings.sectionNotifications),
          _Section(
            children: [
              _SettingsTile(
                title: AppStrings.dailyReminder,
                trailing: Switch(
                  value: settings.notifEnabled,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).setNotifEnabled(v),
                ),
              ),
              if (settings.notifEnabled) ...[
                const Divider(height: 1, indent: 16, endIndent: 0),
                _SettingsTile(
                  title: AppStrings.reminderTime,
                  trailing: Text(
                    '${settings.notifHour.toString().padLeft(2, '0')}:'
                    '${settings.notifMinute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: settings.notifHour,
                        minute: settings.notifMinute,
                      ),
                    );
                    if (picked != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setNotifTime(picked.hour, picked.minute);
                    }
                  },
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // ─── Data ────────────────────────────────────────────────
          const _SectionHeader(label: AppStrings.sectionData),
          _Section(
            children: [
              _SettingsTile(
                title: AppStrings.exportCsv,
                trailing: const Icon(
                  Icons.ios_share_rounded,
                  size: 18,
                  color: AppColors.secondary,
                ),
                onTap: () => _exportCsv(context, ref),
              ),
              const Divider(height: 1, indent: 16, endIndent: 0),
              _SettingsTile(
                title: AppStrings.clearAllData,
                titleColor: Colors.red,
                onTap: () => _confirmClearAll(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ─── Tentang ─────────────────────────────────────────────
          const _SectionHeader(label: AppStrings.sectionAbout),
          _Section(
            children: [
              _SettingsTile(
                title: AppStrings.appVersion,
                trailing: const Text(
                  '1.0.0',
                  style: TextStyle(color: AppColors.secondary, fontSize: 15),
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 0),
              _SettingsTile(
                title: AppStrings.builtWith,
                trailing: const Text(
                  'SH Works',
                  style: TextStyle(color: AppColors.secondary, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final txsAsync = ref.read(allTransactionsStreamProvider);
    final txs = txsAsync.valueOrNull ?? [];

    final buffer = StringBuffer();
    buffer.writeln('ID,Tipe,Jumlah,Kategori,Tanggal,Catatan,Dibuat');
    for (final tx in txs) {
      final type = tx.type == TransactionType.income
          ? 'Pemasukan'
          : 'Pengeluaran';
      final notes = (tx.notes ?? '').replaceAll(',', ';');
      buffer.writeln(
        '${tx.id},$type,${tx.amount},${tx.categoryId},'
        '${tx.date.toIso8601String()},$notes,${tx.createdAt.toIso8601String()}',
      );
    }

    final dir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/saku_export_$ts.csv');
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles([
      XFile(file.path, mimeType: 'text/csv'),
    ], subject: 'Data Transaksi Saku');
  }

  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.clearAllData),
        content: const Text(AppStrings.clearAllDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              AppStrings.clearAllDataAction,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(deleteAllTransactionsUseCaseProvider).call();
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final List<Widget> children;
  const _Section({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final Widget? bottom;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    this.titleColor,
    this.trailing,
    this.bottom,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            ?bottom,
          ],
        ),
      ),
    );
  }
}
