import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class MealCard extends StatelessWidget {
  String imgPath;
  String name;
  String time;
  bool isFavorite;
  Function()? update;

  MealCard(
      {super.key,
      required this.imgPath,
      required this.name,
      required this.isFavorite,
      required this.time,
      this.update});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: ListTile(
          tileColor: Colors.blue,
          textColor: Colors.white,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(width: 70, imgPath),
                ),
              ),
              Text(
                "$name",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          leading: Text(
            '$time',
            style: TextStyle(fontSize: 20),
          ),
          trailing: IconButton(
              onPressed: update,
              icon: Icon(
                  isFavorite == false ? Icons.favorite_outline : Icons.favorite,
                  color: Colors.red)),
        ),
      ),
    );
  }
}
