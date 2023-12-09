import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;

    loadPreviousEvents();
  }

  loadPreviousEvents() {
    mySelectedEvents = {
      "2022-09-13": [
        {
          "eventDescp": "11",
          "eventTitle": "111",
          "eventTime": "08:00 AM"
        },
        {
          "eventDescp": "22",
          "eventTitle": "22",
          "eventTime": "02:00 PM"
        }
      ],
      "2022-09-30": [
        {
          "eventDescp": "22",
          "eventTitle": "22",
          "eventTime": "10:30 AM"
        }
      ],
      "2022-09-20": [
        {"eventTitle": "ss", "eventDescp": "ss", "eventTime": "05:00 PM"}
      ]
    };
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New Event',
          textAlign: TextAlign.center,
           style: TextStyle(
          fontSize: 20, // Atur ukuran font di sini
          fontWeight: FontWeight.bold, // Atur gaya font di sini
          fontFamily: 'Roboto', // Atur jenis font di sini
        )),
        
       content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Tambahkan padding di sini
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          
          children: [
            TextField(
              
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Title',
                
              ),
            ),
            TextField(
              controller: descpController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
             TextField(
            readOnly: true,
            onTap: _showTimePicker,
            controller: timeController,
            decoration: InputDecoration(
              labelText: 'Time',
            )),
            if (_selectedTime != null)
              Text(
                'Selected Time: ${_selectedTime!.format(context)}',
                style: TextStyle(fontSize: 16),
              ),
          ],
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            child: const Text('Add Event'),
            onPressed: () {
              if (titleController.text.isEmpty &&
                  descpController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Required title and description'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else if (_selectedTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a time'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                print(titleController.text);
                print(descpController.text);
                print(_selectedTime);

                setState(() {
                  if (mySelectedEvents[
                          DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
                      null) {
                    mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(_selectedDate!)]
                        ?.add({
                      "eventTitle": titleController.text,
                      "eventDescp": descpController.text,
                      "eventTime": _selectedTime!.format(context)
                    });
                  } else {
                    mySelectedEvents[
                        DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
                      {
                        "eventTitle": titleController.text,
                        "eventDescp": descpController.text,
                        "eventTime": _selectedTime!.format(context)
                      }
                    ];
                  }
                });

                // Masukkan ke dalam database atau lakukan operasi lainnya di sini
                addEventToDatabase(
                    _selectedDate!, titleController.text, descpController.text, _selectedTime!.format(context));

                titleController.clear();
                descpController.clear();
                Navigator.pop(context);
                return;
              }
            },
          )
        ],
      ),
    );
  }

  void addEventToDatabase(DateTime date, String eventName, String eventDesc, String eventTime) {
    // Implementasikan kode untuk menyimpan data ke dalam database di sini
    print('Event added to database: $eventName on $date, Time: $eventTime, Description: $eventDesc');
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

     if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
        timeController.text = _selectedTime!.format(context); // Set nilai TextField waktu
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pilih Tanggal dan Masukan Agenda'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDay)) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _listOfDayEvents,
          ),
          ..._listOfDayEvents(_selectedDate!).map(
            (myEvents) => ListTile(
              leading: const Icon(
                Icons.done,
                color: Colors.teal,
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Event Title: ${myEvents["eventTitle"]}'),
              ),
              subtitle: Text('Event Description: ${myEvents["eventDescp"]}'),
             
              trailing: Text('Event Time: ${myEvents["eventTime"]}'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
