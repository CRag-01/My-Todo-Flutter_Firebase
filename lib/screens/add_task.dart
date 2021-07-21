import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/widgets/notifcation_dialog.dart';
import 'package:mytodo/datetime/date_format.dart';
import 'package:mytodo/datetime/date_model.dart';
import 'package:mytodo/datetime/datetime_picker_theme.dart';
import 'package:mytodo/datetime/datetime_util.dart';
import 'package:mytodo/datetime/i18n_model.dart';
import 'package:mytodo/datetime/flutter_datetime_picker.dart';



class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  var deadline = "Pick your Deadline";

  addtasktofirebase()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    var time = DateTime.now();
    await Firestore.instance
        .collection('tasks')
        .document(uid)
        .collection('mytasks')
        .document(time.toString())
        .setData(
      {
        'title':titleController.text,
        'description':descriptionController.text,
        'time':time.toString(),
        'timestamp': time,
        'deadline' : deadline
      }
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Task'),
      backgroundColor: Colors.black,),
      body: Container(padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(child: TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Enter Title',border: OutlineInputBorder())
            )
            ),
            SizedBox(height: 10),

            Container(child: TextField(
              controller: descriptionController,
                decoration: InputDecoration(labelText: 'Enter Description',border: OutlineInputBorder())
            )
            ),
            SizedBox(height:10),
            // Container(
            //     child: Row(
            //       children: [
            //
            //         ElevatedButton(
            //             child: Text('Pick Deadline:'),
            //             onPressed: () async{
            //               showDateTimeDialog(context, initialDate: selectedDate, onSelectedDate: (DateTime value) {  },);
            //             },
            //           style: ElevatedButton.styleFrom(
            //               primary: Colors.redAccent,
            //               textStyle: TextStyle(
            //                   fontWeight: FontWeight.bold)),
            //         ),
            //         SizedBox(width: 15.0),
            //         Text(dateFormat.format(selectedDate)),
            //
            //       ],
            //     ),
            //
            // ),
            Container(
              child:
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context, showTitleActions: true,
                          onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          },
                          onConfirm: (date) async {
                            print('confirm $date');
                            setState(() {
                              deadline = DateFormat.yMd().add_jm().format(date).toString();
                            });

                          }, currentTime: DateTime(2021, 7, 21, 23, 12, 34));
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_alarm,
                          size: 15.0,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text (
                          deadline,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black38,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox()
                ],

              ),
            ),

            SizedBox(height: 20),
            Container(
              width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: (){
                      addtasktofirebase();
                      Fluttertoast.showToast(msg: 'Task Successfully Added');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states){
                      if(states.contains(MaterialState.pressed))
                        return Colors.green;
                      return Colors.black;
                    })),
                    child: Text('Add Task',style: GoogleFonts.sanchez(fontSize: 20, fontWeight: FontWeight.bold),))),

          ],
        )
      )
    );
  }
}
