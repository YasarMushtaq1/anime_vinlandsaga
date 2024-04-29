import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Feed'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.newspaper, 
              color: Color.fromARGB(255, 82, 29, 0),), onPressed: () {},
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
            text: 'Vinland Saga Season 2 Trailer Released: Fans Eager for the Epic Norse Adventure to Continue!',
            imageAsset: 'assets/images/news/news1.jpg', // Replace with actual asset path
            avatarAsset: 'assets/images/avatars/pro1.jpg', // Replace with actual asset path
          ),
          _buildNewsCard(
            username: 'Kair7sky',
            time: '1 day ago',
            text: 'New Character Revealed in Vinland Saga Season 2 Teaser: What Role Will They Play?',
            imageAsset: 'assets/images/news/news2.jpg', // Replace with actual asset path
            avatarAsset: 'assets/images/avatars/pro4.jpg', // Replace with actual asset path
          ),
          _buildNewsCard(
            username: 'Dony',
            time: '3 days ago',
            text: 'Vinland Saga Manga Hits Major Milestone: Celebrating 100 Chapters of Viking Glory.',
            imageAsset: 'assets/images/news/news3.jpg', // Replace with actual asset path
            avatarAsset: 'assets/images/avatars/pro2.jpg', // Replace with actual asset path
          ),
          _buildNewsCard(
            username: 'Anurbek',
            time: '4 days ago',
            text: 'Vinland Saga Nominated for Best Anime Adaptation Award: Recognition for its Stunning Animation and Compelling Storytelling!',
            imageAsset: 'assets/images/news/news4.jpg', // Replace with actual asset path
            avatarAsset: 'assets/images/avatars/pro3.jpg', // Replace with actual asset path
          ),
          _buildNewsCard(
            username: 'Vinland Saga Official',
            time: '5 days ago',
            text: 'Vinland Saga Mobile Game Announced: Players Can Embark on Viking Expeditions on Their Phones!',
            imageAsset: 'assets/images/news/news5.jpg', // Replace with actual asset path
            avatarAsset: 'assets/images/avatars/pro7.jpg', // Replace with actual asset path
          ),
          _buildNewsCard(
            username: 'The Viking Glory',
            time: '6 days ago',
            text: 'Vinland Saga Merchandise Line Launches: From Apparel to Collectibles, Fans Can Now Show Their Viking Pride!',
            imageAsset: 'assets/images/news/news6.jpg', // Replace with actual asset path
            avatarAsset: 'assets/images/avatars/pro6.jpg', // Replace with actual asset path
          ),
          _buildNewsCard(
            username: 'Aldiyar',
            time: '1 week ago',
            text: 'Vinland Saga OST Released: Immerse Yourself in the Epic Soundtrack of the Viking Saga!',
            imageAsset: 'assets/images/news/news7.jpg', // Replace with actual asset path
            avatarAsset: 'assets/images/avatars/pro5.jpg', // Replace with actual asset path
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String username,
    required String time,
    required String text,
    required String imageAsset,
    required String avatarAsset,
  }) {
    return NewsCard(
      username: username,
      time: time,
      text: text,
      imageAsset: imageAsset,
      avatarAsset: avatarAsset,
    );
  }
}

class NewsCard extends StatefulWidget {
  final String username;
  final String time;
  final String text;
  final String imageAsset;
  final String avatarAsset;

  const NewsCard({
    required this.username,
    required this.time,
    required this.text,
    required this.imageAsset,
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
            ),
            const SizedBox(height: 8.0),
            widget.imageAsset.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      widget.imageAsset,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200.0,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 8.0),
            // Add like, comment, share buttons here if needed
          ],
        ),
      ),
    );
  }
}
