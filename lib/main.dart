import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3_193156/exam.dart';
import 'package:lab3_193156/calendar.dart';
import 'package:lab3_193156/notifications.dart';
import 'package:lab3_193156/examWidget.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './register.dart';
import './login.dart';
import './map.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exams Schedule',style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                // NotificationService().showNotifications();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Background color
                // Text color
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Padding
                shape: RoundedRectangleBorder( // Border radius
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle( // Text style
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 3,
              ),
              child: Text('Login', style: TextStyle(
                color: Colors.white,
              ),),
            ),
            ElevatedButton(


              onPressed: () {
                // Navigate to the registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,

                padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 3,
              ),
              child: Text('Register', style: TextStyle(
                color: Colors.white,
              ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ExamAppointment> _examAppointments = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void _addExamAppointment(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NovElement(_addNewAppointmentToList),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadExamAppointments();
  }

  void _loadExamAppointments() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('examAppointments')
          .get();

      final appointments = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ExamAppointment(
          id: doc.id,
          examName: data['examName'],
          date: (data['date'] as Timestamp).toDate(),
          longitude: data['longitude'],
          latitude: data['latitude'],
        );
      }).toList();

      setState(() {
        _examAppointments = appointments;
      });
    }
  }

  void _addNewAppointmentToList(ExamAppointment ea) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('examAppointments')
          .add({
        'examName': ea.examName,
        'date': ea.date,
        'longitude': ea.longitude,
        'latitude': ea.latitude,
      });
      _loadExamAppointments();
    }
  }

  void _openCalendar(BuildContext ctx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyCalendar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addExamAppointment(context),
          ),
          IconButton(
            icon: Icon(Icons.edit_calendar),
            onPressed: () => _openCalendar(context),
          ),
          IconButton(
            onPressed: () {
              NotificationService().showNotifications();
            },
            icon: Icon(Icons.notifications),
            iconSize: 40,
            color: Colors.grey,
          ),
        ],
      ),
      body: Center(
        child: _examAppointments.isEmpty
            ? Text("There are no exam appointements")
            : ListView.builder(
          itemBuilder: (ctx, index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                children: [
                  ListTile(
                    title: Text(_examAppointments[index].examName),
                    subtitle: Text(DateFormat('dd.MM.yyyy').format(
                        _examAppointments[index].date!)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapView(
                            latitude: double.tryParse(
                                _examAppointments[index].latitude)!,
                            longitude: double.tryParse(
                                _examAppointments[index].longitude)!,
                            locationName:
                            _examAppointments[index].examName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Background color
                      // Text color
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Padding
                      shape: RoundedRectangleBorder( // Border radius
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle( // Text style
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 3,
                    ),
                    child: Text('See Location',style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),
                ],
              ),
            );
          },
          itemCount: _examAppointments.length,
        ),
      ),
    );
  }
}