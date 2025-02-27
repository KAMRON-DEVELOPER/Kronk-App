import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:kronk/widgets/navbar.dart';
import '../../riverpod/theme_notifier_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with AutomaticKeepAliveClientMixin<ChatScreen> {
  late TextEditingController _searchController;
  late Future<List<String>> _futureUsernames;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureUsernames = getUsers(); // Initial fetch (empty query)
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<String>> getUsers({String query = ''}) async {
    try {
      final response = await dio.get(
        'http://192.168.31.43:8000/users/usernames',
        queryParameters: {'username_query': query}, // ✅ Send query parameter
      );

      if (response.statusCode == 200 && response.data is List) {
        return List<String>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      myLogger.e('Error fetching usernames: $e');
      return [];
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _futureUsernames = getUsers(query: value); // 🔄 Update future with query
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      backgroundColor: activeTheme.background2,
      appBar: AppBar(title: const Text('Chat Screen'), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged, // ✅ Trigger search on input change
              decoration: InputDecoration(
                filled: true,
                fillColor: activeTheme.background1,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                hintText: 'Search',
                hintStyle: TextStyle(color: activeTheme.text2.withAlpha(128), fontSize: 16),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                prefixIcon: Icon(Icons.search_rounded, color: activeTheme.text2.withAlpha(128)),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: FutureBuilder<List<String>>(
                future: _futureUsernames, // 🔄 Updated dynamically
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching users', style: TextStyle(color: Colors.red)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }

                  final usernames = snapshot.data!;

                  return ListView.builder(
                    itemCount: usernames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.person_rounded, color: activeTheme.text2.withAlpha(32)),
                        title: Text(usernames[index], style: TextStyle(color: activeTheme.text2, fontSize: 16)),
                        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.add, color: activeTheme.text2.withAlpha(32))),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
