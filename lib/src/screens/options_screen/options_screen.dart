import 'package:app_herbal_flutter/src/screens/options_screen/calendar_draft.dart';
import 'package:app_herbal_flutter/src/screens/options_screen/dashboard_screen.dart';
import 'package:app_herbal_flutter/src/screens/options_screen/patient_screen.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/bottom_nav_index_provider.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import 'package:app_herbal_flutter/src/api/provider/auth_services/dio_auth_provider.dart';
=======
import 'package:app_herbal_flutter/src/api/provider/auth_services/auth_provider.dart';
>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  Future<void> signOut(BuildContext context) async {
    final authProvider = Provider.of<DioAuthProvider>(context, listen: false);
    await authProvider.logout(); // Remove token

    if (!context.mounted) return;
    Navigator.of(context).pushReplacementNamed('/signin'); // Navigate to login
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Bottomnavindexprovider>(context);
    int currentIndex = provider.bottomNavIndex;

    List<Widget> screens = const <Widget>[
      DashboardScreen(),
      PantientPage(),
      ScreenCalendar(),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor,
        body: SingleChildScrollView(  // Wrap the entire body with SingleChildScrollView
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.only(top: 20.0),
                height: 80,
                color: CustomTheme.containerColor,
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
                          width: 120.0,
                          height: 120.0,
                        ),
                      ),
                      iconSize: 60.0,
                    ),
                  ],
                ),
              ),
              // Use Expanded for the content, ensuring it resizes correctly with scrolling.
              SizedBox(
                height: MediaQuery.of(context).size.height - 80, // Adjust the height based on the header size
                child: screens[currentIndex],
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 90.0, // Set height for BottomNavigationBar
          child: BottomNavigationBar(
            backgroundColor: CustomTheme.containerColor,
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
      ),
    );
  }
}
