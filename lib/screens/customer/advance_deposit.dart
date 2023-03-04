import 'package:flutter/material.dart';

class AdvanceDepositPage extends StatefulWidget {
  const AdvanceDepositPage({Key? key}) : super(key: key);

  @override
  State<AdvanceDepositPage> createState() => _AdvanceDepositPageState();
}

class _AdvanceDepositPageState extends State<AdvanceDepositPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Advance'),
        ),
      ),
    );
  }
}
