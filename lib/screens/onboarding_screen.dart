import 'dart:io';
import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sailor/sailor.dart';
import 'package:taamin/constants/styles.dart';
import 'package:taamin/routes.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  setPreferences() async {
    Directory document = await getApplicationDocumentsDirectory();
    File file = File('${document.path}/boarding.txt');
    await file.writeAsString('0');
  }

  @override
  void initState() {
    setPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.7, 0.9],
                colors: [
                  Color(0xFF3594DD),
                  Color(0xFF4563DB),
                  Color(0xFF5036D5),
                  Color(0xFF5B16D0),
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 6,
                    left: 3,
                    child: FlatButton(
                      onPressed: () => Routes.sailor.navigate('/',
                          navigationType: NavigationType.popAndPushNamed),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.1,
                    width: width,
                    height: height * 0.8,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                'assets/images/onboarding0.png',
                                height: height * 0.35,
                              ),
                            ),
                            SizedBox(height: 24.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Obtenez les meilleures formules d'assurance",
                                style: boarding1Font,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Taamin , est un système d'assurance aux enchères, qui vous propose une formule personnalisée au meilleur prix du marché.",
                                style: boarding2Font,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                'assets/images/onboarding1.png',
                                height: height * 0.35,
                              ),
                            ),
                            SizedBox(height: 24.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Un meilleur prix et près\nde chez vous!",
                                style: boarding1Font,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'Taamin vous propose plusieurs offres et réductions de nos agences partenaires dans plusieurs villes au Maroc',
                                style: boarding2Font,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                'assets/images/onboarding2.png',
                                height: height * 0.35,
                              ),
                            ),
                            SizedBox(height: 24.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Une assurance voyage\net stage",
                                style: boarding1Font,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Ce type d'assurance est disponible pour les voyageurs et étudiants, vous pouvez meme payer et recevoir votre assurance en ligne!",
                                style: boarding2Font,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AlignPositioned(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: height * 0.05),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                    ),
                  ),
                  _currentPage != 2
                      ? Positioned(
                          top: 6,
                          right: 3,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(width: 6.0),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Text(''),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: _currentPage == 2 ? height * 0.1 : 0,
          width: double.infinity,
          color: Colors.white,
          child: GestureDetector(
            onTap: () => Routes.sailor
                .navigate('/', navigationType: NavigationType.popAndPushNamed),
            child: Center(
              child: Text(
                'Get started',
                style: TextStyle(
                  color: Color(0xFF5B16D0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ));
  }
}
