// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mubashir/components/constants.dart';

class CallEmergencyPage extends StatefulWidget {
  @override
  State<CallEmergencyPage> createState() => _CallEmergencyPageState();
}

class _CallEmergencyPageState extends State<CallEmergencyPage> {
  String policeEmail = 'mubashir725909@gmail.com';
  String policePhoneNumber = '+923305865149';
  String rescueEmail = 'mubashir725909@gmail.com';
  String rescuePhoneNumber = '+923325040399';
  String trafficPoliceEmail = 'mubashir725909@gmail.com';
  String trafficPolicePhoneNumber = '+923475354298';

  Future sendEmail(String recipientEmail) async {
    final Email email = Email(
      body: 'Hy',
      subject: 'Enter Subject',
      recipients: [recipientEmail],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.whiteColor,
            )),
        elevation: 0,
        title: Text(
          "Call Emergency",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              function1('Police', policeEmail, policePhoneNumber),
              function1('Rescue', rescueEmail, rescuePhoneNumber),
              function1('Traffic Police', trafficPoliceEmail,
                  trafficPolicePhoneNumber),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget function1(String name, String email, String phoneNumber) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      height: 65,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        shadowColor: Colors.black54,
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 7),
            title: Text(
              name.toString(),
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () async {
                        sendEmail(email.toString());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.email_outlined,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: '      '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () async {
                        await FlutterPhoneDirectCaller.callNumber(
                            phoneNumber.toString());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.call,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
