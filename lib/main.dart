import 'package:flutter/material.dart';
import 'package:tabnews_flutter/components/content/list.dart';
import "package:timeago/timeago.dart" as timeago;
import 'client/client.dart';
void main() {
  timeago.setLocaleMessages("pt", timeago.PtBrMessages());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabNews',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const HomePage(title: 'TabNews'),
    );
  }
}
class HomePage extends StatefulWidget {

  final String title;
  const HomePage({super.key, required this.title});
  @override
  HomePageState createState() => HomePageState();
}
class HomePageState extends State<HomePage> {
  final pageViewController = PageController();
  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageViewController,
        children: const [
          ContentList(strategy: Strategy.relevant),
          ContentList(strategy: Strategy.newest),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: pageViewController,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            elevation: 8.0,

            currentIndex: pageViewController.page?.round() ?? 0,
            onTap: (index) {
              pageViewController.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.star), label: "Relevantes"),
              BottomNavigationBarItem(icon: Icon(Icons.new_releases), label: "Recentes"),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Conta")
            ],
          );
        },
      ),
    );
  }
}
