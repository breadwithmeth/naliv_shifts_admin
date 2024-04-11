import 'package:flutter/material.dart';
import 'package:naliv_shifts_naliv/pages/loginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        shadowColor: Colors.black38,
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Stack(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const Text("Смены тип"),
              ],
            ),
          ),
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Stack(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Text("Календарь тип"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
