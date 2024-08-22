import 'package:eat_today/cubit/main_cubit.dart';
import 'package:eat_today/cubit/main_states.dart';
import 'package:eat_today/screens/detail.dart';
import 'package:eat_today/screens/home.dart';
import 'package:eat_today/widgets/mealcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  update(bool isFavorite, String name) {
    MainCubit().updateData(isFavorite, name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit()
        ..initSql()
        ..getFavoriteData(),
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
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
            ),
            body: BlocBuilder<MainCubit, MainStates>(
              builder: (context, state) {
                var cubit = MainCubit.get(context);
                if (cubit.listFavourite.length == 0) {
                  return Center(
                    child: Text(
                      'لا توجد مفضلات',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: cubit.listFavourite.length,
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detail(
                              imgPath: cubit.listFavourite[i]['img'],
                              name: cubit.listFavourite[i]['name'],
                              isFavorite:
                                  cubit.listFavourite[i]['isfavorite'] == 1,
                              detail: cubit.listFavourite[i]['detail'],
                              update: () {
                                update(
                                    cubit.listFavourite[i]['isfavorite'] == 1,
                                    cubit.listFavourite[i]['name']);
                                MainCubit.get(context).getData();
                                MainCubit.get(context).getFavoriteData();
                              },
                            ),
                          ),
                        );
                      },
                      child: MealCard(
                        imgPath: cubit.listFavourite[i]['img'],
                        name: cubit.listFavourite[i]['name'],
                        isFavorite: cubit.listFavourite[i]['isfavorite'] == 1,
                        time: cubit.listFavourite[i]['time'],
                        update: () {
                          update(cubit.listFavourite[i]['isfavorite'] == 1,
                              cubit.listFavourite[i]['name']);
                          MainCubit.get(context).getData();
                          MainCubit.get(context).getFavoriteData();
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
