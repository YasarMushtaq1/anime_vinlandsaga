import 'package:flutter/material.dart';
import '../../widgets/tabbar_navigation.dart';

class CastPage extends StatelessWidget {
  const CastPage({super.key});

 

  @override
  Widget build(BuildContext context) {
    // Mock data for cast members
    List<CastMember> castMembers = [
      CastMember(
        name: 'Aleks Le',
        role: 'Thorfinn',
        originalImageAsset: 'assets/images/stuff/AleksLe-Thorfinn.jpg',
        roleImageAsset: 'assets/images/actors/Thorfinn.jpg',
      ),
      CastMember(
        name: 'Hideaki Teuka',
        role: 'Ketil',
        originalImageAsset: 'assets/images/stuff/HideakiTeuka-ketil.jpg',
        roleImageAsset: 'assets/images/actors/ketil.jpg',
      ),
      CastMember(
        name: 'Kensho Ono',
        role: 'Canute',
        originalImageAsset: 'assets/images/stuff/KenshoOno-Canute.jpg',
        roleImageAsset: 'assets/images/actors/Canut.png',
      ),
      CastMember(
        name: 'Akio Ohtsuka',
        role: 'Thorkell',
        originalImageAsset: 'assets/images/stuff/AkioOhtsuka-Thorkell.jpg',
        roleImageAsset: 'assets/images/actors/Thorkell.png',
      ),
      CastMember(
        name: 'Alejandro Saab',
        role: 'Einar',
        originalImageAsset: 'assets/images/stuff/AlejandroSaab-Einar.jpg',
        roleImageAsset: 'assets/images/actors/Einar.png',
      ),
      CastMember(
        name: 'Naoya Uchida',
        role: 'Askeladd',
        originalImageAsset: 'assets/images/stuff/NaoyaUchida-Askeladd.jpg',
        roleImageAsset: 'assets/images/actors/Askeladd.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cast'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.group,
              color: Color.fromARGB(255, 82, 29, 0),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppBarNavigation(),
                ),
              ); // Navigate to search page
            },
          ),
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: castMembers.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: CastMemberCard(castMember: castMembers[index]),
          );
        },
      ),
    );
  }
}

class CastMember {
  final String name;
  final String role;
  final String originalImageAsset;
  final String roleImageAsset;
  CastMember({
    required this.name,
    required this.role,
    required this.originalImageAsset,
    required this.roleImageAsset,
  });
}

class CastMemberCard extends StatelessWidget {
  final CastMember castMember;

  const CastMemberCard({Key? key, required this.castMember}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 80, // Adjust size here
                      backgroundImage: AssetImage(castMember.originalImageAsset),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Original Image',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 80, // Adjust size here
                      backgroundImage: AssetImage(castMember.roleImageAsset),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Role Image',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              castMember.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              castMember.role,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
