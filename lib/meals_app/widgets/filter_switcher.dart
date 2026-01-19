import 'package:first_app/meals_app/provider/meals_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterSwitches extends ConsumerStatefulWidget {
  const FilterSwitches({
    super.key,
    required this.mapFilter,
    required this.onFilterChanged,
  });
  final Map<String, bool> mapFilter;
  final void Function(Map<String, bool>) onFilterChanged;

  @override
  ConsumerState<FilterSwitches> createState() => _FilterSwitchesState();
}

class _FilterSwitchesState extends ConsumerState<FilterSwitches> {
  @override
  Widget build(BuildContext context) {
    final activeFilters = ref.read(filteredMealsProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Filter screen")),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return; // Đã pop rồi, không làm gì
          }

          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Exit game?'),
              content: Text('Your progress will be lost'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('Continue playing'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text('Exit'),
                ),
              ],
            ),
          );

          if (shouldExit == true && context.mounted) {
            ref.read(filteredMealsProvider.notifier).setFilters(activeFilters);
            Navigator.pop(context, null);
          }
        },
        child: Column(
          children: [
            for (String filter in activeFilters.keys)
              SwitchListTile(
                title: Text(filter),
                activeThumbColor: const Color.fromARGB(255, 85, 68, 5),
                value: activeFilters[filter]!,
                onChanged: (isCheck) {
                  setState(() {
                    activeFilters[filter] = isCheck;
                  });
                  // widget.onFilterChanged(widget.mapFilter);
                },
              ),
          ],
        ),
      ),
    );
  }
}
