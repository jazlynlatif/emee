import 'package:emee/pages/auth-page/auth_api.dart';
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
  List<String> additionalInfo = ['Catatan Medis', 'Kontak Darurat'];
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          title: const Text(
            'Log out',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
          content: const Text(
            'are you sure?',
            style: TextStyle(
              fontStyle: FontStyle.italic
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {

                await logout();

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

        final gender = userData['gender'].toString().toLowerCase() == 'female' ? 'Perempuan' : 'Laki - laki';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title : const Text(
              'Profil'
            )
          ),
          body : Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: theme.colorScheme.primary, width : 1.5)
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userData['first_name']} ${userData['last_name']}",
                              style: theme.textTheme.titleLarge,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              "${gender} (${getAge(userData['birth_date']).toString()})",
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     // Navigator.push(
                      //     //   context, 
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => const EditProfile()
                      //     //   )
                      //     // );
                      //   }, 
                      //   icon: Icon(Icons.edit)
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height : 30
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Infomasi tambahan',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary, 
                        spreadRadius: 0.5, 
                        blurRadius: 2, 
                        offset: Offset.zero, 
                      )
                    ],
                    borderRadius: BorderRadius.circular(25)
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
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                          child: Row(
                            children: [
                              Text(
                                additionalInfo[index],
                                style: theme.textTheme.titleSmall,
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
                    'Aksi lainnya',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    signOutButton();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary, 
                          spreadRadius: 0.5, 
                          blurRadius: 2, 
                          offset: Offset.zero, 
                        )
                      ],
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sign out',
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacer(),
                        Icon(
                          Icons.logout_outlined
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        );

      } 
      
      
    );
  }
}