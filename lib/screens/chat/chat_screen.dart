import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kronk/riverpod/timeline_notifier_provider.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:kronk/widgets/navbar.dart';
import 'package:page_transition/page_transition.dart';
import '../../models/post_model.dart';
import '../../riverpod/theme_notifier_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with AutomaticKeepAliveClientMixin<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    // final Dimensions dimensions = Dimensions.of(context);

    // final double contentWidth2 = dimensions.contentWidth2;
    // final double globalMargin2 = dimensions.globalMargin2;
    // final double buttonHeight1 = dimensions.buttonHeight1;
    // final double textSize1 = dimensions.textSize1;
    // final double textSize2 = dimensions.textSize2;
    // final double textSize3 = dimensions.textSize3;
    // final double cornerRadius1 = dimensions.cornerRadius1;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                title: Text('Community'),
                leading: Icon(Icons.menu_rounded),
                actions: [Icon(Icons.notifications_rounded)],
                floating: true,
                snap: true,
                bottom: TabBar(tabs: [Tab(text: 'For You'), Tab(text: 'Global')]),
              ),
            ];
          },
          body: const TabBarView(children: [HomeTimelineTab(), GlobalTimelineTab()]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushTransition(type: PageTransitionType.rightToLeft, child: const PostCreateScreen()),
        child: const Icon(Icons.add_rounded),
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
    // final Dimensions dimensions = Dimensions.of(context);

    // final double contentWidth1 = dimensions.contentWidth1;
    // final double globalMargin1 = dimensions.globalMargin1;
    // final double buttonHeight1 = dimensions.buttonHeight1;
    // final double textSize1 = dimensions.textSize1;
    // final double textSize2 = dimensions.textSize2;
    // final double textSize3 = dimensions.textSize3;
    // final double cornerRadius1 = dimensions.cornerRadius1;

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
    // final Dimensions dimensions = Dimensions.of(context);

    // final double contentWidth1 = dimensions.contentWidth1;
    // final double globalMargin1 = dimensions.globalMargin1;
    // final double buttonHeight1 = dimensions.buttonHeight1;
    // final double textSize1 = dimensions.textSize1;
    // final double textSize2 = dimensions.textSize2;
    // final double textSize3 = dimensions.textSize3;
    // final double cornerRadius1 = dimensions.cornerRadius1;

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

class PostCreateScreen extends ConsumerStatefulWidget {
  const PostCreateScreen({super.key});

  @override
  ConsumerState<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends ConsumerState<PostCreateScreen> {
  final FocusNode _focusNode = FocusNode();

  // final MediaController _mediaController = MediaController();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _postController = TextEditingController();
  final List<XFile> _pickedImages = [];
  XFile? _pickedVideo;
  DateTime? scheduledTime;

  Future<void> _pickMedia() async {
    final XFile? pickedFile = await _picker.pickMedia(imageQuality: 100);
    if (pickedFile != null) {
      final String fileType = pickedFile.mimeType ?? '';

      if (fileType.startsWith('image/') && _pickedVideo == null) {
        _pickedImages.add(pickedFile);
      } else if (fileType.startsWith('video/')) {
        _pickedVideo = pickedFile;
      }
    }
  }

  void _schedulePost() async {
    // TODO: Implement post scheduling logic
  }

  void _submitPost() async {
    // if (_postController.text.isEmpty && mediaFiles.isEmpty) {
    //   return;
    // }
    // final homeTimelineProvider = ref.read(homeTimelineNotifierProvider.notifier);
    // await homeTimelineProvider.fetchCreatePost(body: _postController.text.trim(), images: images, video: video, scheduledTime: scheduledTime);
    //
    // if (!context.mounted) {
    //   return;
    // }
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final Dimensions dimensions = Dimensions.of(context);

    // final double contentWidth2 = dimensions.contentWidth2;
    final double globalMargin2 = dimensions.globalMargin2;
    // final double buttonHeight1 = dimensions.buttonHeight1;
    // final double textSize1 = dimensions.textSize1;
    // final double textSize2 = dimensions.textSize2;
    // final double textSize3 = dimensions.textSize3;
    // final double cornerRadius1 = dimensions.cornerRadius1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: GestureDetector(
          onTap: () => context.pushTransition(type: PageTransitionType.leftToRight, child: const ChatScreen()),
          child: Icon(Icons.arrow_back_rounded, color: activeTheme.text2),
        ),
        actionsPadding: EdgeInsets.only(right: globalMargin2),
        actions: [
          GestureDetector(onTap: _schedulePost, child: Icon(Icons.schedule_rounded, color: activeTheme.text2)),
          SizedBox(width: globalMargin2),
          GestureDetector(onTap: _submitPost, child: Icon(Icons.send_rounded, color: activeTheme.text2)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: globalMargin2, right: globalMargin2, top: globalMargin2),
              // Profile Info
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                      SizedBox(width: globalMargin2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('kamronbek', style: GoogleFonts.quicksand(color: activeTheme.text2, fontSize: 16)),
                          Text('@kamronbek_atajanov', style: GoogleFonts.quicksand(color: activeTheme.text2.withAlpha(128), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.more_vert_rounded, color: activeTheme.text2),
                ],
              ),
            ),
            // Input text
            Container(
              padding: EdgeInsets.symmetric(horizontal: globalMargin2, vertical: globalMargin2),
              child: TextField(
                cursorColor: activeTheme.text2,
                focusNode: _focusNode,
                cursorWidth: 0.5,
                maxLength: 200,
                // minLines: 1,
                // maxLines: 5,
                maxLines: null,
                style: GoogleFonts.quicksand(color: activeTheme.text2),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "What's on your mind?",
                  hintStyle: GoogleFonts.quicksand(color: activeTheme.text2.withAlpha(128)),
                  counterStyle: GoogleFonts.quicksand(color: activeTheme.text2.withAlpha(128)),
                ),
                controller: _postController,
              ),
            ),
            // Image Placeholder
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(color: activeTheme.foreground1),
              child: GestureDetector(onTap: _pickMedia, child: Text('Add Images or Video.', style: GoogleFonts.quicksand(color: activeTheme.text2))),
            ),
            // Dismiss
            // Expanded(child: GestureDetector(onTap: () => _focusNode.unfocus())),
          ],
        ),
      ),
    );
  }
}

class MediaController {
  final ValueNotifier<List<String>> mediaFiles = ValueNotifier([]);
  final ValueNotifier<bool> isVideoSelected = ValueNotifier(false);

  void pickImage(String imagePath) {
    if (!isVideoSelected.value) {
      mediaFiles.value = [...mediaFiles.value, imagePath];
    }
  }

  void pickVideo(String videoPath) {
    isVideoSelected.value = true;
    mediaFiles.value = [videoPath];
  }

  void removeMedia(String mediaPath) {
    mediaFiles.value = mediaFiles.value.where((item) => item != mediaPath).toList();
    if (mediaFiles.value.isEmpty) {
      isVideoSelected.value = false;
    }
  }
}
