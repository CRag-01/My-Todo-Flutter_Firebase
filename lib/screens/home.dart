import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_task.dart';
import 'package:intl/intl.dart';
import 'description.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.indigo, //                   <--- border color
        width: 5.0,
      ),
    );
  }

  String uid='';
  @override

  void initState()
  {
    getuid();
    super.initState();
  }

  getuid() async
  {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      uid = user.uid;

    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.black54,
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async{
            await FirebaseAuth.instance.signOut();
            Fluttertoast.showToast(msg: 'Logged Out');
          },
        ),
      ]),
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(stream: Firestore.instance.collection('tasks').document(uid).collection('mytasks').snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
                height: 100,
              ),
            );
          }
          else{
            final docs = snapshot.data!.documents;

            return Expanded(
              child: ListView.builder(itemCount: docs.length,
              itemBuilder: (context, index){
                var time = (docs[index]['timestamp'] as Timestamp).toDate();
                var deadline = docs[index]['deadline'];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(
                      title: docs[index]['title'],
                      description: docs[index]['description'],
                    )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom:10),
                    decoration: BoxDecoration(
                      color: Color(0xff121211),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    height: 130,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                        Container(
                          margin: EdgeInsets.only(left:20),
                            child: Text(docs[index]['title'],style: GoogleFonts.roboto(fontSize: 22,
                                fontWeight: FontWeight.bold),)),
                        Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(docs[index]['description'],style: GoogleFonts.kanit(fontSize: 15),)),
                        Container(
                          margin: EdgeInsets.only(top: 10,left: 20),
                          child: Row(
                            children: [
                              Text('Added: ',style: TextStyle(color: Colors.greenAccent)),
                              SizedBox(width: 10),
                              Text(DateFormat.yMd().add_jm().format(time).toString(),
                                style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                        Container(
                        margin: EdgeInsets.only(top: 5,left: 20),
                        child: Row(
                          children: [
                            Text('Deadline: ',style: TextStyle(color: Colors.red)),

                            Text(deadline,style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        ),
                        ]
                        ),
                        Container(
                          child: IconButton(icon: Icon(Icons.delete, color: Color(0xffc7343b)),
                            onPressed: () async{
                            await Firestore.instance
                                .collection('tasks')
                                .document(uid)
                                .collection('mytasks')
                                .document(docs[index]['time']).delete();
                            },)
                        )
                      ],
                    ),),
                );
                  }),
            );

          }
        },),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color:Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
      },),
    );
  }
}
