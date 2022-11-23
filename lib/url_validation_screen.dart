import 'package:defender/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
                          hintText: 'Enter or paste the url')),
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
                  print('URL: ' + url);
                  if (url.isEmpty) {
                    showSnackBar(
                        title: 'Please enter some text',
                        context: context,
                        type: SnackType.error);
                    return;
                  }
                  if(await safeUrlCheck(Uri.parse(url))){
                    print("url is safe");
                    await launchUrlString(url);
                  // if (await canLaunchUrlString(url)) {
                  //   print("url can be launched");
                  //   //check is url is malicious
                  //   await launchUrlString(url);
                  // }else{
                  //   showSnackBar(
                  //         title: 'URL cannot be launched',
                  //         context: context,
                  //         type: SnackType.error);
                  //     return;
                  // }
                  } else {
                    print("url is not safe");
                    showSnackBar(
                          title: 'URL is malicious',
                          context: context,
                          type: SnackType.error);
                      return;
                  }
                },
                child: const Text('Validate URL'))
          ],
        ),
      ),
    );
  }
}
