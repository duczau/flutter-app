import 'package:flutter/material.dart';

class FilterSwitches extends StatefulWidget {
  const FilterSwitches({
    super.key,
    required this.mapFilter,
    required this.onFilterChanged,
  });
  final Map<String, bool> mapFilter;
  final void Function(Map<String, bool>) onFilterChanged;

  @override
  State<FilterSwitches> createState() => _FilterSwitchesState();
}

class _FilterSwitchesState extends State<FilterSwitches> {
  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context, widget.mapFilter);
          }
        },
        child: Column(
          children: [
            for (String filter in widget.mapFilter.keys)
              SwitchListTile(
                title: Text(filter),
                activeThumbColor: const Color.fromARGB(255, 85, 68, 5),
                value: widget.mapFilter[filter]!,
                onChanged: (isCheck) {
                  setState(() {
                    widget.mapFilter[filter] = isCheck;
                  });
                  widget.onFilterChanged(widget.mapFilter);
                },
              ),
          ],
        ),
      ),
    );
  }
}
