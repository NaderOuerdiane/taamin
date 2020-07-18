import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:taamin/components/loading_widget.dart';
import 'package:taamin/constants/styles.dart';
import 'package:taamin/repository/info_repository.dart';
import 'package:taamin/repository/pages_repository.dart';
import 'package:provider/provider.dart';
import 'package:taamin/repository/user_repository.dart';
import 'package:taamin/services/database_service.dart';
import 'home.dart';
import 'profile.dart';
import 'offers.dart';
import 'provider.dart';

class Pages extends StatefulWidget {
  final String uid;
  final String email;
  Pages(this.uid,this.email);
  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  bool _loading = true;

  getInfo() async {
    try {
      await DatabaseService.initial(widget.uid, widget.email);
      final user = await Provider.of<InfoRepository>(context, listen: false)
          .getInfo(widget.uid);
      print(user);
      setState(() {
        _loading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double width = MediaQuery.of(context).size.width;
    final pages = Provider.of<PagesRepository>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: _loading
          ? LoadingWidget()
          : Stack(children: <Widget>[
              Container(
                width: width,
                margin: EdgeInsets.only(
                    top: 36 +
                        MediaQuery.of(context).padding.top +
                        height * 0.05),
                child: pages.page == PagesSelect.Home
                    ? HomePage()
                    : pages.page == PagesSelect.Offers
                        ? OffersPage()
                        : pages.page == PagesSelect.Profile
                            ? ProfilePage()
                            : pages.page == PagesSelect.Provider
                                ? ProviderPage()
                                : HomePage(),
              ),
              Positioned(
                top: 26 + MediaQuery.of(context).padding.top,
                left: width * 0.3,
                child: InkWell(
                    onTap: () => pages.changeTab(),
                    child: Text(
                      pages.page == PagesSelect.Home
                          ? 'Home'
                          : pages.page == PagesSelect.Offers
                              ? 'Offers'
                              : pages.page == PagesSelect.Profile
                                  ? 'Profile'
                                  : pages.page == PagesSelect.Provider
                                      ? 'Provider'
                                      : 'Home',
                      style: pagesFont,
                    )),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: InkWell(
                    onTap: () => pages.changeTab(),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          top: 24 + MediaQuery.of(context).padding.top,
                          left: 24,
                          right: 12,
                          bottom: 12),
                      child: Image.asset(
                        'assets/images/tab.png',
                        color: Theme.of(context).primaryColor,
                        height: height * 0.05,
                      ),
                    )),
              ),
              AnimatedContainer(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    pages.tab
                        ? BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 10,
                            blurRadius: 50)
                        : BoxShadow(color: Colors.white)
                  ]),
                  margin:
                      EdgeInsets.only(right: pages.tab ? width * 0.4 : width),
                  duration: Duration(milliseconds: 200),
                  width: width * 0.6,
                  height: double.infinity,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: pages.page == PagesSelect.Profile
                            ? height * 0.40
                            : pages.page == PagesSelect.Offers
                                ? height * 0.47
                                : pages.page == PagesSelect.Home
                                    ? height * 0.54
                                    : pages.page == PagesSelect.Provider
                                        ? height * 0.61
                                        : height * 0.4,
                        child: Container(
                          height: height * 0.07,
                          width: width * 0.6,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                        )),
                    AlignPositioned(
                      alignment: Alignment.center,
                      dy: -height * 0.25,
                      childWidth: width * 0.6,
                      child: Consumer2(builder: (context, UserRepository user,
                          InfoRepository info, child) {
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.grey[400],
                                  child: info.image == null ||
                                          info.state == InfoState.Changing
                                      ? Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        )
                                      : Image.network(
                                          info.image,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                info.name ?? 'N/A',
                                style: info.name != null
                                    ? tabTitleFont
                                    : tabTitle2Font,
                                maxLines: 1,
                              ),
                              Text(
                                user.user.email,
                                style: tabSubFont,
                                maxLines: 1,
                              ),
                            ]);
                      }),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: InkWell(
                          onTap: () => pages.changeTab(),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                top: 24 + MediaQuery.of(context).padding.top,
                                left: 24,
                                right: 12,
                                bottom: 12),
                            child: Image.asset(
                              'assets/images/back.png',
                              color: Theme.of(context).primaryColor,
                              height: height * 0.05,
                            ),
                          )),
                    ),
                    Positioned(
                      left: 6,
                      top: height * 0.4,
                      height: height * 0.07,
                      width: width * 0.5,
                      child: InkWell(
                        onTap: () {
                          pages.changePage(0);
                          pages.changeTab();
                        },
                        child: SizedBox(
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.person,
                              color: pages.page == PagesSelect.Profile
                                  ? Theme.of(context).primaryColor
                                  : Color(0xFFd2dae2),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Profile',
                              style: tabFont,
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 6,
                      top: height * 0.47,
                      height: height * 0.07,
                      width: width * 0.5,
                      child: InkWell(
                        onTap: () {
                          pages.changePage(1);
                          pages.changeTab();
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.insert_chart,
                            color: pages.page == PagesSelect.Offers
                                ? Theme.of(context).primaryColor
                                : Color(0xFFd2dae2),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Mes Offres',
                            style: tabFont,
                          ),
                        ]),
                      ),
                    ),
                    Positioned(
                      left: 6,
                      top: height * 0.54,
                      height: height * 0.07,
                      width: width * 0.5,
                      child: InkWell(
                        onTap: () {
                          pages.changePage(2);
                          pages.changeTab();
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.home,
                            color: pages.page == PagesSelect.Home
                                ? Theme.of(context).primaryColor
                                : Color(0xFFd2dae2),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Acceuil',
                            style: tabFont,
                          ),
                        ]),
                      ),
                    ),
                    Positioned(
                      left: 6,
                      top: height * 0.61,
                      height: height * 0.07,
                      width: width * 0.5,
                      child: InkWell(
                        onTap: () {
                          pages.changePage(3);
                          pages.changeTab();
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.add_circle,
                            color: pages.page == PagesSelect.Provider
                                ? Theme.of(context).primaryColor
                                : Color(0xFFd2dae2),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Provider',
                            style: tabFont,
                          ),
                        ]),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      bottom: 12,
                      width: width * 0.5,
                      child: FlatButton(
                        onPressed: () {
                          Provider.of<UserRepository>(context, listen: false)
                              .signOut();
                        },
                        child: Text(
                          'deconnexion',
                          style: tabFont,
                        ),
                      ),
                    ),
                  ])),
            ]),
    );
  }
}
