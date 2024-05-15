// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StuffFeed extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const StuffFeed({Key? key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('stuff').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, newsSnapshots) {
        if (newsSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!newsSnapshots.hasData || newsSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Stuff found'),
          );
        }
        if (newsSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }
        final loadedNews = newsSnapshots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40),
          itemCount: loadedNews.length,
          itemBuilder: (ctx, index) {
            final newsItem = loadedNews[index].data();

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(newsId: loadedNews[index].id),
                  ),
                );
              },
              child: NewsCard(
                newsId: loadedNews[index].id,
                userImage: newsItem['userImage'],
                username: newsItem['username'],
                time: newsItem['createdAt'],
                text: newsItem['text'],
                image: newsItem['image'],
              ),
            );
          },
        );
      },
    );
  }
}

class NewsCard extends StatefulWidget {
  final String newsId;
  final String username;
  final Timestamp time;
  final String text;
  final String userImage;
  final String? image;

  // ignore: use_super_parameters
  const NewsCard({
    required this.newsId,
    required this.username,
    required this.time,
    required this.text,
    required this.userImage,
    this.image,
    Key? key,
  }) : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: Colors.grey, width: 1.0),
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
                  backgroundImage: NetworkImage(widget.userImage),
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
                        widget.time.toDate().toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editController.text = widget.text;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Edit Stuff'),
                          content: TextField(
                            controller: _editController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: 'Edit the Stuff...',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _updateNews(widget.newsId, _editController.text);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Stuff'),
                          content: const Text('Are you sure you want to delete this Stuff?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteNews(widget.newsId);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            if (widget.image != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.image!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  Future<void> _deleteNews(String newsId) async {
    try {
      await FirebaseFirestore.instance.collection('stuff').doc(newsId).delete();
    } catch (error) {
      // ignore: avoid_print
      print('Error deleting news: $error');
    }
  }

  Future<void> _updateNews(String newsId, String newText) async {
    try {
      await FirebaseFirestore.instance.collection('stuff').doc(newsId).update({
        'text': newText,
        'updatedAt': Timestamp.now(),
      });
    } catch (error) {
      // ignore: avoid_print
      print('Error updating news: $error');
    }
  }
}

class NewsDetailScreen extends StatelessWidget {
  final String newsId;

  // ignore: use_key_in_widget_constructors
  const NewsDetailScreen({required this.newsId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stuff Detail'),
        shape: const Border(
          bottom: BorderSide(
            width: 0.5,
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('stuff').doc(newsId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(
              child: Text('No data found'),
            );
          }

          final newsData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    child: ListTile(
                      title: Text(
                        'Posted by: ${newsData['username']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Text(
                        'Date: ${newsData['createdAt'].toDate().toString()}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(newsData['userImage']),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'News Text:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          newsData['text'],
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (newsData['image'] != null)
                    _buildSection(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          newsData['image'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: child,
    );
  }
}
