import 'package:flutter/material.dart';

class CharacterCardview extends StatelessWidget {
  final String image;
  final String name;
  final String origin;
  final String status;
  final String type;
  const CharacterCardview({
    super.key,
    required this.image,
    required this.name,
    required this.origin,
    required this.status,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 7),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                ClipRRect(
                  //resme radius vermek için
                  borderRadius: BorderRadiusGeometry.circular(6),
                  child: Image.network(image, height: 100),
                ),
                SizedBox(width: 17),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 17),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //sağdan sola hizalama
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),

                      _infoWidget(type: "Köken", value: origin),

                      SizedBox(height: 3),

                      _infoWidget(type: "Durum", value: '$status - $type'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border)),
        ],
      ),
    );
  }

  Column _infoWidget({required String type, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //sağdan sola hizalama
      children: [
        Text(type, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300)),
        Text(value, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
