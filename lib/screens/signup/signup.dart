import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class SignUp extends StatelessWidget {
  static String route = '/signup';

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    double getFormWidth(context) {
      if (MediaQuery.of(context).size.width > 1200) {
        return MediaQuery.of(context).size.width / 4;
      }
      if (MediaQuery.of(context).size.width > 786) {
        return MediaQuery.of(context).size.width / 3;
      }
      if (MediaQuery.of(context).size.width > 600) {
        return MediaQuery.of(context).size.width / 2;
      }
      return MediaQuery.of(context).size.width;
    }

    Widget _backButton() {
      return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              ),
              Text('Back',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
            ],
          ),
        ),
      );
    }

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (MediaQuery.of(context).size.width < 786)
                Positioned(
                  top: -height * .20,
                  right: -MediaQuery.of(context).size.width * .55,
                  child: BezierContainer(),
                ),
              Positioned(
                top: 155,
                child: Container(
                  width: getFormWidth(context),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: SignUpForm(),
                  ),
                ),
              ),
              Positioned(top: 60, left: 10, child: _backButton()),
            ],
          ),
        ),
      ),
    );
  }
}