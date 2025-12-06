import 'package:emee/pages/home-page/profile_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmergencyContacts extends StatefulWidget {
  const EmergencyContacts({super.key});

  @override
  State<EmergencyContacts> createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();

  void doNum(String action, {String contactname = '', String phonenum = '', int contactId = -1}) {
    final theme = Theme.of(context);

    if(action == 'edit') {
      _contactController.text = contactname;
      _phonenumberController.text = phonenum;
    }

    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Container(
          height: 380,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action == 'add' ? 'Add Contact' : 'Edit Contact',
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Contact Name',
                  style: theme.textTheme.titleSmall
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter the contact name!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  ),
                  controller: _contactController,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Enter the contact name!";
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Phone Number',
                  style: theme.textTheme.titleSmall
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter the phone number!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  ),
                  controller: _phonenumberController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(13)
                  ],
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Enter the phone number!";
                    }
                  },
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final dynamic getData;

                        if(action == 'add') {
                          getData = await postEmerContactsData(_contactController.text, _phonenumberController.text);
                        } else {
                          getData = await editEmerContactsData(_contactController.text, _phonenumberController.text, contactId);
                        }

                        if(getData.statusCode == 201) {
                          Navigator.pop(context); 
                          setState(() {
                            _contactController.clear();
                            _phonenumberController.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(getData.body))
                          );
                        }
                      }
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary
                    ),
                    child: Text(
                      action == 'add' ? 'Add Contact' : 'Edit Contact',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                  ),
                )
              ],
            )
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: fetchData('emergencycontacts'),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if(snapshot.hasError) {
          return Center(child: Text("Error : ${snapshot.error}"),);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          print('null i guess');
          return const Center(child: Text("No data"));
        }

        // if (snapshot.hasData) {
        //   final data = snapshot.data;

        //   print(snapshot.data);

        //   if (data is Map && data.containsKey("error")) {
        //     return Center(child: Text("Unauthorized. Please log in again."));
        //   }
        // }

        final userData = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text('Emergency Contacts'),
          ),
          body: Column(
            children: [
              userData.isEmpty ? Center(child: Text('No data available'))
              : Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final data = userData[index];
                    return Container(
                      width : double.infinity,
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 1.5
                        )
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.pink,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['contact_name'],
                                style: theme.textTheme.titleMedium,
                              ),
                              SizedBox(
                              ),
                              Text(
                                data['phone_number']
                              )
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              print(data['id']);
                              doNum('edit', contactname: data['contact_name'], phonenum: data['phone_number'], contactId: data['id']);
                            }, 
                            icon: Icon(Icons.edit)
                          )
                        ],
                      ),
                    );
                  }
                )
              ),
              Spacer(),
              
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              doNum('add');
            }, 
            tooltip: 'Add a note',
            backgroundColor: theme.colorScheme.primary,
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        );
      },
    );
  }
}