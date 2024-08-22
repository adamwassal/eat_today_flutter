import 'package:eat_today/cubit/main_cubit.dart';
import 'package:eat_today/cubit/main_states.dart';
import 'package:eat_today/screens/home.dart';
import 'package:eat_today/screens/login.dart';
import 'package:eat_today/widgets/btn.dart';
import 'package:eat_today/widgets/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordtwoController = TextEditingController();

  final passNotifier = ValueNotifier<PasswordStrength?>(null);

  SignUp({super.key});

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
                    padding: EdgeInsets.only(top: 0),
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.blue[900],
                    child: Column(
                      children: [
                        Text(
                          'رَيَّح عقلك الان',
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Field(
                                hint: 'Username',
                                controller: usernameController,
                                secure: false,
                              ),
                              TextField(
                                obscureText: true,
                                controller: passwordController,
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 155, 155, 155)),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                onChanged: (value) {
                                  passNotifier.value =
                                      PasswordStrength.calculate(text: value);
                                },
                              ),
                              const SizedBox(height: 0),
                              PasswordStrengthChecker(
                                strength: passNotifier,
                                configuration:
                                    PasswordStrengthCheckerConfiguration(
                                  borderColor: Colors.white,
                                  showStatusWidget: false,
                                ),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Field(
                                hint: 'Password confirmation',
                                controller: passwordtwoController,
                                secure: true,
                              ),
                              Btn(
                                showText: "إنشاء حساب",
                                func: () async {
                                  if (passwordController.text.toString() ==
                                          passwordtwoController.text
                                              .toString() &&
                                      usernameController.text != "" &&
                                      passwordController.text != "" &&
                                      !MainCubit.get(context).myAccount.any(
                                          (map) =>
                                              map['username'] ==
                                              usernameController.text
                                                  .toString()
                                                  .toLowerCase()) &&
                                      passwordController.text
                                              .toString()
                                              .length >
                                          8 &&
                                      passNotifier.value.toString() !=
                                          'PasswordStrength.weak') {
                                    MainCubit.get(context).insertAccount(
                                        usernameController.text
                                            .toString()
                                            .toLowerCase(),
                                        passwordController.text.toString());
                                    MainCubit.get(context).getAccountData();
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('active', true);
                                    print('login: ${prefs.getBool('active')}');

                                    prefs.setString(
                                        'username',
                                        usernameController.text
                                            .toString()
                                            .toLowerCase());

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  } else if (passwordController.text
                                          .toString() !=
                                      passwordtwoController.text.toString()) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const AlertDialog(
                                            backgroundColor: Colors.red,
                                            title: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'تحقق من تطابق الباسوورد',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            )));
                                  } else if (MainCubit.get(context)
                                      .myAccount
                                      .any((map) =>
                                          map['username'] ==
                                          usernameController.text
                                              .toString()
                                              .toLowerCase())) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const AlertDialog(
                                            backgroundColor: Colors.red,
                                            title: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'هذا الاسم مستخدم بالفعل',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            )));
                                  } else {
                                    print(passNotifier.value.toString());
                                    print(MainCubit.get(context).myAccount.any(
                                        (map) =>
                                            map['username'] ==
                                            usernameController.text
                                                .toString()
                                                .toLowerCase()));
                                    showDialog(
                                        context: context,
                                        builder: (context) => const AlertDialog(
                                            backgroundColor: Colors.red,
                                            title: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'تأكد من ملء الحقول',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    'او تحقق من قوة الباسوورد',
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
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()));
                                        },
                                        child: Text(
                                          'إضغط هنا',
                                          style: TextStyle(
                                            color: Color(0xFFCEE741),
                                          ),
                                        )),
                                    Text(
                                      'إذا كنت تملك حسابًا',
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
