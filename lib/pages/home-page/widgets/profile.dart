import 'package:emee/pages/home-page/emergency_contacts.dart';
import 'package:emee/pages/home-page/medical_notes.dart';
import 'package:emee/pages/home-page/profile_api.dart';
import 'package:flutter/material.dart';
import 'package:emee/pages/auth-page/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? lastIndex;
  List<String> additionalInfo = ['Medical Notes', 'Emergency Contacts'];
  List<Widget> additionalInfoPages = [const MedicalNotes(), const EmergencyContacts()];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   print("init cales");
  //   user_data = fetchData();
  // }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();

  //   final currentIndex = NavIndexProvider.of(context)?.index;

  //   if(currentIndex == 2 && lastIndex != 2) {
  //     user_data = fetchData();
  //   }

  //   lastIndex= currentIndex;
  // }

  int getAge(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final int age = now.year - date.year;
    return age;
  }

  void signOutButton() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Log out'
          ),
          content: const Text(
            'are you sure?'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (Route<dynamic> route) => false
                );
              }, 
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              }, 
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Color.fromRGBO(1, 1, 1, 1)
                ),
              )
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: fetchData('profile'),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if(snapshot.hasError) {
          return Center(child: Text("Error : ${snapshot.error}"),);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No data"));
        }

        if (snapshot.hasData) {
          final data = snapshot.data;

          if (data is Map && data.containsKey("error")) {
            return Center(child: Text("Unauthorized. Please log in again."));
          }
        }

        final userData = snapshot.data![0];

        return Scaffold(
          appBar: AppBar(
            title : const Text(
              'profile'
            )
          ),
          body : Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary, width : 1)
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.pink,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${userData['first_name']} ${userData['last_name']}",
                            style: theme.textTheme.titleLarge,
                          ),
                          Text(
                            "${userData['gender']} (${getAge(userData['birth_date']).toString()})",
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context, 
                          //   MaterialPageRoute(
                          //     builder: (context) => const EditProfile()
                          //   )
                          // );
                        }, 
                        icon: Icon(Icons.edit)
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height : 30
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional information',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width : double.infinity,
                  padding: EdgeInsets.only(top : 5, bottom : 5, left : 15, right : 10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary, width : 1)
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: additionalInfo.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => additionalInfoPages[index]
                            )
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(3),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                additionalInfo[index],
                                style: theme.textTheme.titleMedium,
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Other actions',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width : double.infinity,
                  padding: EdgeInsets.only(top : 5, bottom : 5, left : 15, right : 10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary, width : 1)
                  ),
                  child: GestureDetector(
                    onTap: () {
                      signOutButton();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            'Sign out',
                            style: theme.textTheme.titleMedium,
                          ),
                          Spacer(),
                          Icon(
                            Icons.logout_outlined
                          )
                        ],
                      ),
                    ),
                  )
                ),
              ],
            ),
          )
        );

      } 
      
      
    );
  }
}