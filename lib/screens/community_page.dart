import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  int _selectedTabIndex =
      0; // 0: For You, 1: Beaches, 2: Mountains, 3: Cities, 4: Culture

  // Color scheme
  static const Color primaryPurple = Color(0xFF8B7B9E);
  static const Color darkPurple = Color(0xFF5D4E6D);

  // Topic categories
  final List<String> _topics = [
    'For You',
    'Beaches',
    'Mountains',
    'Cities',
    'Culture',
  ];

  // Sample community posts data
  late List<CommunityPost> _allPosts = [
    CommunityPost(
      id: '1',
      author: 'Sarah Johnson',
      avatar:
          'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah&backgroundColor=FF6B6B',
      destination: 'Taj Mahal, Agra',
      topic: 'Culture',
      content:
          'Just visited the Taj Mahal and it was absolutely breathtaking! The marble work is incredible. Pro tip: Go early in the morning to avoid crowds and get the best photos.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/1/1b/Taj_Mahal-08.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 342,
      comments: 28,
      isLiked: false,
    ),
    CommunityPost(
      id: '2',
      author: 'Mike Chen',
      avatar:
          'https://api.dicebear.com/7.x/avataaars/svg?seed=Mike&backgroundColor=4ECDC4',
      destination: 'Backwaters, Kerala',
      topic: 'Beaches',
      content:
          'The houseboat experience in Kerala is unlike anything else! Floating through the backwaters at sunset was pure magic. Don\'t forget to try the fresh seafood!',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/4/4e/Kerala_backwaters%2C_Houseboats%2C_India.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 567,
      comments: 45,
      isLiked: false,
    ),
    CommunityPost(
      id: '3',
      author: 'Emily Rodriguez',
      avatar:
          'https://api.dicebear.com/7.x/avataaars/svg?seed=Emily&backgroundColor=95E1D3',
      destination: 'Goa Beaches',
      topic: 'Beaches',
      content:
          'Found the perfect hidden beach in Goa! Less crowded and absolutely pristine. The sunset views here are unmatched. Who else loves beach vibes?',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/3/3f/Palolem_Beach%2C_south_Goa.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      likes: 892,
      comments: 63,
      isLiked: false,
    ),
    CommunityPost(
      id: '4',
      author: 'David Lee',
      avatar:
          'https://api.dicebear.com/7.x/avataaars/svg?seed=David&backgroundColor=F38181',
      destination: 'Valley of Flowers, Uttarakhand',
      topic: 'Mountains',
      content:
          'Trekked to Valley of Flowers! The diversity of flowers was mind-blowing. Saw alpine meadows, crystal clear streams, and even some wildlife. Best trek ever!',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/b/b0/Valley_of_flowers_%2829336158797%29.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      likes: 445,
      comments: 34,
      isLiked: false,
    ),
    CommunityPost(
      id: '5',
      author: 'Priya Sharma',
      avatar:
          'https://api.dicebear.com/7.x/avataaars/svg?seed=Priya&backgroundColor=FFD93D',
      destination: 'Mumbai City',
      topic: 'Cities',
      content:
          'The energy of Mumbai is unmatched! From street food to marine drives, this city has it all. The Gateway of India at sunset is a must-see!',
      imageUrl: null,
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      likes: 234,
      comments: 18,
      isLiked: false,
    ),
  ];

  late List<CommunityPost> _filteredPosts = _allPosts;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filterByTopic();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filterByTopic();
      } else {
        _filteredPosts = _allPosts
            .where(
              (post) =>
                  post.content.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ) ||
                  post.destination.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ) ||
                  post.author.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  void _filterByTopic() {
    setState(() {
      if (_selectedTabIndex == 0) {
        _filteredPosts = _allPosts;
      } else {
        _filteredPosts = _allPosts
            .where((post) => post.topic == _topics[_selectedTabIndex])
            .toList();
      }
    });
  }

  void _createPost() {
    if (_postController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something to post!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      final newPost = CommunityPost(
        id: '${_allPosts.length + 1}',
        author: 'You',
        avatar:
            'https://api.dicebear.com/7.x/avataaars/svg?seed=You&backgroundColor=AA96DA',
        destination: 'Globe Trotter',
        topic: _topics[_selectedTabIndex == 0 ? 0 : _selectedTabIndex],
        content: _postController.text,
        imageUrl: null,
        timestamp: DateTime.now(),
        likes: 0,
        comments: 0,
        isLiked: false,
      );

      _allPosts.insert(0, newPost);
      _filteredPosts.insert(0, newPost);
      _postController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post shared successfully! ✨'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleLike(String postId) {
    setState(() {
      // Update in all posts list
      final allPostIndex = _allPosts.indexWhere((post) => post.id == postId);
      if (allPostIndex != -1) {
        _allPosts[allPostIndex].isLiked = !_allPosts[allPostIndex].isLiked;
        _allPosts[allPostIndex].likes += _allPosts[allPostIndex].isLiked
            ? 1
            : -1;
      }

      // Update in filtered list
      final filteredPostIndex = _filteredPosts.indexWhere(
        (post) => post.id == postId,
      );
      if (filteredPostIndex != -1) {
        _filteredPosts[filteredPostIndex].isLiked =
            !_filteredPosts[filteredPostIndex].isLiked;
        _filteredPosts[filteredPostIndex].likes +=
            _filteredPosts[filteredPostIndex].isLiked ? 1 : -1;
      }
    });
  }

  void _showComments(CommunityPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentSheet(post: post),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FA),
      body: CustomScrollView(
        slivers: [
          // Header with gradient
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryPurple, darkPurple],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.explore,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Community Forum',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Stories from our travelers',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Topic Navigation Tabs (Instagram style)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                    _topics.length,
                    (index) => Padding(
                      padding: EdgeInsets.fromLTRB(
                        index == 0 ? 16 : 4,
                        0,
                        index == _topics.length - 1 ? 16 : 4,
                        0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = index;
                            _filterByTopic();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == index
                                ? primaryPurple
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: _selectedTabIndex == index
                                ? Border.all(color: primaryPurple, width: 2)
                                : Border.all(color: Colors.transparent),
                          ),
                          child: Text(
                            _topics[index],
                            style: TextStyle(
                              color: _selectedTabIndex == index
                                  ? Colors.white
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search posts, destinations...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: primaryPurple),
                  suffixIcon: Icon(Icons.tune, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryPurple, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // Create Post Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          'https://api.dicebear.com/7.x/avataaars/svg?seed=You&backgroundColor=AA96DA',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _postController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Share your travel experience...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[200]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[200]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: primaryPurple,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.image_outlined),
                        label: const Text('Photo'),
                        style: TextButton.styleFrom(
                          foregroundColor: primaryPurple,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _createPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Share',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Posts Feed
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            sliver: _filteredPosts.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No posts found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Be the first to share in this category!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return PostCard(
                        post: _filteredPosts[index],
                        onLike: _toggleLike,
                        onComment: _showComments,
                      );
                    }, childCount: _filteredPosts.length),
                  ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _postController.dispose();
    super.dispose();
  }
}

class PostCard extends StatefulWidget {
  final CommunityPost post;
  final Function(String) onLike;
  final Function(CommunityPost) onComment;

  const PostCard({
    required this.post,
    required this.onLike,
    required this.onComment,
    super.key,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  static const Color primaryPurple = Color(0xFF8B7B9E);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - User info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.post.avatar),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.author,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.post.destination,
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _formatTime(widget.post.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  iconSize: 20,
                  color: Colors.grey[500],
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Topic Badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.post.topic,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: primaryPurple,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              widget.post.content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Image
          if (widget.post.imageUrl != null) ...[
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Image.network(
                widget.post.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ],

          // Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_rounded, size: 16, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.post.likes} likes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${widget.post.comments} comments',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 16, color: Colors.grey[200]),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {
                    widget.onLike(widget.post.id);
                    setState(() {});
                  },
                  icon: Icon(
                    widget.post.isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    size: 18,
                    color: widget.post.isLiked ? Colors.red : Colors.grey[600],
                  ),
                  label: Text(
                    'Like',
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.post.isLiked
                          ? Colors.red
                          : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    widget.onComment(widget.post);
                  },
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  label: Text(
                    'Comment',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  label: Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}

class CommentSheet extends StatefulWidget {
  final CommunityPost post;

  const CommentSheet({required this.post, super.key});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();
  late List<Comment> _comments = [
    Comment(
      author: 'Alex Turner',
      avatar:
          'https://api.dicebear.com/7.x/avataaars/svg?seed=Alex&backgroundColor=FF6B9D',
      content: 'This looks amazing! I\'m definitely adding this to my list!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      likes: 12,
    ),
    Comment(
      author: 'Jordan Smith',
      avatar:
          'https://api.dicebear.com/7.x/avataaars/svg?seed=Jordan&backgroundColor=C44569',
      content: 'The colors in this photo are unreal! Great capture!',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      likes: 8,
    ),
  ];

  static const Color primaryPurple = Color(0xFF8B7B9E);

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.add(
        Comment(
          author: 'You',
          avatar:
              'https://api.dicebear.com/7.x/avataaars/svg?seed=You&backgroundColor=AA96DA',
          content: _commentController.text,
          timestamp: DateTime.now(),
          likes: 0,
        ),
      );
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(widget.post.avatar),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.author,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.post.destination,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.post.content,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey[200]),

              // Comments list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(comment.avatar),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      comment.author,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Icon(
                                      Icons.favorite_border,
                                      size: 14,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.content,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _formatTime(comment.timestamp),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Comment input
              Divider(height: 1, color: Colors.grey[200]),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: primaryPurple,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: primaryPurple,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        iconSize: 18,
                        onPressed: _addComment,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

// Data Models
class CommunityPost {
  final String id;
  final String author;
  final String avatar;
  final String destination;
  final String topic;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  int likes;
  int comments;
  bool isLiked;

  CommunityPost({
    required this.id,
    required this.author,
    required this.avatar,
    required this.destination,
    required this.topic,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });
}

class Comment {
  final String author;
  final String avatar;
  final String content;
  final DateTime timestamp;
  int likes;

  Comment({
    required this.author,
    required this.avatar,
    required this.content,
    required this.timestamp,
    required this.likes,
  });
}
