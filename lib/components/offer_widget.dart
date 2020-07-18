import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taamin/components/loading_widget.dart';
import 'package:taamin/constants/styles.dart';
import 'package:taamin/models/offer.dart';
import 'package:taamin/repository/info_repository.dart';
import 'package:taamin/repository/user_repository.dart';
import 'package:taamin/services/database_service.dart';

class OfferWidget extends StatefulWidget {
  final Offer offer;
  OfferWidget(this.offer);

  @override
  _OfferWidgetState createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
  Future<String> _image;
  bool _loading = false;

  getImage() {
    _image = DatabaseService.getImage(widget.offer.uid);
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _image,
      builder: (context, snapshot) {
        return Container(
          margin: EdgeInsets.all(6),
          child: ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.grey[400],
                    child: snapshot.connectionState != ConnectionState.done ||
                            snapshot.data == null
                        ? Icon(
                            Icons.person,
                            color: Colors.white,
                          )
                        : Image.network(
                            snapshot.data.toString(),
                            fit: BoxFit.cover,
                          ))),
            title: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: widget.offer.name + '    ', style: offerTitleFont),
                TextSpan(text: widget.offer.expiryDate, style: offerExpiryFont),
              ]),
            ),
            subtitle: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: widget.offer.address + '  |  ', style: offerSubFont),
              TextSpan(text: widget.offer.parent + '\n', style: offerSubFont),
              TextSpan(
                  text: widget.offer.description, style: offerDescriptionFont),
              //TextSpan(text: widget.offer.expireDate),
            ])),
            trailing: Consumer<InfoRepository>(
              builder: (context, info, child) {
                return _loading
                    ? SizedBox(height: 30, width: 30, child: LoadingWidget())
                    : GestureDetector(
                        onTap: () async {
                          if (info.favoriteState == InfoState.Changing) return;
                          setState(() {
                            _loading = true;
                          });
                          await info.offerFavorite(
                            widget.offer.id,
                            Provider.of<UserRepository>(context, listen: false)
                                .user
                                .uid,
                          );
                          setState(() {
                            _loading = false;
                          });
                        },
                        child: Image.asset(
                            info.favorite.contains(widget.offer.id)
                                ? 'assets/images/heart_filled.png'
                                : 'assets/images/heart.png',
                            color: info.favoriteState == InfoState.Idle
                                ? Theme.of(context).primaryColor
                                : Colors.grey[400],
                            height: 30),
                      );
              },
            ),
          ),
        );
      },
    );
  }
}
