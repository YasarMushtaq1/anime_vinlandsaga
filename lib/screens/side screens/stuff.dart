import 'package:flutter/material.dart';

class StuffPage extends StatelessWidget {
  const StuffPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stuff'),
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
                      realName: 'Aleks le',
                      characterName: 'Thorfinn',
                      image: 'assets/images/stuff/AleksLe-Thorfinn.jpg',
                    ),
                    CastCard(
                      realName: 'Hideaki Teuka',
                      characterName: 'Ketil',
                      image: 'assets/images/stuff/HideakiTeuka-ketil.jpg',
                    ),
                    CastCard(
                      realName: 'Kensho Ono',
                      characterName: 'Canute',
                      image: 'assets/images/stuff/KenshoOno-Canute.jpg',
                    ),
                    CastCard(
                      realName: 'Akio Ohtsuka',
                      characterName: 'Thorkell',
                      image: 'assets/images/stuff/AkioOhtsuka-Thorkell.jpg',
                    ),
                    CastCard(
                      realName: 'AlejandroSaab',
                      characterName: 'Einar',
                      image: 'assets/images/stuff/AlejandroSaab-Einar.jpg',
                    ),
                    CastCard(
                      realName: 'Naoya Uchida',
                      characterName: 'Askeladd',
                      image: 'assets/images/stuff/NaoyaUchida-Askeladd.jpg',
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
  final String realName;
  final String characterName;
  final String image;

  const CastCard({
    Key? key,
    required this.realName,
    required this.characterName,
    required this.image,
  }) : super(key: key);

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      characterName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Real Name: $realName',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16.0),
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
