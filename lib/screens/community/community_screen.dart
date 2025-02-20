import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kronk/riverpod/timeline_notifier_provider.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:kronk/widgets/navbar.dart';
import '../../models/post_model.dart';
import '../../riverpod/theme_notifier_provider.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<CommunityScreen> with AutomaticKeepAliveClientMixin<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final Dimensions dimensions = Dimensions.of(context);

    final double contentWidth2 = dimensions.contentWidth2;
    final double globalMargin2 = dimensions.globalMargin2;
    final double buttonHeight1 = dimensions.buttonHeight1;
    final double textSize1 = dimensions.textSize1;
    final double textSize2 = dimensions.textSize2;
    final double textSize3 = dimensions.textSize3;
    final double cornerRadius1 = dimensions.cornerRadius1;
    return Scaffold(
      backgroundColor: activeTheme.background1,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(
                  'Community',
                  style: GoogleFonts.quicksand(textStyle: TextStyle(color: activeTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
                ),
                centerTitle: true,
                actionsPadding: EdgeInsets.only(right: globalMargin2),
                elevation: 0,
                forceMaterialTransparency: true,
                // backgroundColor: activeTheme.background1,
                leading: Icon(Icons.menu_rounded, color: activeTheme.text2),
                actions: [Icon(Icons.notifications_rounded, color: activeTheme.text2)],
                floating: true,
                snap: true,
                bottom: TabBar(
                  enableFeedback: false,
                  dividerHeight: 0.1,
                  dividerColor: activeTheme.text2.withAlpha(128),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorAnimation: TabIndicatorAnimation.linear,
                  labelColor: activeTheme.text2,
                  unselectedLabelColor: activeTheme.text2.withAlpha(128),
                  labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(color: activeTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
                  indicator: UnderlineTabIndicator(
                    insets: EdgeInsets.symmetric(horizontal: globalMargin2),
                    borderSide: BorderSide(width: 4, color: activeTheme.text2),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                  ),
                  // indicator: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(50),
                  //     color: Colors.greenAccent,),
                  tabs: [const Tab(child: Text('For You')), const Tab(child: Text('Global'))],
                ),
              ),
            ];
          },
          body: const TabBarView(children: [HomeTimelineTab(), GlobalTimelineTab()]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => myLogger.i('add post'),
        shape: const CircleBorder(),
        backgroundColor: activeTheme.foreground1,
        child: Icon(Icons.add_rounded, color: activeTheme.text2),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// Home Timeline Tab with CustomScrollView
class HomeTimelineTab extends ConsumerWidget {
  const HomeTimelineTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PostModel>> homeTimeline = ref.watch(homeTimelineNotifierProvider);
    final Dimensions dimensions = Dimensions.of(context);

    final double contentWidth1 = dimensions.contentWidth1;
    final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    final double textSize1 = dimensions.textSize1;
    final double textSize2 = dimensions.textSize2;
    final double textSize3 = dimensions.textSize3;
    final double cornerRadius1 = dimensions.cornerRadius1;

    return homeTimeline.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const EmptyHomeState();
        }
        return CustomScrollView(
          slivers: [SliverList(delegate: SliverChildBuilderDelegate((context, index) => TweetCard(post: posts[index]), childCount: posts.length))],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text('Something went wrong! 😢')),
    );
  }
}

// Global Timeline Tab with CustomScrollView
class GlobalTimelineTab extends ConsumerWidget {
  const GlobalTimelineTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PostModel>> globalTimeline = ref.watch(globalTimelineNotifierProvider);
    final Dimensions dimensions = Dimensions.of(context);

    final double contentWidth1 = dimensions.contentWidth1;
    final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    final double textSize1 = dimensions.textSize1;
    final double textSize2 = dimensions.textSize2;
    final double textSize3 = dimensions.textSize3;
    final double cornerRadius1 = dimensions.cornerRadius1;

    return globalTimeline.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const EmptyGlobalState();
        }
        return CustomScrollView(
          slivers: [SliverList(delegate: SliverChildBuilderDelegate((context, index) => TweetCard(post: posts[index]), childCount: posts.length))],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text('Something went wrong! 😢')),
    );
  }
}

// Tweet Card UI
class TweetCard extends StatelessWidget {
  final PostModel post;

  const TweetCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.author, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(post.body),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.comment_outlined), onPressed: () {}),
                IconButton(icon: const Icon(Icons.repeat), onPressed: () {}),
                IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyHomeState extends StatelessWidget {
  const EmptyHomeState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('No posts yet!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Start the conversation by creating a post.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => myLogger.i('Open post creation'), child: const Text('Create a Post')),
        ],
      ),
    );
  }
}

class EmptyGlobalState extends StatelessWidget {
  const EmptyGlobalState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('No posts yet!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Start the conversation by creating a post.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => myLogger.i('Open post creation'), child: const Text('Create a Post')),
        ],
      ),
    );
  }
}
