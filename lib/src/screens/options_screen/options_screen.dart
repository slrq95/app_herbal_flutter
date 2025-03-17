import 'package:app_herbal_flutter/src/screens/options_screen/calendar_draft.dart';
import 'package:app_herbal_flutter/src/screens/options_screen/dashboard_screen.dart';
import 'package:app_herbal_flutter/src/screens/options_screen/patient_screen.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/bottom_nav_index_provider.dart';
import 'package:provider/provider.dart';

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});



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
                height: 110,
                color: CustomTheme.containerColor,
                child: Row(
                  
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      
                      onPressed: () => {}, // Trigger sign-out
                      icon: Hero(
                        tag: 'signOutIcon',
                        child: Image.asset(
                          'lib/src/assets/images/sign_out.png',
                          width: 190.0,
                          height: 190.0,
                        ),
                      ),
                      iconSize: 100.0,
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
          height: 120.0, // Set height for BottomNavigationBar
     child: BottomNavigationBar(
  backgroundColor: CustomTheme.containerColor,
  selectedItemColor: CustomTheme.lettersColor,
  unselectedItemColor: Colors.grey,
  currentIndex: currentIndex,
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: SizedBox(
        width: 50, // Adjust width
        height: 50, // Adjust height
        child: Icon(Icons.dashboard_sharp, size: 50),
      ),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: SizedBox(
        width: 60,
        height: 60,
        child: Icon(Icons.person, size: 60),
      ),
      label: 'Pacientes',
    ),
    BottomNavigationBarItem(
      icon: SizedBox(
        width: 50,
        height: 50,
        child: Icon(Icons.calendar_month_rounded, size: 50),
      ),
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
