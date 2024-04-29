import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  late VideoPlayerController _controller;
  late bool _isPlaying = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/video/Trailer.mp4',
    )..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {
        _sliderValue = _controller.value.position.inSeconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Duration currentPosition = _controller.value.position;
    Duration totalDuration = _controller.value.duration;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vinland Saga'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.home,
              color: Color.fromARGB(255, 82, 29, 0),
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
        shape: const Border(
          bottom: BorderSide(
            width: 0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Styled video frame with title
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      child: Text(
                        'Series Official Trailer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 82, 29, 0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                          if (_isPlaying) {
                            _controller.play();
                          } else {
                            _controller.pause();
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              VideoPlayer(_controller),
                              if (_isPlaying)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 10,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          _controller.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPlaying = !_isPlaying;
                                            if (_isPlaying) {
                                              _controller.play();
                                            } else {
                                              _controller.pause();
                                            }
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: _sliderValue,
                                          min: 0,
                                          max: totalDuration.inSeconds.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              _sliderValue = value;
                                              _controller.seekTo(
                                                  Duration(seconds: value.toInt()));
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        '${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tab bar for movie description and details
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Description'),
                        Tab(text: 'Details'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 82, 29, 0),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Vinland  is a Japanese anime television series based on Makoto Yukimura's manga of the same name. The first season was produced by Wit Studio in 2019 and the second one by MAPPA in 2023. They follow the life of a child named Thorfinn who becomes involved with Vikings following his father's death. The first season follows his exploits as a revenge-driven Viking, while in the second season, the story shifts to his life as a stoic slave who finds no reason to live.",
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            padding: EdgeInsets.all(16.0),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Product of:',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 82, 29, 0),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Wit Studio",
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Director:',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 82, 29, 0),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Shuhei Yebuta",
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Release Date:',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 82, 29, 0),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "July 7, 2019",
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Genres:',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 82, 29, 0),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Seinen Manga",
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Number of Seasons:',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 82, 29, 0),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "2",
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Ranking:',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 82, 29, 0),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "8.8 / 10",
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
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
    super.dispose();
    _controller.dispose();
  }
}
