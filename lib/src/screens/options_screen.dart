import 'package:app_herbal_flutter/src/screens/calendar_screen.dart';
import 'package:app_herbal_flutter/src/screens/dashboard_screen.dart';
import 'package:app_herbal_flutter/src/screens/patient_screen.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/bottom_nav_index_provider.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/auth_services/dio_auth_provider.dart';
class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

Future<void> signOut(BuildContext context) async {
  final authProvider = Provider.of<DioAuthProvider>(context, listen: false);
  await authProvider.logout(); // Correct function to remove token
  Navigator.of(context).pushReplacementNamed('/signin'); // Navigate to login
}

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Bottomnavindexprovider>(context);
    int currentIndex = provider.bottomNavIndex;

    List<Widget> screens = const <Widget>[
      DashboardScreen(),
      PantientPage(),
      PantallaCalendario(),
    ];

    return Scaffold(
      backgroundColor: CustomTheme.fillColor, // ✅ Set dark background
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            padding: const EdgeInsets.only(top: 20.0),
            height: 100,
            color: CustomTheme.containerColor, // ✅ Navbar background color
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => signOut(context), // Trigger sign-out
                  icon: Hero(
                    tag: 'signOutIcon',
                    child: Image.asset(
                      'lib/src/assets/images/sign_out.png', 
                      width: 90.0,
                      height:90.0,
                    ),
                  ),
                  iconSize: 60.0,
                ),
              ],
            ),
          ),
          Expanded(child: screens[currentIndex]),
        ],
      ),
          bottomNavigationBar: Container(
            height: 140.0, // Set your desired height here
            child: BottomNavigationBar(
            backgroundColor: CustomTheme.containerColor, // Bottom Nav background
            selectedItemColor: CustomTheme.lettersColor,
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_sharp),
                label: 'Dashboard',
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Pacientes',
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_rounded),
                label: 'Calendario',
                ),
              ],
                onTap: (int index) {
                provider.updateBottonNavIndex(index);
                },
              ),
            ),
          );
        }
      }
