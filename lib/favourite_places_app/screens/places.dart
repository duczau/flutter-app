import 'package:first_app/favourite_places_app/provider/place_provider.dart';
import 'package:first_app/favourite_places_app/screens/add_place.dart';
import 'package:first_app/favourite_places_app/widgets/place_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceScreen extends ConsumerStatefulWidget {
  const PlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlaceScreenState();
  }
}

class _PlaceScreenState extends ConsumerState<PlaceScreen> {
  @override
  Widget build(BuildContext context) {
    final listPlace = ref.watch(asyncUserPlaceProvider);

    Future<void> _loadItems() async {
      await Future.delayed(const Duration(seconds: 1));
      await ref.read(asyncUserPlaceProvider.notifier).reload();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        toolbarHeight: 40,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 32),
            child: IconButton(
              icon: Icon(Icons.add_circle, color: Colors.pink[300]),
              onPressed: () {
                // Navigate to the add place screen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddPlace()),
                );
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadItems,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: listPlace.when(
          data: (data) => PlaceList(places: data),
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [Center(child: CircularProgressIndicator())],
          ),
          error: (error, stackTrace) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [Center(child: Text('Error: $error'))],
          ),
        ),
      ),
    );
  }
}
