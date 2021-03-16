import 'package:flutter/material.dart';
import 'package:flutter_login/util/const.dart';
import 'package:flutter_login/util/enum.dart';
import 'package:flutter_login/util/router.dart';
import 'package:flutter_login/util/validations.dart';
import 'package:flutter_login/main_screen.dart';
import 'package:flutter_login/widgets/custom_button.dart';
import 'package:flutter_login/widgets/custom_text_field.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email,
      password,
      name = '';
  FocusNode nameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FormMode formMode = FormMode.LOGIN;

  login() async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      Navigate.pushPageReplacement(context, MainScreen());
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                child: Center(
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: buildFormContainer(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
buildFormContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '${Constants.appName}',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 70.0),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: buildForm(),
        ),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {
                    formMode = FormMode.FORGOT_PASSWORD;
                    setState(() {});
                  },
                  child: Text('Forgot Password?'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        buildButton(),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have an account?'),
              FlatButton(
                onPressed: () {
                  formMode = FormMode.REGISTER;
                  setState(() {});
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
        Visibility(
          visible: formMode != FormMode.LOGIN,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account?'),
              FlatButton(
                onPressed: () {
                  formMode = FormMode.LOGIN;
                  setState(() {});
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ],
    );
}

  buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Name",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateName,
                onSaved: (String val) {
                  name = val;
                },
                focusNode: nameFN,
                nextFocusNode: emailFN,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        CustomTextField(
          enabled: !loading,
          hintText: "Email",
          textInputAction: TextInputAction.next,
          validateFunction: Validations.validateEmail,
          onSaved: (String val) {
            email = val;
          },
          focusNode: emailFN,
          nextFocusNode: passFN,
        ),
        Visibility(
          visible: formMode != FormMode.FORGOT_PASSWORD,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              CustomTextField(
                enabled: !loading,
                hintText: "Password",
                textInputAction: TextInputAction.done,
                validateFunction: Validations.validatePassword,
                submitAction: login,
                obscureText: true,
                onSaved: (String val) {
                  password = val;
                },
                focusNode: passFN,
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildButton() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: "Submit",
            onPressed: () => login(),
          );
  }
}