// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/recuring_transaction.dart';
import '../providers/recuring_provider.dart';
import '../widgets/recuring_item.dart';
import 'add_recurring_page.dart';

class RecuringPage extends ConsumerWidget {
  const RecuringPage({super.key});

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddRecurringPage(),
    );
  }

  Future<bool> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    RecuringTransaction recurring,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.recuringDeleteTitle),
        content: Text('${AppStrings.confirmDelete} "${recurring.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: Theme.of(ctx).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(deleteRecurringProvider).call(recurring.id);
    }
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringAsync = ref.watch(allRecurringProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.recuring),
        toolbarHeight: 64,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAdd(context),
        child: const Icon(Icons.add),
      ),
      body: recurringAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedRepeat,
                      size: 56,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.recuringEmpty,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          final active = list.where((r) => r.isActive).toList();
          final inactive = list.where((r) => !r.isActive).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            children: [
              if (active.isNotEmpty) ...[
                const _SectionHeader(label: AppStrings.recuringActive),
                ...active.map(
                  (r) => RecuringItem(
                    recurring: r,
                    onToggle: () =>
                        ref.read(toggleRecurringActiveProvider).call(r.id),
                    onDeleteConfirm: () => _confirmDelete(context, ref, r),
                  ),
                ),
              ],
              if (inactive.isNotEmpty) ...[
                if (active.isNotEmpty) const SizedBox.shrink()
                else const SizedBox(height: 16),
                const _SectionHeader(label: AppStrings.recuringInactive),
                ...inactive.map(
                  (r) => RecuringItem(
                    recurring: r,
                    onToggle: () =>
                        ref.read(toggleRecurringActiveProvider).call(r.id),
                    onDeleteConfirm: () => _confirmDelete(context, ref, r),
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
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
