import 'package:eat_today/cubit/main_cubit.dart';
import 'package:eat_today/cubit/main_states.dart';
import 'package:eat_today/screens/home.dart';
import 'package:eat_today/screens/signup.dart';
import 'package:eat_today/widgets/btn.dart';
import 'package:eat_today/widgets/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var usernameController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MainCubit()
          ..initSqlLogin()
          ..getAccountData(),
        child: BlocConsumer<MainCubit, MainStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return SafeArea(
                child: Scaffold(
                  body: Container(
                    padding: EdgeInsets.only(top: 15),
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.blue[900],
                    child: Column(
                      children: [
                        Text(
                          'مرحباً بعودتك',
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Field(
                                hint: 'Username',
                                controller: usernameController,
                                secure: false,
                              ),
                              Field(
                                hint: 'Password',
                                controller: passwordController,
                                secure: true,
                              ),
                              Btn(
                                showText: "تسجيل الدخول",
                                func: () async {
                                  if (MainCubit.get(context).myAccount.any(
                                          (map) =>
                                              map['username'] ==
                                              usernameController.text
                                                  .toString()
                                                  .toLowerCase()) &&
                                      usernameController.text != "" &&
                                      passwordController.text != "") {
                                    for (var i = 0;
                                        i <
                                            MainCubit.get(context)
                                                .myAccount
                                                .length;
                                        i++) {
                                      if (MainCubit.get(context).myAccount[i]
                                                  ['username'] ==
                                              usernameController.text
                                                  .toString() &&
                                          MainCubit.get(context).myAccount[i]
                                                  ['password'] ==
                                              passwordController.text
                                                  .toString()) {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        prefs.setBool('active', true);
                                        print(
                                            'login: ${prefs.getBool('active')}');

                                        prefs.setString(
                                            'username',
                                            MainCubit.get(context).myAccount[i]
                                                ['username'].toString());

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Home()));
                                      }
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const AlertDialog(
                                            backgroundColor: Colors.red,
                                            title: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    'تأكد من الباسوورد و اسم المستخدم',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    'او تأكد من ملء الحقول',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            )));
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 11.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()));
                                        },
                                        child: Text(
                                          'إضغط هنا',
                                          style: TextStyle(
                                            color: Color(0xFFCEE741),
                                          ),
                                        )),
                                    Text(
                                      'إذا كنت لا تملك حسابًا',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
