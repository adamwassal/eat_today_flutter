import 'package:eat_today/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  var controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(bottom: 70),
          child: PageView(
            controller: controller,
            onPageChanged: (value) => setState(() {
              isLastPage = value == 2;
            }),
            children: [
              Container(
                color: const Color.fromARGB(143, 244, 67, 54),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/relax.png',
                        width: 300,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        '.لا تفكر ماذا سوف تأكل اليوم\n اترك الأمر علينا',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(78, 33, 222, 243),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/eat.png',
                        width: 300,
                      ),
                      Text(
                        'ماذا سوف آكل اليوم؟',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: const Color.fromARGB(161, 76, 175, 79),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/research.png',
                        width: 300,
                      ),
                      Text(
                        '.ادخل و القِ نظرة',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: isLastPage
            ? TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showLogin', true);

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  'Get started',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      const Color.fromARGB(255, 62, 95, 63)),
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(70)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1))),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          controller.animateToPage(2,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 12, 92, 49),
                          ),
                        )),
                    Center(
                      child: SmoothPageIndicator(
                        count: 3,
                        controller: controller,
                        effect: WormEffect(
                          spacing: 16,
                          dotColor: const Color.fromARGB(255, 66, 86, 66),
                          activeDotColor: Colors.teal,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          double? page = controller.page;
                          controller.animateToPage(
                            page!.toInt() + 1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 12, 92, 49),
                          ),
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}
