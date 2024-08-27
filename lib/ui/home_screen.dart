import 'package:flutter/material.dart';

import '../api/api_service.dart';

/// Home Screen displaying a list of todos with pagination
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic>? _apiData;
  int _start = 0;
  late final ScrollController scrollController;
  bool _isLoadingMore = false;
  bool _canLoadMore = true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        // Load more data when reaching the end of the list
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          _start += 20;
          _fetchData();
        }
      });
    _fetchData(); // Initial data fetch
  }

  /// Fetches data from the API with pagination and caching
  Future<void> _fetchData() async {
    if (!_canLoadMore || _isLoadingMore) return;

    _isLoadingMore = true;
    setState(() {});

    final data = await ApiService.instance.getDataFromApi(_start);

    _isLoadingMore = false;

    if ((data?.length ?? 0) < 20) {
      _canLoadMore = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('End of pagination')));
    }

    setState(() {
      _apiData ??= [];
      _apiData?.addAll(data ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              _apiData = null;
              setState(() {});
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Center(
        child: _apiData == null
            ? const CircularProgressIndicator()
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (_isLoadingMore && index == _apiData!.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final item = _apiData![index];
                  return ListTile(
                    title: Text(item['title']),
                    subtitle: Text(item['completed'] ? 'Completed' : 'Pending'),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: _apiData!.length + (_isLoadingMore ? 1 : 0),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _start = 0;
          _apiData = [];
          _canLoadMore = true;
          _fetchData();
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
