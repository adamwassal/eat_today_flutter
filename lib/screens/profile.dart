import 'package:eat_today/cubit/main_cubit.dart';
import 'package:eat_today/cubit/main_states.dart';
import 'package:eat_today/screens/home.dart';
import 'package:eat_today/widgets/btn.dart';
import 'package:eat_today/widgets/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getusername();
  }

  String? username = "guest";

  var oldpassword = TextEditingController();
  var newpassword = TextEditingController();
  var confirmpassword = TextEditingController();

  getusername() async {
    final prefs = await SharedPreferences.getInstance();
    String? username1 = prefs.getString('username') ?? 'guest';

    setState(() {
      username = username1;
    });

    print('username: $username');
    return username1;
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Account was updated'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Action to be performed on Undo click
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MainCubit()
          ..initSqlLogin()
          ..getAccountData(),
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
                      icon: Icon(
                        Icons.arrow_back,
                      )),
                ),
                body: Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset('assets/images/user.png'),
                      ),
                      Text(
                        '${username}',
                        style: TextStyle(
                          fontSize: 30,
                          backgroundColor: Color.fromARGB(47, 0, 0, 0),
                          height: 2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Btn(
                          showText: 'تغيير كلمة السر',
                          func: () {
                            List<Map> accounts =
                                MainCubit.get(context).myAccount;
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) => Container(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Field(
                                            hint: 'كلمة السر القديمة',
                                            controller: oldpassword,
                                            secure: false,
                                          ),
                                          Field(
                                            hint: 'كلمة السر الجديدة',
                                            controller: newpassword,
                                            secure: false,
                                          ),
                                          Field(
                                            hint: 'تأكيد كلمة السر الجديدة',
                                            controller: confirmpassword,
                                            secure: false,
                                          ),
                                          Btn(
                                              showText: 'تغيير',
                                              func: () {
                                                for (var i = 0;
                                                    i < accounts.length;
                                                    i++) {
                                                  if (accounts[i]['username'] ==
                                                      username) {
                                                    if (accounts[i]
                                                                ['password'] ==
                                                            oldpassword.text
                                                                .toString() &&
                                                        newpassword.text ==
                                                            confirmpassword
                                                                .text) {
                                                      print('Hello');
                                                      MainCubit.get(context)
                                                          .updateAccount(
                                                              username!,
                                                              newpassword.text
                                                                  .toString());
                                                      MainCubit.get(context)
                                                          .getAccountData();
                                                      oldpassword.clear();
                                                      newpassword.clear();
                                                      confirmpassword.clear();
                                                      Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Home()));
                                                      showSnackBar(context);

                                                      print(
                                                          MainCubit.get(context)
                                                              .myAccount);
                                                    } else if (accounts[i]
                                                            ['password'] !=
                                                        oldpassword.text
                                                            .toString()) {
                                                      i = accounts.length;
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              const AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  title: Center(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          'تأكد من كلمة السر القديمة',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )));
                                                    } else if (newpassword
                                                            .text !=
                                                        confirmpassword.text) {
                                                      i = accounts.length;

                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            const AlertDialog(
                                                          backgroundColor:
                                                              Colors.red,
                                                          title: Center(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  'تأكد من تطابق كلمة السر الجديدة',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }
                                              }),
                                          Spacer(),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                isScrollControlled: true);
                          })
                    ],
                  ),
                ),
              );
            }));
  }
}
