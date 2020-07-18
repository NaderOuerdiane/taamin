import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taamin/components/loading_widget.dart';
import 'package:taamin/components/offer_widget.dart';
import 'package:taamin/models/offer.dart';
import 'package:taamin/repository/info_repository.dart';
import 'package:taamin/repository/user_repository.dart';
import 'package:taamin/services/database_service.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  Future<List<Offer>> _favorites;

  getFavorite() async {
    _favorites = DatabaseService.getUserFavorites(
        Provider.of<InfoRepository>(context, listen: false).favorite,
        Provider.of<UserRepository>(context, listen: false).user.uid);
  }

  @override
  void initState() {
    getFavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _favorites,
      builder: (context, snapshot) {
        print(snapshot.data);
      return snapshot.connectionState == ConnectionState.done
          ? Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Stack(children: <Widget>[
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) =>
                        OfferWidget(snapshot.data[index])),
              ]))
          : LoadingWidget();
    });
  }
}
