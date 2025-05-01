import 'package:flutter/material.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({super.key});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  String fullText = "Bu kafamdaki tümörleri durduramıyorum! Onları kesmem lazım";
  String visibleText = "";
  int index = 0;

  @override
  void initState() {
    super.initState();
    animateText();
  }

  void animateText() async {
    while (index < fullText.length) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        visibleText += fullText[index];
        index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset("assets/images/char_face.png",width: 70,height: 70,),
            Text(
              visibleText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
