import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CastFeed extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CastFeed({Key? key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('cast').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, castSnapshots) {
        if (castSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!castSnapshots.hasData || castSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No cast found'),
          );
        }
        if (castSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }
        final loadedCast = castSnapshots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40),
          itemCount: loadedCast.length,
          itemBuilder: (ctx, index) {
            final castItem = loadedCast[index].data();

            return FutureBuilder(
              future: FirebaseFirestore.instance.collection('users').doc(castItem['userId']).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final userData = userSnapshot.data;
                final username = userData?['username']; // Assuming 'username' is a field in the user document

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CastDetailScreen(castId: loadedCast[index].id),
                      ),
                    );
                  },
                  child: CastCard(
                    castId: loadedCast[index].id,
                    username: username, // Use the fetched username
                    time: castItem['createdAt'],
                    text: castItem['text'],
                    actorImage: castItem['actorImage'],
                    rolePlayerImage: castItem['rolePlayerImage'],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class CastCard extends StatefulWidget {
  final String castId;
  final String username;
  final Timestamp time;
  final String text;
  final String actorImage;
  final String rolePlayerImage;

  // ignore: use_super_parameters
  const CastCard({
    required this.castId,
    required this.username,
    required this.time,
    required this.text,
    required this.actorImage,
    required this.rolePlayerImage,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CastCardState createState() => _CastCardState();
}

class _CastCardState extends State<CastCard> {
  // ignore: prefer_final_fields
  TextEditingController _editController = TextEditingController();

  // Function to delete a cast item
  Future<void> _deleteCast(String castId) async {
    try {
      await FirebaseFirestore.instance.collection('cast').doc(castId).delete();
    } catch (error) {
      // Handle error
      // ignore: avoid_print
      print('Error deleting cast: $error');
    }
  }

  // Function to update a cast item
  Future<void> _updateCast(String castId, String newText) async {
    try {
      await FirebaseFirestore.instance.collection('cast').doc(castId).update({
        'text': newText,
        'updatedAt': Timestamp.now(),
      });
    } catch (error) {
      // Handle error
      // ignore: avoid_print
      print('Error updating cast: $error');
    }
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
                  backgroundImage: NetworkImage(widget.actorImage),
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
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Actor',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            widget.actorImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Role Player',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            widget.rolePlayerImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editController.text = widget.text;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Edit Cast'),
                          content: TextField(
                            controller: _editController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: 'Edit the cast...',
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
                                _updateCast(widget.castId, _editController.text); // Call update function
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
                          title: const Text('Delete Cast Item'),
                          content: const Text('Are you sure you want to delete this cast item?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteCast(widget.castId); // Call delete function
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
}

class CastDetailScreen extends StatelessWidget {
  final String castId;

  // ignore: use_key_in_widget_constructors
  const CastDetailScreen({required this.castId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cast Detail'),
        shape: const Border(
          bottom: BorderSide(
            width: 0.5,
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('cast').doc(castId).get(),
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

          final castData = snapshot.data!.data() as Map<String, dynamic>;

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
                        'Posted by: ${castData['username']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Text(
                        'Date: ${castData['createdAt'].toDate().toString()}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(castData['actorImage']),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cast Text:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          castData['text'],
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Actor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            castData['actorImage'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Role Player',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            castData['rolePlayerImage'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
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
