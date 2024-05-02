import 'package:flutter/material.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.comment,
              color: Color.fromARGB(255, 82, 29, 0),
            ),
            onPressed: () {},
          ),
        ],
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          _buildNewsCard(
            username: 'Yasar Mushtaq',
            time: '2 hours ago',
            text:
                'Vinland Saga Season 2 Animation Teaser Dropped: Fans Excited to Dive Back into the Stunning Norse Visuals!', 
            avatarAsset:
                'assets/images/avatars/pro1.jpg', 
          ),
          _buildNewsCard(
            username: 'Kair7sky',
            time: '1 day ago',
            text:
                'New Animation Style Unveiled in Vinland Saga Season 2 Teaser: How Will it Enhance the Epic Tale?', 
            avatarAsset:
                'assets/images/avatars/pro4.jpg', 
          ),
          _buildNewsCard(
            username: 'Dony',
            time: '3 days ago',
            text:
                'Vinland Saga Animation Team Celebrates 100 Episodes: Commemorating the Artistic Journey of Viking Glory.', 
            avatarAsset:
                'assets/images/avatars/pro2.jpg', 
          ),
          _buildNewsCard(
            username: 'Anurbek',
            time: '4 days ago',
            text:
                'Vinland Saga Animation Recognized for Best Visuals: Commending the Detailed Artistry and Fluid Motion!', // Replace with actual asset path
            avatarAsset:
                'assets/images/avatars/pro3.jpg', 
          ),
          _buildNewsCard(
            username: 'Vinland Saga Official',
            time: '5 days ago',
            text:
                'Vinland Saga Animation Studio Announces Mobile Game: Bringing the Epic Visuals to the Palm of Your Hand!',
            avatarAsset:
                'assets/images/avatars/pro7.jpg', // Replace with actual asset path
          ),
          _buildNewsCard(
            username: 'The Viking Glory',
            time: '6 days ago',
            text:
                'Vinland Saga Animation Merchandise Line Launched: From Art Prints to Figurines, Fans Can Now Collect Their Favorite Scenes!',
            avatarAsset:
                'assets/images/avatars/pro6.jpg', // Replace with actual asset path
          ),
          _buildNewsCard(
            username: 'Aldiyar',
            time: '1 week ago',
            text:
                'Vinland Saga Animation Soundtrack Released: Immerse Yourself in the Epic Musical Journey of the Viking Saga!',
            avatarAsset:
                'assets/images/avatars/pro5.jpg', 
          ),
          _buildNewsCard(
            username: 'Yasar Mushtaq',
            time: '2 hours ago',
            text:
                'Vinland Saga Season 2 Animation Teaser Dropped: Fans Excited to Dive Back into the Stunning Norse Visuals!',
            avatarAsset:
                'assets/images/avatars/pro1.jpg', 
          ),
          _buildNewsCard(
            username: 'Kair7sky',
            time: '1 day ago',
            text:
                'New Animation Style Unveiled in Vinland Saga Season 2 Teaser: How Will it Enhance the Epic Tale?', 
            avatarAsset:
                'assets/images/avatars/pro4.jpg', 
          ),
          _buildNewsCard(
            username: 'Dony',
            time: '3 days ago',
            text:
                'Vinland Saga Animation Team Celebrates 100 Episodes: Commemorating the Artistic Journey of Viking Glory.',
            avatarAsset:
                'assets/images/avatars/pro2.jpg', 
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String username,
    required String time,
    required String text,
    required String avatarAsset,
  }) {
    return NewsCard(
      username: username,
      time: time,
      text: text,
      avatarAsset: avatarAsset,
    );
  }
}

class NewsCard extends StatefulWidget {
  final String username;
  final String time;
  final String text;
  final String avatarAsset;

  const NewsCard({
    required this.username,
    required this.time,
    required this.text,
    required this.avatarAsset,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(widget.avatarAsset),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.time,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                  },
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.text,
              style: const TextStyle(fontSize: 16.0),
            ), // Add like, comment, share buttons here if needed
          ],
        ),
      ),
    );
  }
}
