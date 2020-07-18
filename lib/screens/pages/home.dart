import 'package:flutter/material.dart';
import 'package:taamin/components/loading_widget.dart';
import 'package:taamin/components/offer_widget.dart';
import 'package:taamin/constants/toast.dart';
import 'package:taamin/repository/offers_repository.dart';
import 'package:provider/provider.dart';
import 'package:align_positioned/align_positioned.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  OffersRepository _offers;
  bool _getData = true;
  bool _first = true;

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent -
                  _scrollController.position.pixels <=
              -50 &&
          _getData == true) {
        print('GET MORE MORE');
        _getData = false;
        if (await _offers.getOffers(_offers.list.last.id)) {
          _getData = true;
        } else {
          toast('Nothing to load');
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _offers = Provider.of<OffersRepository>(context);
    print(_offers.list.length.toString() + ' length');
    if (_offers.list.isEmpty && _first) {
      _first = false;
      _offers.getOffers(_offers.list.length);
      return Container(child: LoadingWidget());
    }

    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Stack(children: <Widget>[
        ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _offers.list.length,
            controller: _scrollController,
            itemBuilder: (context, index) => OfferWidget(_offers.list[index])),
        _offers.state == OffersPageState.Loading
            ? AlignPositioned(
                alignment: Alignment.bottomCenter,
                child: Container(height: 50, width: 50, child: LoadingWidget()))
            : Container()
      ]),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
