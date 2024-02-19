import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:intl/intl.dart';

import '../exam.dart';

class NovElement extends StatefulWidget{

  final Function addExamAppointment;

  NovElement(this.addExamAppointment);

  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement>{

  final _examNameController = TextEditingController();
  late DateTime? _selectedDate = null;

  late String examName;
  // late String date;

  void _submitData(){
    if(_examNameController.text.isEmpty || _selectedDate == null){
      return;
    }
    final insertedExamTitle = _examNameController.text;
    final latitude = '42.00423'; // longitude and latitude for FINKI
    final longitude = '21.40954';
    final examAppointment = ExamAppointment(id:nanoid(5), examName: insertedExamTitle, date: _selectedDate,latitude: latitude,longitude: longitude);
    widget.addExamAppointment(examAppointment);
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100)
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _examNameController,
            decoration: InputDecoration(labelText: "Exam Name:"),
            onSubmitted: (_) => _submitData(),
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Date:",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: _selectedDate == null ? '' : DateFormat.yMMMd().format(_selectedDate!),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _submitData,
            child: Text("Add"),
          )
        ],
      ),
    );
  }
}