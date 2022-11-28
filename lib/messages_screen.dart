import 'package:defender/sms_service.dart';
import 'package:defender/tensor_flow_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    loadMessages();
    super.initState();
  }

  Future<void> loadMessages() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
        count: 10,
      );
      debugPrint('sms inbox messages: ${messages.length}');
      setState(() => _messages = messages);
    } else {
      await Permission.sms.request();
    }
  }

  Future<SmsMessageType> getMessageType(SmsMessage message) async {
    return await TfLiteHelper(message.body ?? '').getAccuracyType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _messages.length,
        itemBuilder: (BuildContext context, int i) {
          var message = _messages[i];
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                  future: getMessageType(message),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          decoration: BoxDecoration(
                            color: snapshot.data == SmsMessageType.SPAM
                                ? Colors.red
                                : snapshot.data == SmsMessageType.HAM
                                    ? Colors.green
                                    : Colors.yellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: getMessageCard(message));
                    } else {
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: getMessageCard(message));
                    }
                  }));
        },
      ),
    );
  }

  getMessageCard(SmsMessage message) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message.sender ?? '',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  message.date.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message.body ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
