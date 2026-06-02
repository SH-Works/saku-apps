import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../transaction/presentation/providers/transaction_provider.dart';
import '../../../transaction/presentation/widgets/transaction_item.dart';
import '../widgets/search_bar_widget.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearQuery() {
    ref.read(searchQueryProvider.notifier).state = '';
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        ref.read(searchQueryProvider.notifier).state = value;
      }
    });
  }

  void _onBack() {
    _clearQuery();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              size: 24,
            ),
            onPressed: _onBack,
          ),
          title: const Text(AppStrings.searchTransactions),
          toolbarHeight: 64,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SearchBarWidget(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                onChanged: _onQueryChanged,
                onClear: _clearQuery,
              ),
            ),
            Expanded(
              child: query.isEmpty
                  ? const _SearchEmptyHint()
                  : results.isEmpty
                      ? _SearchNoResults(query: query)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: results.length,
                          separatorBuilder: (context, index) =>
                              const Divider(indent: 56, height: 1),
                          itemBuilder: (_, i) =>
                              TransactionItem(transaction: results[i]),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchEmptyHint extends StatelessWidget {
  const _SearchEmptyHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              size: 48,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.searchEmptyHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchNoResults extends StatelessWidget {
  final String query;
  const _SearchNoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          '${AppStrings.searchNoResults} "$query"',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.secondary,
              ),
        ),
      ),
    );
  }
}
