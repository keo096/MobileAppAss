import 'package:flutter/material.dart';
// import 'package:smart_quiz/app/views/splash_screen.dart';

class Loading extends StatefulWidget {
  final Widget nextPage;
  const Loading({super.key,required this.nextPage});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();

    // ⏳ Delay splash screen for 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.nextPage,
        ),
      );
    });

    //  Future.delayed(const Duration(seconds: 3), () {
    //   if (!mounted) return;

    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) =>  UserHomePage(username: '',),
    //     ),
    //   );
    // });

    
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4C2D68), Color.fromARGB(255, 166, 93, 197)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "SmartQuiz",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'SFPro'
                    ),
                  ),
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Image.asset(
                      'assets/images/mainLogo.png',
                      width: 200, // Adjust size as needed
                    ),
                  ),

                  const SizedBox(height: 20),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        2,
                      ), // Makes the bar rounded
                      child: const LinearProgressIndicator(
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    child: Text("Loading...",style: TextStyle(fontSize: 20, color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
