import "package:facebook_clone/global/colors.dart";
import "package:flutter/material.dart";
import "package:facebook_clone/signup/su_routes.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpName(),
    );
  }
}

class SignUpName extends StatefulWidget {
  const SignUpName({super.key});

  @override
  State<SignUpName> createState() => _SignUpNameState();
}

class _SignUpNameState extends State<SignUpName> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalColor.facebookBlue,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/signup/homepage');
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: const Text("Name"),
        ),
        body: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "What's your name?",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'First name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Last name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: ElevatedButton(
                  onPressed: () {
                    // Add your onPressed logic here
                    Navigator.popAndPushNamed(context, '/signup/birthdate');
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(300, 50), // set weight, height of our button
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      GlobalColor.facebookBlue,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
