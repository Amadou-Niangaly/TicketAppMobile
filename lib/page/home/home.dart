import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_app/page/chat.dart';
import 'package:ticket_app/page/home/add_user.dart';
import 'package:ticket_app/page/home/widgets/statistique.dart';
import 'package:ticket_app/page/list_users.dart';
import 'package:ticket_app/page/notifications.dart';
import 'package:ticket_app/page/profil.dart';
import 'package:ticket_app/page/tickets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomePageContent(),
    const TicketPage(),
    const ChatPage(),
    const ListUsersPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFB),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>const NotificationsPage()) ,
                
                );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: "home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "tickets",
            icon: Icon(Icons.confirmation_num),
          ),
          BottomNavigationBarItem(
            label: "chat",
            icon: Icon(Icons.chat),
          ),
         
           BottomNavigationBarItem(
            label: "List users",
            icon: Icon(Icons.list),
          ),
           BottomNavigationBarItem(
            label: "profil",
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black87,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  Future<Map<String, dynamic>> _getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(currentUser.uid)
          .get();
      return userDoc.data() ?? {};
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<Map<String, dynamic>>(
                  future: _userDataFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.containsKey('nom')) {
                      return const Text(
                        "Salut !",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      );
                    }

                    final userData = snapshot.data!;
                    final String name = userData['nom'] ?? 'Utilisateur';

                    return Text(
                      "Salut $name !",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddUserPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5F67EA),
                  ),
                  child: const Text(
                    "Add user+",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FutureBuilder<Map<String, dynamic>>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final userData = snapshot.data!;
                final String prenom=userData['prenom']?? 'prenom non Defini';
                final String name = userData['nom'] ?? 'Nom Non Défini';
                final String role = userData['role'] ?? 'Rôle Non Défini';
                final String avatarUrl = userData['avatarUrl'] ?? 'assets/images/default.png';

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF5F67EA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(avatarUrl),
                        radius: 30,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                               Text(
                                name,
                                style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                               ),
                               const SizedBox(width: 10,),
                                Text(
                            prenom ,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                            ],
                          ),
                         
                          Text(
                            role,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              "Statistique sur les Tickects",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const SizedBox(
                height: 300,
                child: PieChartSample(),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
