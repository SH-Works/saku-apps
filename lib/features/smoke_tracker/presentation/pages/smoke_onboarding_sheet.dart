// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/smoke_settings.dart';
import '../providers/smoke_provider.dart';

class SmokeOnboardingSheet extends ConsumerStatefulWidget {
  const SmokeOnboardingSheet({super.key});

  @override
  ConsumerState<SmokeOnboardingSheet> createState() =>
      _SmokeOnboardingSheetState();
}

class _SmokeOnboardingSheetState extends ConsumerState<SmokeOnboardingSheet> {
  int _step = 0;
  int _cigarettesPerPack = 20;
  int _pricePerPack = 25000;
  int _dailyLimit = 15;
  bool _notifyAt80 = true;
  bool _notifyAtLimit = true;
  bool _saving = false;

  int get _pricePerCigarette =>
      _cigarettesPerPack > 0 ? _pricePerPack ~/ _cigarettesPerPack : 0;

  Future<void> _finish({bool useDefaults = false}) async {
    setState(() => _saving = true);
    final settings = SmokeSettings.defaults().copyWith(
      isEnabled: true,
      cigarettesPerPack: useDefaults ? 20 : _cigarettesPerPack,
      pricePerPack: useDefaults ? 25000 : _pricePerPack,
      dailyLimit: useDefaults ? 15 : _dailyLimit,
      notifyAt80Percent: useDefaults ? true : _notifyAt80,
      notifyAtLimit: useDefaults ? true : _notifyAtLimit,
    );
    await ref.read(updateSmokeSettingsProvider).call(settings);
    ref.invalidate(smokeSettingsProvider);
    if (mounted) {
      Navigator.of(context).pop();
      context.push('/smoke');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (i) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _step
                                ? AppColors.black
                                : AppColors.secondary.withOpacity(0.4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    if (_step == 0) ...[
                      Text(
                        AppStrings.smokeOnboardingStep1,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _Field(
                        label: AppStrings.smokePerPack,
                        value: _cigarettesPerPack,
                        onChanged: (v) =>
                            setState(() => _cigarettesPerPack = v),
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: AppStrings.smokePricePerPack,
                        value: _pricePerPack,
                        prefix: 'Rp ',
                        onChanged: (v) => setState(() => _pricePerPack = v),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${AppStrings.smokePricePerCigarette}: ${formatRupiah(_pricePerCigarette)}',
                        style: const TextStyle(color: AppColors.secondary),
                      ),
                    ] else ...[
                      Text(
                        AppStrings.smokeOnboardingStep2,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _Field(
                        label: AppStrings.smokeDailyLimitLabel,
                        value: _dailyLimit,
                        onChanged: (v) => setState(() => _dailyLimit = v),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(AppStrings.smokeNotify80),
                        value: _notifyAt80,
                        activeColor: AppColors.black,
                        onChanged: (v) => setState(() => _notifyAt80 = v),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(AppStrings.smokeNotifyLimit),
                        value: _notifyAtLimit,
                        activeColor: AppColors.black,
                        onChanged: (v) => setState(() => _notifyAtLimit = v),
                      ),
                    ],
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saving
                          ? null
                          : () {
                              if (_step == 0) {
                                setState(() => _step = 1);
                              } else {
                                _finish();
                              }
                            },
                      child: Text(
                        _step == 0
                            ? AppStrings.smokeNext
                            : AppStrings.smokeStartTracking,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _saving ? null : () => _finish(useDefaults: true),
                      child: const Text(AppStrings.smokeSkipForNow),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final int value;
  final String? prefix;
  final ValueChanged<int> onChanged;

  const _Field({
    required this.label,
    required this.value,
    this.prefix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: '$value'),
          decoration: InputDecoration(
            prefixText: prefix,
            hintText: '$value',
          ),
          onChanged: (v) {
            final parsed = int.tryParse(v.replaceAll('.', ''));
            if (parsed != null) onChanged(parsed);
          },
        ),
      ],
    );
  }
}
