import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart'; // Import the package

class EventFeed extends StatefulWidget {
  // ignore: use_super_parameters
  const EventFeed({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventFeedState createState() => _EventFeedState();
}

class _EventFeedState extends State<EventFeed> {
  late DateTime _selectedDay;
  late Map<DateTime, List<dynamic>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _events = {};
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('events').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, eventSnapshots) {
        if (eventSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!eventSnapshots.hasData || eventSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No events found'),
          );
        }
        if (eventSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }
        final loadedEvents = eventSnapshots.data!.docs;

        // Populate events for the calendar
        _events = {};
        for (var event in loadedEvents) {
          DateTime eventDate = (event['createdAt'] as Timestamp).toDate();
          if (_events.containsKey(eventDate)) {
            _events[eventDate]!.add(event);
          } else {
            _events[eventDate] = [event];
          }
        }

        return Column(
          children: [
            TableCalendar(
              focusedDay: _selectedDay,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2024, 12, 31),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              eventLoader: (date) => _events[date] ?? [],
              onDaySelected: (date, events, ) {
                setState(() {
                  _selectedDay = date;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 40),
                itemCount: loadedEvents.length,
                itemBuilder: (ctx, index) {
                  final eventItem = loadedEvents[index].data();
                  DateTime eventDate = (eventItem['createdAt'] as Timestamp).toDate();

                  // Show events for the selected day
                  if (eventDate.day == _selectedDay.day && eventDate.month == _selectedDay.month && eventDate.year == _selectedDay.year) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailScreen(eventId: loadedEvents[index].id),
                          ),
                        );
                      },
                      child: EventCard(
                        eventId: loadedEvents[index].id,
                        userImage: eventItem['userImage'],
                        username: eventItem['username'],
                        time: eventItem['createdAt'],
                        text: eventItem['text'],
                        image: eventItem['image'],
                      ),
                    );
                  } else {
                    return Container(); // Return an empty container if the event doesn't match the selected day
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}


class EventCard extends StatefulWidget {
  final String eventId;
  final String username;
  final Timestamp time;
  final String text;
  final String userImage;
  final String? image;

  // ignore: use_super_parameters
  const EventCard({
    required this.eventId,
    required this.username,
    required this.time,
    required this.text,
    required this.userImage,
    this.image,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  // ignore: prefer_final_fields
  TextEditingController _editController = TextEditingController();

  // Function to delete an event item
  Future<void> _deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
    } catch (error) {
      // Handle error
      // ignore: avoid_print
      print('Error deleting event: $error');
    }
  }

  // Function to update an event item
  Future<void> _updateEvent(String eventId, String newText) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).update({
        'text': newText,
        'updatedAt': Timestamp.now(),
      });
    } catch (error) {
      // Handle error
      // ignore: avoid_print
      print('Error updating event: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                // Edit button/icon
                if (true) // Add condition for edit permission
                  IconButton(
                    // ignore: prefer_const_constructors
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editController.text = widget.text;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Edit event'),
                            content: TextField(
                              controller: _editController,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: 'Edit the event...',
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
                                  _updateEvent(widget.eventId, _editController.text); // Call update function
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
                // Delete button/icon
                if (true) // Add condition for delete permission
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Event'),
                            content: const Text('Are you sure you want to delete this event?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteEvent(widget.eventId); // Call delete function
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
}

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  // ignore: use_key_in_widget_constructors
  const EventDetailScreen({required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Detail'),
        shape: const Border(
          bottom: BorderSide(
            width: 0.5,
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('events').doc(eventId).get(),
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

          final eventData = snapshot.data!.data() as Map<String, dynamic>;

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
                        'Posted by: ${eventData['username']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Text(
                        'Date: ${eventData['createdAt'].toDate().toString()}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(eventData['userImage']),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Event Details:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          eventData['text'],
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (eventData['image'] != null)
                    _buildSection(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          eventData['image'],
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
