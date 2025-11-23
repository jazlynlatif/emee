import 'package:flutter/material.dart';
import 'package:emee/pages/auth-page/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title : const Text(
          'profile'
        )
      ),
      body : Center(
        child: Column(
          children: [
            Text(
              'Jazlyn Jan Keyla Latif',
              style: theme.textTheme.titleLarge,
            ),
            Text(
              '21',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(
              height : 20
            ),
            Container(
              width : double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 40),
              padding: EdgeInsets.only(top : 5, bottom : 15, left : 15, right : 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.primary, width : 4)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Medical Notes',
                        style: theme.textTheme.titleMedium,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {}, 
                        icon: Icon(Icons.edit)
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'No notes'
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width : double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 40),
              padding: EdgeInsets.only(top : 5, bottom : 15, left : 15, right : 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.primary, width : 4)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Address',
                        style: theme.textTheme.titleMedium,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {}, 
                        icon: Icon(Icons.edit)
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'No notes'
                  )
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
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
              }, 
              child: Text(
                'sign out',
                style: TextStyle(
                  color: Color.fromRGBO(1, 1, 1, 1),
                  fontWeight: FontWeight.bold
                )
              )
            ),
            SizedBox(
              height : 25
            )
          ],
        ),
      )
    );
  }
}