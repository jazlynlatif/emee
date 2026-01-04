import 'package:emee/pages/home-page/profile_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MedicalNotes extends StatefulWidget {
  const MedicalNotes({super.key});

  @override
  State<MedicalNotes> createState() => _MedicalNotesState();
}

class _MedicalNotesState extends State<MedicalNotes> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _header = TextEditingController();
  final TextEditingController _note = TextEditingController();

  final List<String> dropdownOptions = ['Edit', 'Hapus'];
  final Map<String, IconData> dropdownOptionsIcon = {'Edit' : Icons.edit, 'Hapus' : Icons.delete};

  void doNote(String action, {String title = '', String note = '', int noteId = -1}) {
    final theme = Theme.of(context);

    if(action == 'Edit') {
      _header.text = title;
      _note.text = note;
    }

    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          height: 400,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action == 'add' ? 'Tambah Catatan' : 'Edit Catatan',
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Header',
                  style: theme.textTheme.labelLarge,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'masukkan header disini!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  ),
                  controller: _header,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Masukkan header!";
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Notes',
                  style: theme.textTheme.labelLarge,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  minLines: 2,
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'masukkan notes disini!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  ),
                  controller: _note,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Masukkan note!";
                    }
                  },
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      final dynamic regData;

                      if (_formKey.currentState!.validate()) {
                        if(action == 'add') {
                          regData = await postMedNotesData(_header.text, _note.text);
                        }
                        else {
                          regData = await editMedNotesData(_header.text, _note.text, noteId);
                        }
                        if(regData.statusCode == 201) {
                          Navigator.pop(context); 
                          setState(() {
                            _header.clear();
                            _note.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(regData.body))
                          );
                      }
                      }
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary
                    ),
                    child: Text(
                      action == 'add' ? 'tambah catatan' : 'edit catatan',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: fetchData('mednotes'),
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

        //   if (data is Map && data.containsKey("error")) {
        //     return Center(child: Text("Unauthorized. Please log in again."));
        //   }
        // }

        final userData = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Catatan Medis'),
          ),
          body : SafeArea(
            child: Column(
              children: [
                userData.isEmpty 
                ? Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(child: Text('Tidak ada catatan :)')),
                  ],
                ) 
                : Expanded(
                  flex : 1,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      final data = userData[index];
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: theme.colorScheme.primary
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                // color: Colors.pink[50],
                                borderRadius: BorderRadius.vertical(
                                  top : Radius.circular(15)
                                )
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    data['title'],
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  Spacer(),
                                  PopupMenuButton(
                                    icon: Icon(Icons.more_horiz),
                                    onSelected: (value) async {
                                      if(value == 'Edit') {
                                        doNote(value, title: data['title'], note: data['notes'], noteId: data['id']);
                                      } 
                                      else if(value == 'Hapus') {
                                        final dataDelete = await deleteData(data['id'], 1);
                                        if(dataDelete.statusCode == 204) {
                                          setState(() {});
                                        }
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return dropdownOptions.map((String value) {
                                        return PopupMenuItem(
                                          value: value,
                                          child: Row(
                                            children: [
                                              Text(value),
                                              Spacer(),
                                              Icon(dropdownOptionsIcon[value])
                                            ],
                                          )
                                        );
                                      }).toList();
                                    },
                                  )
                                ],
                              )
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              decoration: BoxDecoration(),
                              child: Text(data['notes'])
                            ),
                            SizedBox(
                              height: 13,
                            )
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _note.clear();
              _header.clear();
              doNote("add");
            }, 
            tooltip: 'Tambah catatan',
            backgroundColor: theme.colorScheme.primary,
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        );
      }
    );
  }
}