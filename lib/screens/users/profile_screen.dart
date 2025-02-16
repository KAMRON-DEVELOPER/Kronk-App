import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kronk/models/user_model.dart';
import 'package:kronk/riverpod/user_notifier_provider.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/utility/extensions.dart';
import 'package:kronk/widgets/my_theme.dart';
import '../../riverpod/theme_notifier_provider.dart';
import '../../widgets/navbar.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final AsyncValue<UserModel?> asyncUser = ref.watch(asyncUserNotifierProvider);
    log('!!! building whole widgets...');
    return Scaffold(
      backgroundColor: activeTheme.background1,
      appBar: AppBar(
        backgroundColor: activeTheme.background1,
        title: Text('Profile', style: TextStyle(color: activeTheme.text3)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: activeTheme.text2),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: asyncUser.when(
        data: (UserModel? user) => user != null ? ProfileWidget(user: user) : const ProfileSkeletonWidget(),
        loading: () => const ProfileSkeletonWidget(),
        error: (Object error, StackTrace _) => Center(child: Text('Error: $error', style: TextStyle(color: activeTheme.text3))),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}

class ProfileWidget extends ConsumerStatefulWidget {
  final UserModel user;
  const ProfileWidget({super.key, required this.user});

  @override
  ConsumerState<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final dimensions = Dimensions.of(context);

    //final double contentWidth1 = dimensions.contentWidth1;
    final double contentWidth2 = dimensions.contentWidth2;
    //final double globalMargin1 = dimensions.globalMargin1;
    //final double buttonHeight1 = dimensions.buttonHeight1;
    //final double textSize1 = dimensions.textSize1;
    //final double textSize2 = dimensions.textSize2;
    final double textSize3 = dimensions.textSize3;
    final double cornerRadius1 = dimensions.cornerRadius1;
    log('!!! building profile widgets...');
    return RefreshIndicator(
      onRefresh: () async => ref.read(asyncUserNotifierProvider.notifier).fetchProfile(),
      color: activeTheme.text2,
      backgroundColor: activeTheme.foreground2,
      child: Column(
        children: [
          // profile info
          Container(
            width: contentWidth2,
            decoration: BoxDecoration(color: activeTheme.foreground1, borderRadius: BorderRadius.circular(cornerRadius1)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  child: CachedNetworkImage(
                    imageUrl: 'http://192.168.31.43:9000/dev-bucket-1/${widget.user.avatar ?? 'defaults/default-avatar.jpg'}',
                    fit: BoxFit.cover,
                    width: 96,
                    height: 96,
                    memCacheHeight: 96.cacheSize(context),
                    memCacheWidth: 96.cacheSize(context),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover, isAntiAlias: true),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(color: activeTheme.text2, strokeWidth: 2),
                    errorWidget: (context, url, error) => const Icon(Icons.error, size: 98, color: Colors.redAccent),
                  ),
                ),
                Text(widget.user.username, style: GoogleFonts.quicksand(color: activeTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
                Text(widget.user.email, style: GoogleFonts.quicksand(color: activeTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
                Text('${widget.user.avatar}', style: GoogleFonts.quicksand(color: activeTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
                Text(widget.user.id, style: GoogleFonts.quicksand(color: activeTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // TabBar
          TabBar(
            controller: tabController,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color: activeTheme.text2),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            dividerColor: activeTheme.text2.withAlpha(128),
            dividerHeight: 0,
            tabs: [
              Tab(icon: Icon(Icons.image_rounded, color: activeTheme.text2, size: 32), height: 56),
              Tab(icon: Icon(Icons.bookmark_rounded, color: activeTheme.text2, size: 32), height: 56),
              Tab(icon: Icon(Iconsax.message_search_bold, color: activeTheme.text2, size: 32), height: 56),
              Tab(icon: Icon(Icons.comment_rounded, color: activeTheme.text2, size: 32), height: 56),
            ],
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: tabController,
              children: [
                const MediaTabWidget(),
                const BookmarksTabWidget(),
                const PostsTabWidget(),
                const CommentsTabWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MediaTabWidget extends ConsumerWidget {
  const MediaTabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    //final dimensions = Dimensions.of(context);

    //final double contentWidth1 = dimensions.contentWidth1;
    //final double contentWidth2 = dimensions.contentWidth2;
    //final double globalMargin1 = dimensions.globalMargin1;
    //final double buttonHeight1 = dimensions.buttonHeight1;
    //final double textSize1 = dimensions.textSize1;
    //final double textSize2 = dimensions.textSize2;
    //final double textSize3 = dimensions.textSize3;
    //final double cornerRadius1 = dimensions.cornerRadius1;
    log('!!! building MediaTabWidget widgets...');
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverGrid.builder(
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 0),
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: currentTheme.foreground1, border: Border.all(color: currentTheme.text2.withAlpha(64), width: 0.1)),
              child: Icon(Icons.image_rounded, color: currentTheme.text2, size: 36),
            );
          },
        ),
      ],
    );
  }
}

class BookmarksTabWidget extends ConsumerWidget {
  const BookmarksTabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    //final dimensions = Dimensions.of(context);

    //final double contentWidth1 = dimensions.contentWidth1;
    //final double contentWidth2 = dimensions.contentWidth2;
    //final double globalMargin1 = dimensions.globalMargin1;
    //final double buttonHeight1 = dimensions.buttonHeight1;
    //final double textSize1 = dimensions.textSize1;
    //final double textSize2 = dimensions.textSize2;
    //final double textSize3 = dimensions.textSize3;
    //final double cornerRadius1 = dimensions.cornerRadius1;
    log('!!! building BookmarksTabWidget widgets...');
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverGrid.builder(
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 0),
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: currentTheme.foreground1, border: Border.all(color: currentTheme.text2.withAlpha(64), width: 0.1)),
              child: Icon(Icons.bookmark_rounded, color: currentTheme.text2, size: 36),
            );
          },
        ),
      ],
    );
  }
}

class PostsTabWidget extends ConsumerWidget {
  const PostsTabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    //final dimensions = Dimensions.of(context);

    //final double contentWidth1 = dimensions.contentWidth1;
    //final double contentWidth2 = dimensions.contentWidth2;
    //final double globalMargin1 = dimensions.globalMargin1;
    //final double buttonHeight1 = dimensions.buttonHeight1;
    //final double textSize1 = dimensions.textSize1;
    //final double textSize2 = dimensions.textSize2;
    //final double textSize3 = dimensions.textSize3;
    //final double cornerRadius1 = dimensions.cornerRadius1;
    log('!!! building PostsTabWidget widgets...');
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverGrid.builder(
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 0),
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: currentTheme.foreground1, border: Border.all(color: currentTheme.text2.withAlpha(64), width: 0.1)),
              child: Icon(Icons.message_rounded, color: currentTheme.text2, size: 36),
            );
          },
        ),
      ],
    );
  }
}

class CommentsTabWidget extends ConsumerWidget {
  const CommentsTabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    //final dimensions = Dimensions.of(context);

    //final double contentWidth1 = dimensions.contentWidth1;
    //final double contentWidth2 = dimensions.contentWidth2;
    //final double globalMargin1 = dimensions.globalMargin1;
    //final double buttonHeight1 = dimensions.buttonHeight1;
    //final double textSize1 = dimensions.textSize1;
    //final double textSize2 = dimensions.textSize2;
    //final double textSize3 = dimensions.textSize3;
    //final double cornerRadius1 = dimensions.cornerRadius1;
    log('!!! building CommentsTabWidget widgets...');
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverGrid.builder(
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 0),
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: currentTheme.foreground1, border: Border.all(color: currentTheme.text2.withAlpha(64), width: 0.1)),
              child: Icon(Icons.comment_rounded, color: currentTheme.text2, size: 36),
            );
          },
        ),
      ],
    );
  }
}

class ProfileSkeletonWidget extends ConsumerWidget {
  const ProfileSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('!!! building skeleton widgets...');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/auth/login'), child: const Text('Sign In')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/auth/register'), child: const Text('Sign Up')),
          ],
        ),
      ],
    );
  }
}

/*

 Uint8List? _croppedImage;
  DateTime _selectedDate = DateTime.now();

  void _showImageSelector({
    required BuildContext context,
    required int resizeWidth,
    required int resizeHeight,
    required int screenWidth,
    required int screenHeight,
  }) {
    showImageSelector(
      context: context,
      resizeWidth: resizeWidth,
      resizeHeight: resizeHeight,
      screenHeight: screenWidth,
      screenWidth: screenWidth,
      onImageSelected: (croppedImage) {
        croppedImage = croppedImage;
        setState(() {
          _croppedImage = croppedImage;
        });
      },
    );
  }

  void _showDateSelector({required BuildContext context}) {
    showCustomDateSelector(
      context: context,
      onDateSelected: (selectedDate) {
        setState(() {
          _selectedDate = selectedDate!;
        });
      },
    );
  }







/*

   ElevatedButton(
        onPressed: () {
          _showImageSelector(
              context: context,
              screenWidth: screenWidth.floor(),
              screenHeight: screenHeight.floor(),
              resizeWidth: 140,
              resizeHeight: 140);
        },
        child: const Text("Show Photo Selector"),
      ), // Image Picker Button
      ElevatedButton(
        onPressed: () => _showDateSelector(context: context),
        child: const Text("Show Scroll Date Selector"),
      ),

*/



 */
