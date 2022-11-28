import 'package:defender/helpers.dart';
import 'package:flutter/material.dart';
import 'package:safe_url_check/safe_url_check.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlValidationScreen extends StatefulWidget {
  const UrlValidationScreen({super.key});

  @override
  State<UrlValidationScreen> createState() => _UrlValidationScreenState();
}

class _UrlValidationScreenState extends State<UrlValidationScreen> {
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Validation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        hintText: 'Enter or paste the url',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _urlController.text = '';
                        });
                      },
                      icon: const Icon(Icons.clear)),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  String url = _urlController.text;

                  bool isSafe = await safeUrlCheck(Uri.parse(url));
                  if (isSafe) {
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      showSnackBar(
                          title: 'Cannot launch the url',
                          context: context,
                          type: SnackType.info);
                    }
                  } else {
                    showSnackBar(
                        title: 'The url is not safe',
                        context: context,
                        type: SnackType.error);
                  }
                },
                child: const Text('Validate URL'))
          ],
        ),
      ),
    );
  }
}
