// ignore_for_file: prefer_const_constructors

import 'package:eat_today/cubit/main_cubit.dart';
import 'package:eat_today/cubit/main_states.dart';
import 'package:eat_today/screens/detail.dart';
import 'package:eat_today/screens/favorites.dart';
import 'package:eat_today/screens/login.dart';
import 'package:eat_today/screens/profile.dart';
import 'package:eat_today/widgets/mealcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
    getusername();
  }

  DateTime today = DateTime.now();
  bool active = false;
  String? username = "";

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  update(bool isFavorite, String name) {
    MainCubit().updateData(isFavorite, name);
  }

  checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool showLogin = prefs.getBool('active') ?? false;
    active = showLogin;
    print('here $showLogin');
  }

  getusername() async {
    final prefs = await SharedPreferences.getInstance();
    String? username1 = prefs.getString('username') ?? 'guest';

    username = username1;

    print('username: $username');
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    final showLogin = prefs.setBool('active', false);
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit()
        ..initSql()
        ..insertData()
        ..getData(),
      child: BlocConsumer<MainCubit, MainStates>(
        listener: (context, state) {},
        builder: (context, state) {
          print('here $active');
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              title: const Text('What are we going to eat today?'),
              centerTitle: true,
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      'مرحباً, ${username}',
                      style: TextStyle(
                        fontSize: 20,
                        backgroundColor: Color.fromARGB(192, 79, 79, 79),
                      ),
                    ),
                    accountEmail: Text(''),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/bg.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  ListTile(
                    title: Text('المفضلات'),
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Favorites()));
                    },
                  ),
                  ListTile(
                    title: Text('الملف الشخصي'),
                    leading: Icon(
                      Icons.person,
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                  ),
                  ListTile(
                    title: Text('تسجيل الخروج'),
                    leading: Icon(
                      Icons.logout,
                    ),
                    onTap: () {
                      setState(() {
                        logout();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      });
                    },
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: TableCalendar(
                      locale: "en-US",
                      rowHeight: 40,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      availableGestures: AvailableGestures.all,
                      selectedDayPredicate: (day) => isSameDay(day, today),
                      focusedDay: today,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 10, 16),
                      onDaySelected: _onDaySelected,
                    ),
                  ),
                  Column(
                    children: MainCubit.get(context)
                        .getMealsForDay(today)
                        .map((meal) {
                      return Animate(
                        effects: [
                          FadeEffect(),
                          ScaleEffect(),
                        ],
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Detail(
                                          update: () {
                                            update(meal['isfavorite'] == 1,
                                                meal['name']);
                                            MainCubit().getData();
                                            MainCubit().getFavoriteData();
                                          },
                                          imgPath: meal['img'],
                                          name: meal['name'],
                                          isFavorite: meal['isfavorite'] == 1,
                                          detail: meal['detail'],
                                        )));
                          },
                          child: MealCard(
                              imgPath: meal!['img'],
                              name: meal['name'],
                              isFavorite: meal['isfavorite'] == 1,
                              time: meal['time'],
                              update: () {
                                update(meal['isfavorite'] == 1, meal['name']);
                                MainCubit.get(context).getData();
                              }),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
