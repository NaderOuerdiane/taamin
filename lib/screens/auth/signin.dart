import 'package:flutter/material.dart';
import 'package:taamin/components/loading_widget.dart';
import 'package:taamin/constants/scroll_behaviour.dart';
import 'package:provider/provider.dart';
import 'package:taamin/constants/toast.dart';
import 'package:taamin/repository/user_repository.dart';
import 'package:taamin/repository/authpage_repository.dart';
import 'package:taamin/constants/styles.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

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
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor)),
              padding: EdgeInsets.only(left: 6),
              alignment: Alignment.center,
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
                validator: (value) => value.isEmpty ? 'email est vide' : null,
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
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor)),
              padding: EdgeInsets.only(left: 6),
              alignment: Alignment.center,
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
                    suffixIcon:
                        GestureDetector(child: Icon(Icons.remove_red_eye)),
                    border: InputBorder.none,
                    counterText: '',
                    hintText: 'mot de passe',
                    hintStyle: form1Font),
                validator: (value) =>
                    value.isEmpty ? 'mot de passe est vide' : null,
                onSaved: (value) => _password = value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleLogin(double height, UserRepository user) {
    return InkWell(
        onTap: () async {
          await user.signInUsingGoogle();
        },
        child: SizedBox(
          height: height * 0.08,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  width: height * 0.08,
                  alignment: Alignment.center,
                  color: Color(0xFFcb4438),
                  child: Image.asset(
                    'assets/images/googlelogo.png',
                    color: Theme.of(context).accentColor,
                    height: (height * 0.08) * 0.4,
                  )),
              Flexible(
                child: Container(
                  color: Color(0xFFcb4438).withOpacity(0.8),
                  padding: EdgeInsets.only(left: 6),
                  alignment: Alignment.centerLeft,
                  child: Text('Connecter avec Google', style: buttonFont),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _facebookLogin(double height, UserRepository user) {
    return InkWell(
        onTap: () async {
          await user.signInUsingFacebook();
        },
        child: SizedBox(
          height: height * 0.08,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  width: height * 0.08,
                  alignment: Alignment.center,
                  color: Color(0xFF2d53a0),
                  child: Image.asset(
                    'assets/images/facebooklogo.png',
                    color: Theme.of(context).accentColor,
                    height: (height * 0.08) * 0.5,
                  )),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 6),
                  alignment: Alignment.centerLeft,
                  color: Color(0xFF2d53a0).withOpacity(0.8),
                  child: Text('Connecter avec Facebook', style: buttonFont),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _login(double height, UserRepository user) {
    return Builder(
      builder: (context) => InkWell(
          onTap: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              if (await user.signIn(_email, _password)) {
                toast('connexion réussie');
              } else {
                toast('mauvais e-mail / mot de passe');
              }
            }
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
                    child: Text('Continuer', style: buttonFont),
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
          )),
    );
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
                        top: height * 0.05, bottom: height * 0.05),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: height * 0.1,
                      color: Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text(
                      'Se connecter',
                      style: headlineAuthFont,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      "Salut ! C'est un plaisir de vous revoir",
                      style: subHeadlineAuthFont,
                    ),
                  ),
                  _emailForm(height),
                  SizedBox(height: height * 0.01),
                  _passwordForm(height),
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Vous n'avez pas encore de compte?  ",
                            style: subHeadlineAuthFont,
                          ),
                          GestureDetector(
                              onTap: () => auth.changeToSignUp(),
                              child: Text("S'INSCRIRE!", style: changeFont)),
                        ]),
                  ),
                  if (user.status == Status.Authenticating)
                    LoadingWidget()
                  else ...[
                    _login(height, user),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 24, bottom: 12),
                      child: Text(
                        "Ou utilisez l'un de vos profils sociaux",
                        style: subHeadlineAuthFont,
                      ),
                    ),
                    _googleLogin(height, user),
                    SizedBox(height: height * 0.01),
                    _facebookLogin(height, user),
                    SizedBox(height: height * 0.01),
                  ],
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
    super.dispose();
  }
}
