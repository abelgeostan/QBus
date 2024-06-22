import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class TicketScreen extends StatefulWidget {
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late String userName;
  late String busName;
  late DateTime dateTime;
  late String uniqueCode;
  late Duration ticketDuration;
  late Timer ticketTimer;
  bool isTicketExpired = false;

  @override
  void initState() {
    super.initState();

    // Initialize ticket details
    userName = "Teo Thaliath";
    busName = "KSRTC";
    dateTime = DateTime.now();
    uniqueCode = generateUniqueCode();
    ticketDuration = Duration(minutes: 1); // Change the duration as needed
    startTicketTimer();

    // Show the ticket pop-up
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showTicketPopup(context);
    });
  }

  // Generate a unique code (for demonstration purposes)
  String generateUniqueCode() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  // Start the ticket expiration timer
  void startTicketTimer() {
    ticketTimer = Timer(ticketDuration, () {
      setState(() {
        isTicketExpired = true;
      });
    });
  }

  // Show the ticket pop-up
  void showTicketPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(image: AssetImage("assets/qbus_logo.png")),
                  Image(image: AssetImage("assets/qr_code.jpg")),
                  Text('User: $userName',style: TextStyle(fontSize: 20)),
                  Text('Bus: $busName',style: TextStyle(fontSize: 20)),
                  Text('Date & Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}',style: TextStyle(fontSize: 20)),

                  Text('Ticket Code: $uniqueCode',style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  if (!isTicketExpired)
                    CountdownTimer(
                      duration: ticketDuration,
                      onTimerExpires: () {
                        Navigator.of(context).pop(); // Close the dialog when the timer expires
                      },
                    ),
                  if (isTicketExpired)
                    Text(
                      'Ticket Expired!',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket'),
      ),
      body: Container(),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final Function onTimerExpires;

  CountdownTimer({
    required this.duration,
    required this.onTimerExpires,
  });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer timer;
  late Duration countdown;

  @override
  void initState() {
    super.initState();
    countdown = widget.duration;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (countdown.inSeconds == 0) {
          timer.cancel();
          widget.onTimerExpires();
        } else {
          countdown -= Duration(seconds: 1);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int minutes = countdown.inMinutes;
    int seconds = countdown.inSeconds % 60;

    return Text(
      'Ticket expires in: $minutes:${seconds.toString().padLeft(2, '0')}',
      style: TextStyle(color: Colors.red,fontSize: 30),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: TicketScreen(),
  ));
}
