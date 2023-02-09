import 'package:flutter/material.dart';
import 'dart:async';

//import OneSignal
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const OneSignalOfficial());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => const MaterialApp(
//         home: OneSignalOfficial(),
//       );
// }

class OneSignalOfficial extends StatefulWidget {
  const OneSignalOfficial({Key? key}) : super(key: key);

  @override
  State<OneSignalOfficial> createState() => _OneSignalOfficialState();
}

class _OneSignalOfficialState extends State<OneSignalOfficial> {
  String _debugLabelString = "";
  String? _emailAddress;
  String? _smsNumber;
  String? _externalUserId;
  String? _language;
  bool _enableConsentButton = false;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  final bool _requireConsent = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugPrint('NOTIFICATION OPENED HANDLER CALLED WITH: $result');
      setState(() {
        _debugLabelString =
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
            (OSNotificationReceivedEvent event) {
          debugPrint('FOREGROUND HANDLER CALLED WITH: $event');

          /// Display Notification, send null to not display
          event.complete(null);

          setState(() {
            _debugLabelString =
            "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
          });
        });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      setState(() {
        _debugLabelString =
        "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      debugPrint("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      debugPrint("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
            (OSEmailSubscriptionStateChanges changes) {
          debugPrint(
              "EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
        });

    OneSignal.shared
        .setSMSSubscriptionObserver((OSSMSSubscriptionStateChanges changes) {
      debugPrint(
          "SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {
      debugPrint("ON WILL DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
      debugPrint("ON DID DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnWillDismissInAppMessageHandler((message) {
      debugPrint("ON WILL DISMISS IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDismissInAppMessageHandler((message) {
      debugPrint("ON DID DISMISS IN APP MESSAGE ${message.messageId}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    // await OneSignal.shared.setAppId("380dc082-5231-4cc2-ab51-a03da5a0e4c2");
    await OneSignal.shared.setAppId("d7509317-3652-4ff2-aea7-6db90d693a51");

    // iOS-only method to open launch URLs in Safari when set to false
    OneSignal.shared.setLaunchURLsInApp(false);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    setState(() {
      _enableConsentButton = requiresConsent;
    });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    oneSignalInAppMessagingTriggerExamples();

    OneSignal.shared.disablePush(false);

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    oneSignalOutcomeEventsExamples();

    bool userProvidedPrivacyConsent =
    await OneSignal.shared.userProvidedPrivacyConsent();
    debugPrint("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
  }

  void _handleGetTags() {
    OneSignal.shared.getTags().then((tags) {
      if (tags == null) return;

      setState((() {
        _debugLabelString = "$tags";
      }));
    }).catchError((error) {
      setState(() {
        _debugLabelString = "$error";
      });
    });
  }

  void _handleSendTags() {
    debugPrint("Sending tags");
    OneSignal.shared.sendTag("test2", "val2").then((response) {
      debugPrint("Successfully sent tags with response: $response");
    }).catchError((error) {
      debugPrint("Encountered an error sending tags: $error");
    });

    debugPrint("Sending tags array");
    var sendTags = {'test': 'value'};
    OneSignal.shared.sendTags(sendTags).then((response) {
      debugPrint("Successfully sent tags with response: $response");
    }).catchError((error) {
      debugPrint("Encountered an error sending tags: $error");
    });
  }

  void _handlePromptForPushPermission() {
    debugPrint("Prompting for Permission");
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });
  }

  void _handleGetDeviceState() async {
    debugPrint("Getting DeviceState");
    OneSignal.shared.getDeviceState().then((deviceState) {
      debugPrint("DeviceState: ${deviceState?.jsonRepresentation()}");
      setState(() {
        _debugLabelString =
            deviceState?.jsonRepresentation() ?? "Device state null";
      });
    });
  }

  void _handleSetEmail() {
    if (_emailAddress == null) return;

    debugPrint("Setting email");

    OneSignal.shared.setEmail(email: _emailAddress!).whenComplete(() {
      debugPrint("Successfully set email");
    }).catchError((error) {
      debugPrint("Failed to set email with error: $error");
    });
  }

  void _handleSetLanguage() {
    if (_language == null) return;

    debugPrint("Setting language");

    OneSignal.shared.setLanguage(_language!).then((response) {
      debugPrint("Successfully set language with response: $response");
    }).catchError((error) {
      debugPrint("Failed to set language with error: $error");
    });
  }

  void _handleLogoutEmail() {
    debugPrint("Logging out of email");

    OneSignal.shared.logoutEmail().then((v) {
      debugPrint("Successfully logged out of email");
    }).catchError((error) {
      debugPrint("Failed to log out of email: $error");
    });
  }

  void _handleSetSMSNumber() {
    if (_smsNumber == null) return;

    debugPrint("Setting SMS Number");

    OneSignal.shared.setSMSNumber(smsNumber: _smsNumber!).then((response) {
      debugPrint("Successfully set SMSNumber with response $response");
    }).catchError((error) {
      debugPrint("Failed to set SMS Number with error: $error");
    });
  }

  void _handleLogoutSMSNumber() {
    debugPrint("Logging out of smsNumber");

    OneSignal.shared.logoutSMSNumber().then((response) {
      debugPrint("Successfully logoutEmail with response $response");
    }).catchError((error) {
      debugPrint("Failed to log out of SMSNumber: $error");
    });
  }

  void _handleConsent() {
    debugPrint("Setting consent to true");
    OneSignal.shared.consentGranted(true);

    debugPrint("Setting state");
    setState(() {
      _enableConsentButton = false;
    });
  }

  void _handleSetLocationShared() {
    debugPrint("Setting location shared to true");
    OneSignal.shared.setLocationShared(true);
  }

  void _handleDeleteTag() {
    debugPrint("Deleting tag");
    OneSignal.shared.deleteTag("test2").then((response) {
      debugPrint("Successfully deleted tags with response $response");
    }).catchError((error) {
      debugPrint("Encountered error deleting tag: $error");
    });

    debugPrint("Deleting tags array");
    OneSignal.shared.deleteTags(['test']).then((response) {
      debugPrint("Successfully sent tags with response: $response");
    }).catchError((error) {
      debugPrint("Encountered an error sending tags: $error");
    });
  }

  void _handleSetExternalUserId() {
    debugPrint("Setting external user ID");
    if (_externalUserId == null) return;

    OneSignal.shared.setExternalUserId(_externalUserId!).then((results) {
      if (results == null) return;

      setState(() {
        _debugLabelString = "External user id set: $results";
      });
    });
  }

  void _handleRemoveExternalUserId() {
    OneSignal.shared.removeExternalUserId().then((results) {
      if (results == null) return;

      setState(() {
        _debugLabelString = "External user id removed: $results";
      });
    });
  }

  void _handleSendNotification() async {
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;

    var imgUrlString =
        "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

    var notification = OSCreateNotification(
        playerIds: [playerId],
        content: "this is a test from OneSignal's Flutter SDK",
        heading: "Test Notification",
        iosAttachments: {"id1": imgUrlString},
        bigPicture: imgUrlString,
        buttons: [
          OSActionButton(text: "test1", id: "id1"),
          OSActionButton(text: "test2", id: "id2")
        ]);

    var response = await OneSignal.shared.postNotification(notification);

    setState(() {
      _debugLabelString = "Sent notification with response: $response";
    });
  }

  void _handleSendSilentNotification() async {
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;

    var notification = OSCreateNotification.silentNotification(
        playerIds: [playerId], additionalData: {'test': 'value'});

    var response = await OneSignal.shared.postNotification(notification);

    setState(() {
      _debugLabelString = "Sent notification with response: $response";
    });
  }

  oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.shared.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, Object> triggers = <String, Object>{};
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.shared.removeTriggerForKey("trigger_2");

    // Get the value for a trigger by its key
    Object? triggerValue =
    await OneSignal.shared.getTriggerValueForKey("trigger_3");
    debugPrint("'trigger_3' key trigger value: ${triggerValue?.toString()}");

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.shared.removeTriggersForKeys(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.shared.pauseInAppMessages(false);
  }

  oneSignalOutcomeEventsExamples() async {
    // Await example for sending outcomes
    outcomeAwaitExample();

    // Send a normal outcome and get a reply with the name of the outcome
    OneSignal.shared.sendOutcome("normal_1");
    OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
      debugPrint(outcomeEvent.jsonRepresentation());
    });

    // Send a unique outcome and get a reply with the name of the outcome
    OneSignal.shared.sendUniqueOutcome("unique_1");
    OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
      debugPrint(outcomeEvent.jsonRepresentation());
    });

    // Send an outcome with a value and get a reply with the name of the outcome
    OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
    OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
      debugPrint(outcomeEvent.jsonRepresentation());
    });
  }

  Future<void> outcomeAwaitExample() async {
    var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
    debugPrint(outcomeEvent.jsonRepresentation());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OneSignal Flutter Demo'),
          backgroundColor: const Color.fromARGB(255, 212, 86, 83),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Table(
              children: [
                TableRow(
                  children: [
                    OneSignalButton(
                      "Get Tags",
                      _handleGetTags,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Send Tags",
                      _handleSendTags,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Prompt for Push Permission",
                      _handlePromptForPushPermission,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "debugPrint Device State",
                      _handleGetDeviceState,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "Email Address",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 212, 86, 83),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _emailAddress = text == "" ? null : text;
                        });
                      },
                    )
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 8.0),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Set Email",
                      _handleSetEmail,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Logout Email",
                      _handleLogoutEmail,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "SMS Number",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 212, 86, 83),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _smsNumber = text == "" ? null : text;
                        });
                      },
                    )
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 8.0),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Set SMS Number",
                      _handleSetSMSNumber,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Logout SMS Number",
                      _handleLogoutSMSNumber,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Provide GDPR Consent",
                      _handleConsent,
                      _enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Set Location Shared",
                      _handleSetLocationShared,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Delete Tag",
                      _handleDeleteTag,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Post Notification",
                      _handleSendNotification,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Post Silent Notification",
                      _handleSendSilentNotification,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "External User ID",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 212, 86, 83),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _externalUserId = text == "" ? null : text;
                        });
                      },
                    )
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 8.0),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Set External User ID",
                      _handleSetExternalUserId,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Remove External User ID",
                      _handleRemoveExternalUserId,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          hintText: "Language",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 212, 86, 83),
                          )),
                      onChanged: (text) {
                        setState(() {
                          _language = text == "" ? null : text;
                        });
                      },
                    )
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 8.0),
                  ],
                ),
                TableRow(
                  children: [
                    OneSignalButton(
                      "Set Language",
                      _handleSetLanguage,
                      !_enableConsentButton,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(_debugLabelString),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef OnButtonPressed = void Function();

class OneSignalButton extends StatefulWidget {
  final String title;
  final OnButtonPressed onPressed;
  final bool enabled;

  const OneSignalButton(this.title, this.onPressed, this.enabled, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OneSignalButtonState();
}

class OneSignalButtonState extends State<OneSignalButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Table(
      children: [
        TableRow(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 212, 86, 83),
                disabledBackgroundColor: const Color.fromARGB(180, 212, 86, 83),
                padding: const EdgeInsets.all(8.0),
              ),
              onPressed: widget.enabled ? widget.onPressed : null,
              child: Text(widget.title),
            )
          ],
        ),
        const TableRow(
          children: [
            SizedBox(height: 8.0),
          ],
        ),
      ],
    );
  }
}
