import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  Color currentColor = Colors.black;

  Future<void> _saveSignature() async {
    ui.Image image = await signaturePadKey.currentState!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? uint8List = byteData?.buffer.asUint8List();

    // Convert Uint8List to Blob
    final blob = html.Blob([uint8List]);

    // Create an object URL
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create a link element and simulate a click
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'signature.png'
      ..click();

    // Revoke the object URL to free up resources
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 220, 220, 220),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sign Your Commitment",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "By signing below, you acknowledge and commit to abide by the terms and conditions of our agreement. This is a placeholder for more information about the commitment that the user is making. It can include additional details or specific points that the user needs to agree upon.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[400]!,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SfSignaturePad(
                            key: signaturePadKey,
                            minimumStrokeWidth: 3,
                            maximumStrokeWidth: 5,
                            strokeColor: currentColor,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        height: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildColorButtons(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const ui.Color.fromARGB(255, 120, 91, 99),
                        ),
                        onPressed: _saveSignature,
                        child: const Text('Save Signature'),
                      ),
                      _buildResetButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _colorButton(Colors.brown),
        _colorButton(Colors.grey[600]!),
        _colorButton(Colors.blueGrey),
        _colorButton(const ui.Color.fromARGB(255, 182, 189, 130)),
      ],
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: () {
        signaturePadKey.currentState?.clear();
      },
      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey,
                        ),
                       
                        child: const Text('Reset'),
      
    );
  }

  Widget _colorButton(Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentColor = color;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(14),
      ),
      child: Container(),
    );
  }
}

final GlobalKey<SfSignaturePadState> signaturePadKey =
    GlobalKey<SfSignaturePadState>();
