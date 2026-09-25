import 'package:flutter/material.dart';

void main() {
  runApp(const IsharatiApp());
}

class IsharatiApp extends StatelessWidget {
  const IsharatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'إشارتي',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2F6F5E),
        scaffoldBackgroundColor: const Color(0xFFF7F7F5),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: const RootScreen(),
      ),
    );
  }
}

// ---------- Simple in-memory data model ----------

enum PostKind { text, image, video }

class Post {
  final String id;
  final String authorName;
  final String authorInitial;
  final PostKind kind;
  final String content; // text content, or a caption for image/video
  int likes;
  final List<String> comments;

  Post({
    required this.id,
    required this.authorName,
    required this.authorInitial,
    required this.kind,
    required this.content,
    this.likes = 0,
    List<String>? comments,
  }) : comments = comments ?? [];
}

class AppData {
  static final AppData instance = AppData._internal();
  AppData._internal();

  String currentUserName = 'مستخدم جديد';

  final List<Post> posts = [
    Post(
      id: '1',
      authorName: 'سالم',
      authorInitial: 'س',
      kind: PostKind.text,
      content: 'أهلاً بالجميع في إشارتي 👋 هذه مساحتنا نحكي فيها قصصنا.',
      likes: 12,
      comments: ['أهلاً وسهلاً فيك!', 'فكرة رائعة'],
    ),
    Post(
      id: '2',
      authorName: 'نورة',
      authorInitial: 'ن',
      kind: PostKind.video,
      content: 'فيديو قصير أحكي فيه عن يومي بلغة الإشارة 🎥',
      likes: 8,
      comments: ['تسلمين'],
    ),
    Post(
      id: '3',
      authorName: 'خالد',
      authorInitial: 'خ',
      kind: PostKind.image,
      content: 'صورة من لقاء مجتمعي الأسبوع اللي فات.',
      likes: 20,
      comments: [],
    ),
  ];
}

// ---------- Root with bottom navigation ----------

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  final _pages = const [
    FeedScreen(),
    CreatePostScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'نشر'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

// ---------- Feed ----------

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final posts = AppData.instance.posts;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('إشارتي', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.volume_off_outlined, color: Colors.grey),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: posts.length,
            itemBuilder: (context, i) => PostCard(
              post: posts[i],
              onChanged: () => setState(() {}),
            ),
          ),
        ),
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onChanged;

  const PostCard({super.key, required this.post, required this.onChanged});

  IconData get _kindIcon {
    switch (post.kind) {
      case PostKind.image:
        return Icons.image_outlined;
      case PostKind.video:
        return Icons.videocam_outlined;
      case PostKind.text:
        return Icons.short_text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(post.authorInitial),
                ),
                const SizedBox(width: 10),
                Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Icon(_kindIcon, size: 18, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 10),
            if (post.kind != PostKind.text)
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  post.kind == PostKind.video ? Icons.play_circle_outline : Icons.photo_outlined,
                  size: 48,
                  color: Colors.black45,
                ),
              ),
            const SizedBox(height: 10),
            Text(post.content),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    post.likes++;
                    onChanged();
                  },
                ),
                Text('${post.likes}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  onPressed: () => _showComments(context),
                ),
                Text('${post.comments.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showComments(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('التعليقات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: post.comments.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('لا توجد تعليقات بعد، كن أول من يعلّق.'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: post.comments.length,
                          itemBuilder: (context, i) => ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: Text(post.comments[i]),
                          ),
                        ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: 'اكتب تعليقاً...'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (controller.text.trim().isEmpty) return;
                        setModalState(() => post.comments.add(controller.text.trim()));
                        controller.clear();
                        onChanged();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Create Post ----------

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _controller = TextEditingController();
  PostKind _kind = PostKind.text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('منشور جديد', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SegmentedButton<PostKind>(
            segments: const [
              ButtonSegment(value: PostKind.text, label: Text('نص'), icon: Icon(Icons.short_text)),
              ButtonSegment(value: PostKind.image, label: Text('صورة'), icon: Icon(Icons.image_outlined)),
              ButtonSegment(value: PostKind.video, label: Text('فيديو'), icon: Icon(Icons.videocam_outlined)),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.first),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'شاركنا قصتك أو خاطرتك...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          if (_kind != PostKind.text)
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('رفع الملفات الحقيقي بيُضاف في مرحلة لاحقة')),
                );
              },
              icon: Icon(_kind == PostKind.video ? Icons.videocam_outlined : Icons.image_outlined),
              label: Text(_kind == PostKind.video ? 'إرفاق فيديو' : 'إرفاق صورة'),
            ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              if (_controller.text.trim().isEmpty) return;
              AppData.instance.posts.insert(
                0,
                Post(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  authorName: AppData.instance.currentUserName,
                  authorInitial: AppData.instance.currentUserName.characters.first,
                  kind: _kind,
                  content: _controller.text.trim(),
                ),
              );
              _controller.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم النشر بنجاح')),
              );
              setState(() {});
            },
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: const Text('نشر'),
          ),
        ],
      ),
    );
  }
}

extension _FirstChar on String {
  String get characters => isEmpty ? '?' : this[0];
}

// ---------- Profile ----------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myPosts = AppData.instance.posts
        .where((p) => p.authorName == AppData.instance.currentUserName)
        .toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: CircleAvatar(
            radius: 42,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              AppData.instance.currentUserName.characters,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            AppData.instance.currentUserName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        const Center(child: Text('عضو في مجتمع إشارتي', style: TextStyle(color: Colors.grey))),
        const SizedBox(height: 24),
        Text('منشوراتي (${myPosts.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (myPosts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('لم تنشر شيئاً بعد. اذهب لتبويب "نشر" وشاركنا شيئاً من عندك.'),
          )
        else
          ...myPosts.map((p) => Card(
                child: ListTile(
                  leading: Icon(p.kind == PostKind.video
                      ? Icons.videocam_outlined
                      : p.kind == PostKind.image
                          ? Icons.image_outlined
                          : Icons.short_text),
                  title: Text(p.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              )),
      ],
    );
  }
}
