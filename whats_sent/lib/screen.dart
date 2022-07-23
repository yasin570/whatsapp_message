import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final TextEditingController _send = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  dynamic _number;
  bool? value;
  String? _pnumber;

  @override
  void initState() {
    super.initState();
    _pnumber = _send.text;
    _number = " ";
  }

  @override
  Widget build(BuildContext context) {
    final iskeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return WillPopScope(
      onWillPop: () {
        Future.delayed(const Duration(milliseconds: 1000), () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        return null!; // null!;
      },
      child: Scaffold(
        //backgroundColor: Colors,
        appBar: AppBar(
          title: const Text("Message"),
        ),
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                //colorFilter: ColorFilter.mode(Colors.black.withOpacity(10.0), BlendMode.dstATop),
                image: NetworkImage(
                    "https://cdn.pixabay.com/photo/2016/06/02/02/33/triangles-1430105__480.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: 350,
                        child: Form(
                          key: formKey,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    print("${number}");
                                    _number = number;
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                    value = value;
                                  },
                                  selectorConfig: const SelectorConfig(
                                    selectorType:
                                        PhoneInputSelectorType.BOTTOM_SHEET,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle:
                                      const TextStyle(color: Colors.black),
                                  initialValue: number,
                                  textFieldController: controller,
                                  formatInput: false,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputBorder: const OutlineInputBorder(),
                                  hintText: "Enter the number",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // dividerWidget(),
                writing(messageController: _messageController),
                IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      size: 50,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_number.toString().length >= 8) {
                          sendWhats();
                          _messageController.clear();
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Error"),
                              content: const Text(
                                  "Number is missing, please check the number!!"),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text("Ok"),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    }),

                //Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendWhats() async {
    final link = WhatsAppUnilink(
      phoneNumber: _number.toString(),
      text: _messageController.text,
    );
    await launch('$link');
  }
}

class writing extends StatelessWidget {
  const writing({
    Key? key,
    required TextEditingController messageController,
  })  : _messageController = messageController,
        super(key: key);

  final TextEditingController _messageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: TextField(
        controller: _messageController,
        style: TextStyle(color: Colors.black),
        maxLength: 200,
        keyboardType: TextInputType.text,
        maxLines: 10,
        decoration: InputDecoration(
          filled: true,
          hintText: "Message. optional!",
          fillColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
