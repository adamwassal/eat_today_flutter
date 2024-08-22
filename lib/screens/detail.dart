import 'package:eat_today/cubit/main_cubit.dart';
import 'package:eat_today/cubit/main_states.dart';
import 'package:eat_today/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class Detail extends StatefulWidget {
  String imgPath;
  String name;
  bool isFavorite;
  String detail;
  Function()? update;

  Detail(
      {super.key,
      required this.imgPath,
      required this.name,
      required this.isFavorite,
      required this.detail,
      required this.update});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MainCubit()
          ..initSql()
          ..getData(),
        child: BlocConsumer<MainCubit, MainStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  title: const Text('What are we going to eat today?'),
                  centerTitle: true,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      icon: Icon(Icons.arrow_back)),
                ),
                body: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) => Container(
                                    color: Colors.blue,
                                    child: Image.asset(
                                      widget.imgPath,
                                      height: 800,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  widget.imgPath,
                                  width: 300,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.isFavorite = !widget.isFavorite;
                                  });
                                  MainCubit.get(context).updateData(
                                      widget.isFavorite, widget.name);
                                  MainCubit.get(context).getData();
                                  widget.update!();
                                },
                                icon: Icon(
                                  widget.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Color.fromARGB(95, 27, 27, 27),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.blue,
                          ),
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(12),
                          child: Text(
                            textAlign: TextAlign.center,
                            widget.detail,
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          },
        ));
  }
}
