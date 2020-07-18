import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taamin/services/database_service.dart';
import 'package:taamin/models/offer.dart';

enum OffersPageState { Loading, Idle }

class OffersRepository with ChangeNotifier {
  List<Offer> _offersList;
  OffersPageState _state = OffersPageState.Idle;

  List<Offer> get list => _offersList;
  OffersPageState get state => _state;

  OffersRepository.instance() {
    _offersList = [];
  }

  _setIdle() {
    _state = OffersPageState.Idle;
    notifyListeners();
  }

  _setLoading() {
    _state = OffersPageState.Loading;
    notifyListeners();
  }

  Future<bool> getOffers(int id) async {
    try {
      if (_offersList.isEmpty) {
        _offersList.addAll(await DatabaseService.getFirstOffers());
        notifyListeners();
      } else {
        _setLoading();
        List<Offer> _offersNewList = await DatabaseService.getOffers(id);
        if (_offersNewList.isEmpty) {
          _setIdle();
          return false;
        }
        _offersList.addAll(_offersNewList);
        _setIdle();
      }
      return true;
    } catch (err) {
      _setIdle();
      print('GET OFFERS ERROR $err');
      return false;
    }
  }
}
