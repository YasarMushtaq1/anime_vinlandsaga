import 'package:flutter/material.dart';

class ActorsPage extends StatelessWidget {
  const ActorsPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actors'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: PageView(
                  children: const <Widget>[
                    CastCard(
                      image: 'assets/images/actors/Thorfinn.jpg',
                      characterName: 'Thorfinn',
                    ),
                    CastCard(
                      image: 'assets/images/actors/ketil.jpg',
                      characterName: 'Ketil',
                    ),
                    CastCard(
                      image: 'assets/images/actors/Canut.png',
                      characterName: 'Canut',
                    ),
                    CastCard(
                      image: 'assets/images/actors/Thorkell.png',
                      characterName: 'Thorkell',
                    ),
                    CastCard(
                      image: 'assets/images/actors/Einar.png',
                      characterName: 'Einar',
                    ),
                    CastCard(
                      image: 'assets/images/actors/Askeladd.png',
                      characterName: 'Askeladd',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CastCard extends StatelessWidget {
  final String image;
  final String characterName;

  const CastCard({super.key, 
    required this.image,
    required this.characterName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          width: 400.0,
          height: 400.0,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                color: Colors.white,
                child: Text(
                  characterName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//final 