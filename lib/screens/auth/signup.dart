import 'package:flutter/material.dart';
import 'package:taamin/components/loading_widget.dart';
import 'package:taamin/constants/scroll_behaviour.dart';
import 'package:taamin/constants/styles.dart';
import 'package:taamin/constants/toast.dart';
import 'package:taamin/repository/user_repository.dart';
import 'package:taamin/repository/authpage_repository.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email;
  String _password;
  final _formKey = GlobalKey<FormState>();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _passwordverifFocusNode = FocusNode();

  Widget _emailForm(double height) {
    return SizedBox(
      height: height * 0.08,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: height * 0.08,
            alignment: Alignment.center,
            color: Theme.of(context).primaryColorDark,
            child: Icon(
              Icons.email,
              color: Theme.of(context).accentColor,
              size: 25,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor)),
              child: TextFormField(
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                style: _emailFocusNode.hasFocus ? form2Font : form3Font,
                cursorWidth: 2,
                cursorRadius: Radius.circular(2),
                maxLength: 40,
                maxLines: 1,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: 'email',
                    hintStyle: form1Font),
                validator: (value) {
                  if (value.isEmpty)
                    return 'email est vide';
                  else if (!RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                      .hasMatch(value))
                    return 'email non valid';
                  else
                    return null;
                },
                onSaved: (value) => _email = value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordForm(double height) {
    return SizedBox(
      height: height * 0.08,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: height * 0.08,
            alignment: Alignment.center,
            color: Theme.of(context).primaryColorDark,
            child: Icon(
              Icons.lock,
              color: Theme.of(context).accentColor,
              size: 25,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor)),
              child: TextFormField(
                focusNode: _passwordFocusNode,
                keyboardType: TextInputType.visiblePassword,
                style: _passwordFocusNode.hasFocus ? form2Font : form3Font,
                cursorWidth: 2,
                obscureText: true,
                cursorRadius: Radius.circular(2),
                maxLength: 40,
                maxLines: 1,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: 'mot de passe',
                    hintStyle: form1Font),
                validator: (value) {
                  _password = value;
                  if (value.length < 6) {
                    return 'mot de passe trop court';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) => _password = value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordConfirmForm(double height) {
    return SizedBox(
      height: height * 0.08,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: height * 0.08,
            alignment: Alignment.center,
            color: Theme.of(context).primaryColorDark,
            child: Icon(
              Icons.lock_outline,
              color: Theme.of(context).accentColor,
              size: 25,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor)),
              child: TextFormField(
                focusNode: _passwordverifFocusNode,
                keyboardType: TextInputType.visiblePassword,
                style: _passwordverifFocusNode.hasFocus ? form2Font : form3Font,
                cursorWidth: 2,
                cursorRadius: Radius.circular(2),
                maxLength: 40,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: 'confirmer mot de passe',
                    hintStyle: form1Font),
                validator: (value) {
                  if (value != _password) {
                    return "mot de passe ne correspond pas";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signup(double height, UserRepository user) {
    return InkWell(
        onTap: () async {
          if (!_formKey.currentState.validate()) {
            return;
          }
          _formKey.currentState.save();
          user.signUp(_email, _password).then((value) {
            if (value) {
              toast("inscription avec succès");
            } else {
              toast('quelque chose a mal tourné');
            }
          });
        },
        child: SizedBox(
          height: height * 0.08,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  child: Text('Commencer', style: buttonFont),
                ),
              ),
              Container(
                width: height * 0.08,
                alignment: Alignment.center,
                color: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        setState(() {});
      }
    });
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {});
      }
    });
    _passwordverifFocusNode.addListener(() {
      if (_passwordverifFocusNode.hasFocus) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthPageRepository>(context, listen: false);
    final user = Provider.of<UserRepository>(context);

    double width = MediaQuery.of(context).size.width;
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(right: width * 0.1, left: width * 0.1),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: height * 0.05, bottom: height * 0.1),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: height * 0.1,
                      color: Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text(
                      "S'inscrire",
                      style: headlineAuthFont,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      "Nouveau ? créer un compte",
                      style: subHeadlineAuthFont,
                    ),
                  ),
                  _emailForm(height),
                  SizedBox(height: height * 0.01),
                  _passwordForm(height),
                  SizedBox(height: height * 0.01),
                  _passwordConfirmForm(height),
                  SizedBox(height: height * 0.01),
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Vous avez déjà un compte?  ",
                            style: subHeadlineAuthFont,
                          ),
                          GestureDetector(
                              onTap: () => auth.changeToSignIn(),
                              child: Text('SE CONNECTER', style: changeFont)),
                        ]),
                  ),
                  if (user.status == Status.Registering)
                    LoadingWidget()
                  else
                    _signup(height, user),
                  SizedBox(height: height * 0.05)
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordverifFocusNode.dispose();
    super.dispose();
  }
}
