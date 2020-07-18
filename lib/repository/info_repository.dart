import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:taamin/services/database_service.dart';

enum InfoState { Idle, Changing }

class InfoRepository with ChangeNotifier {
  String _name;
  String _language;
  String _birth;
  String _city;
  String _image;
  bool _provider;
  List<dynamic> _favorite;
  InfoState _state;
  InfoState _favoriteState;
  List<dynamic> _offers;

  String _agencyAddress;
  String _agencyParent;
  String _agencyName;

  String get name => _name;
  String get language => _language;
  String get birth => _birth;
  String get city => _city;
  String get image => _image;
  bool get provider => _provider;
  List<dynamic> get favorite => _favorite;
  InfoState get state => _state;
  InfoState get favoriteState => _favoriteState;
  List<dynamic> get offers => _offers;

  String get agencyAddress => _agencyAddress;
  String get agencyName => _agencyName;
  String get agencyParent => _agencyParent;

  changeName(String value, String uid) async {
    _state = InfoState.Changing;
    notifyListeners();
    await DatabaseService.changeName(value, uid);
    _name = value;
    _state = InfoState.Idle;
    notifyListeners();
  }

  changeLanguage(String value, String uid) async {
    _state = InfoState.Changing;
    notifyListeners();
    await DatabaseService.changeLanguage(value, uid);
    _language = value;
    _state = InfoState.Idle;
    notifyListeners();
  }

  changeBirth(String value, String uid) async {
    _state = InfoState.Changing;
    notifyListeners();
    await DatabaseService.changeBirth(value, uid);
    _birth = value;
    _state = InfoState.Idle;
    notifyListeners();
  }

  changeCity(String value, String uid) async {
    _state = InfoState.Changing;
    notifyListeners();
    await DatabaseService.changeCity(value, uid);
    _city = value;
    _state = InfoState.Idle;
    notifyListeners();
  }

  changeImage(File value, String uid) async {
    _state = InfoState.Changing;
    notifyListeners();
    await DatabaseService.changeImage(value, uid);
    _image = await DatabaseService.getImage(uid);
    _state = InfoState.Idle;
    notifyListeners();
  }

  changeAgencyName(String value, String uid) async {
    _state = InfoState.Changing;
    notifyListeners();
    await DatabaseService.changeAgencyName(value, uid);
    _agencyName = value;
    _state = InfoState.Idle;
    notifyListeners();
  }

  changeAgencyAddress(String value, String uid) async {
    _state = InfoState.Changing;
    notifyListeners();
    await DatabaseService.changeAgencyAddress(value, uid);
    _agencyAddress = value;
    _state = InfoState.Idle;
    notifyListeners();
  }

  changeAgencyParent(String value, String uid) async {
    _state = InfoState.Changing;
    notifyListeners();
    await DatabaseService.changeAgencyParent(value, uid);
    _agencyParent = value;
    _state = InfoState.Idle;
    notifyListeners();
  }

  request(String uid) async {
    _state = InfoState.Changing;
    notifyListeners();
    await DatabaseService.request(
        uid, _agencyName, _agencyAddress, _agencyParent);
    _state = InfoState.Idle;
    notifyListeners();
  }

  InfoRepository.instance() {
    _favorite = [];
    _offers = [];
    _state = InfoState.Idle;
    _favoriteState = InfoState.Idle;
  }

  Future<bool> offerFavorite(int id, String uid) async {
    _favoriteState = InfoState.Changing;
    notifyListeners();
    try {
      if (_favorite.contains(id)) {
        _favorite.remove(id);
        await DatabaseService.removeFavorite(id, uid);
      } else {
        _favorite.add(id);
        await DatabaseService.addFavorite(id, uid);
      }
      _favoriteState = InfoState.Idle;
      notifyListeners();

      return true;
    } catch (err) {
      print('FAVORITE ERROR $err');
      _favoriteState = InfoState.Idle;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getInfo(String uid) async {
    try {
      var result = await DatabaseService.getUserPage(uid);
      _name = result['name'];
      _language = result['language'];
      _birth = result['birth'];
      _city = result['city'];
      _agencyName = result['agency name'];
      _agencyAddress = result['agency address'];
      _agencyParent = result['agency parent'];
      _provider = result['provider'];
      _favorite = result['favorite'];
      _offers = result['offers'];
      _image = await DatabaseService.getImage(uid);

      return true;
    } catch (err) {
      print('GET INFO ERROR $err');
      return false;
    }
  }
}
