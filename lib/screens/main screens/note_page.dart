import 'package:flutter/material.dart';
class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override  
  
  // ignore: library_private_types_in_public_api
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Map<String, dynamic>> items = [];

  void _addItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int id = items.length + 1;
        String name = '';
        String group = '';

        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Note'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Group'),
                onChanged: (value) {
                  group = value;
                },
              ),
            ],
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
                setState(() {
                  items.add({
                    'id': id,
                    'name': name,
                    'group': group,
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _updateItem(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
       
        String name = items[index]['name'];
        String group = items[index]['group'];

        return AlertDialog(
          title: const Text('Update Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Note'),
                onChanged: (value) {
                  name = value;
                },
                controller: TextEditingController(text: name),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Group'),
                onChanged: (value) {
                  group = value;
                },
                controller: TextEditingController(text: group),
              ),
            ],
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
                setState(() {
                  items[index]['name'] = name;
                  items[index]['group'] = group;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this list?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  items.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.note,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 2.0,
                    child: ListTile(
                       
                      title: Text(items[index]['name']),
                      subtitle: Text(items[index]['group']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _updateItem(context, index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteItem(context, index);
                            },
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 80.0), // Add extra space at the bottom for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem(context);
        },
        tooltip: 'Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}
