import 'package:flutter/material.dart';
import "package:flutter_session_manager/flutter_session_manager.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabnews_flutter/client/entities/auth.dart';
import 'package:tabnews_flutter/client/entities/content.dart';
import 'package:tabnews_flutter/client/entities/user.dart';
import 'package:tabnews_flutter/components/content/list.dart';
import "package:timeago/timeago.dart" as timeago;

import 'client/client.dart';
import 'components/account_page.dart';

void main() {
  timeago.setLocaleMessages("pt", timeago.PtBrMessages());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SessionState>(
      create: (_) {
        var session = SessionState();
        session.loadSession();
        return session;
      },
      child: MaterialApp(
        title: 'TabNews',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          ),
          textTheme: GoogleFonts.ubuntuTextTheme(),
        ),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            ),
            textTheme: GoogleFonts.ubuntuTextTheme(ThemeData.dark().textTheme)),
        themeMode: ThemeMode.system,
        home: const HomePage(title: 'TabNews'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  HomePageState createState() => HomePageState();
}

class SessionState extends ChangeNotifier {
  Session? session;
  late bool isLoading;
  User user = User.createAnonymous();

  bool canUpdatePost(Content content) {
    return session != null &&
        (user.id == content.owner_id ||
            user.features.contains("update:content:others"));
  }

  SessionState() {
    isLoading = true;
    session = null;
  }

  Future<void> loadSession() async {
    SessionManager sessionManager = SessionManager();
    var sessionJson = await sessionManager.get("session");
    isLoading = false;
    if (sessionJson == null) {
      session = null;
    } else {
      session = Session.fromJson(sessionJson);
      user = await TabNewsClient(session!).getUser();
    }
    notifyListeners();
  }

  Future<User> fetchUser() async {
    user = await TabNewsClient(session!).getUser();
    notifyListeners();
    return user;
  }

  void setSession(Session session) {
    isLoading = false;
    this.session = session;
    notifyListeners();
  }
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
          AccountPage()
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.star), label: "Relevantes"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.new_releases), label: "Recentes"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: "Conta")
            ],
          );
        },
      ),
    );
  }
}
