import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum PagesSelect { Home, Offers, Provider, Profile }

class PagesRepository with ChangeNotifier {
  PagesSelect _page;
  PagesSelect get page => _page;

  bool _tab;
  bool get tab => _tab;

  PagesRepository.instance() {
    _page = PagesSelect.Home;
    _tab = false;
  }

  changePage(int tab) {
    switch (tab) {
      case 0:
        _page = PagesSelect.Profile;
        break;
      case 1:
        _page = PagesSelect.Offers;
        break;
      case 2:
        _page = PagesSelect.Home;
        break;
      case 3:
        _page = PagesSelect.Provider;
        break;
      default:
        _page = PagesSelect.Home;
        break;
    }
    notifyListeners();
  }

  changeTab() {
    _tab = !_tab;
    notifyListeners();
  }
}
