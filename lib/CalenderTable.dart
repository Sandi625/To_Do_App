import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'main.dart';

void main() => runApp(MyApp());

class CalenderTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Table Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Table Calendar Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2050),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
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
          ),
        
Expanded(
  child: Container(
    color: Colors.grey[200],
    child: Center(
      child: _selectedDay != null
          ? Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Selected Day: ${_selectedDay!.toString()}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Events:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    ..._getEventsForSelectedDay(),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddEventDialog();
                    },
                    child: Text('Add Event'),
                  ),
                ),
              ],
            )
          : Text(
              'No day selected',
              style: TextStyle(fontSize: 18),
                      ),
                      
              ),
              
            ),
            
          ),
          
        ],
        
      ),
      
    );
    
  }

 void _showAddEventDialog() {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController titleController = TextEditingController();
      TextEditingController descController = TextEditingController();
      return AlertDialog(
        title: Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter event title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: descController,
              decoration: InputDecoration(
                hintText: 'Enter event description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event description';
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                setState(() {
                  if (_events[_selectedDay!] != null) {
                    _events[_selectedDay!]!.add(titleController.text);
                  } else {
                    _events[_selectedDay!] = [titleController.text];
                  }
                  // if (_events[_selectedDay!] != null) {
                  //   _events[_selectedDay!]!.add(titleController.text);
                  // } else {
                  //   _events[_selectedDay!] = [titleController.text];
                  // }
                
                  addEventToDatabase(_selectedDay!,
                      titleController.text, descController.text);
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}
void addEventToDatabase(DateTime date, String eventTitle, String eventDesc) {
  // implementasi kode untuk menyimpan data ke database di sini
  print('Event added to database: $eventTitle - $eventDesc on $date');
}



  
// fungsi untuk menyimpan data event ke dalam database atau melakukan operasi lainnya
// implementasi kode untuk menyimpan data ke database di sini
    

  List<Widget> _getEventsForSelectedDay() {
    List<dynamic> events = _events[_selectedDay!] ?? [];
    if (events.isNotEmpty) {
      return events
          .map(
            (event) => Text(
              event.toString(),
              style: TextStyle(fontSize: 16),
            ),
          )
          .toList();
    } else {
      return [
        Text(
          'No events for this day',
          style: TextStyle(fontSize: 16),
        ),
      ];
    }
  }
}
