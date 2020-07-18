import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taamin/models/offer.dart';

class DatabaseService {
  static final CollectionReference _usersCollection =
      Firestore.instance.collection('users');

  static final CollectionReference _offersCollection =
      Firestore.instance.collection('offers');

  static final CollectionReference _requestsCollection =
      Firestore.instance.collection('requests');

  static Future<bool> initial(String uid, String email) async {
    try {
      var document = await _usersCollection.document(uid).get();
      if (document.data == null) {
        await _usersCollection.document(uid).setData({
          'uid': uid,
          'name': null,
          'email': email,
          'language': 'Francais',
          'city': null,
          'provider': false,
          'birth': null,
          'offers': [],
          'favorite': [],
        });
      }
      return true;
    } catch (err) {
      print('DATABASE INITIAL ERROR $err');
      return false;
    }
  }

  static Future<bool> changeName(String value, String uid) async {
    try {
      await _usersCollection.document(uid).updateData({'name': value});
      return true;
    } catch (err) {
      print('CHANGE NAME ERROR ERROR $err');
      return false;
    }
  }

  static Future<bool> changeLanguage(String value, String uid) async {
    try {
      await _usersCollection.document(uid).updateData({'language': value});
      return true;
    } catch (err) {
      print('CHANGE LANGUAGE ERROR ERROR $err');
      return false;
    }
  }

  static Future<bool> changeCity(String value, String uid) async {
    try {
      await _usersCollection.document(uid).updateData({'city': value});
      return true;
    } catch (err) {
      print('CHANGE CITY ERROR ERROR $err');
      return false;
    }
  }

  static Future<bool> changeBirth(String value, String uid) async {
    try {
      await _usersCollection.document(uid).updateData({'birth': value});
      return true;
    } catch (err) {
      print('CHANGE BIRTH ERROR ERROR $err');
      return false;
    }
  }

  static Future<bool> changeAgencyName(String value, String uid) async {
    try {
      await _usersCollection.document(uid).updateData({'agency name': value});
      return true;
    } catch (err) {
      print('CHANGE AGENCY NAME ERROR $err');
      return false;
    }
  }

  static Future<bool> changeAgencyAddress(String value, String uid) async {
    try {
      await _usersCollection
          .document(uid)
          .updateData({'agency address': value});
      return true;
    } catch (err) {
      print('CHANGE AGENCY ADDRESS ERROR $err');
      return false;
    }
  }

  static Future<bool> changeAgencyParent(String value, String uid) async {
    try {
      await _usersCollection.document(uid).updateData({'agency parent': value});
      return true;
    } catch (err) {
      print('CHANGE AGENCY PARENT ERROR $err');
      return false;
    }
  }

  static Future<bool> request(String uid, String agencyName,
      String agencyAddress, String agencyParent) async {
    try {
      await _requestsCollection.document(uid).setData({
        'agency name': agencyName,
        'agency address': agencyAddress,
        'agency parent': agencyParent
      });
      return true;
    } catch (err) {
      print('REQUEST ERROR $err');
      return false;
    }
  }

  static Future<bool> changeImage(File file, String uid) async {
    try {
      final FirebaseStorage _storage =
          FirebaseStorage(storageBucket: 'gs://taamin-13fa5.appspot.com/');
      StorageTaskSnapshot result = await _storage
          .ref()
          .child('images/$uid.png')
          .putFile(file)
          .onComplete;
      return true;
    } catch (err) {
      print('CHANGE IMAGE ERROR ERROR $err');
      return false;
    }
  }

  static Future<String> getImage(String uid) async {
    try {
      final FirebaseStorage _storage =
          FirebaseStorage(storageBucket: 'gs://taamin-13fa5.appspot.com/');
      String url =
          await _storage.ref().child('images/$uid.png').getDownloadURL();
      return url;
    } catch (err) {
      print('GET IMAGE ERROR ERROR $err');
      return null;
    }
  }

  static Future<Map<String, dynamic>> getUserPage(String uid) async {
    try {
      var result = await _usersCollection.document(uid).get();
      return result.data;
    } catch (err) {
      print('GET USER ORDERS ERROR $err');
      return null;
    }
  }

  static Future<List<Offer>> getFirstOffers() async {
    try {
      Query _query = _offersCollection.orderBy('id').startAfter([0]).limit(10);
      QuerySnapshot _querySnapshot = await _query.getDocuments();
      return _getListFromSnapshot(_querySnapshot);
    } catch (err) {
      print('GET FIRST PRODUCTS ERROR $err');
      return [];
    }
  }

  static Future<List<Offer>> getOffers(int id) async {
    try {
      Query _query = _offersCollection.orderBy('id').startAfter([id]).limit(10);
      QuerySnapshot _querySnapshot = await _query.getDocuments();
      print(_querySnapshot.documents.length);
      return _getListFromSnapshot(_querySnapshot);
    } catch (err) {
      print('ADD OFFERS ERROR $err');
      return [];
    }
  }

  static Future<bool> getUserProvider(String uid) async {
    try {
      var result = await _usersCollection.document(uid).get();
      return result.data['provider'];
    } catch (err) {
      print('ADD OFFERS ERROR $err');
      return false;
    }
  }

  static List<Offer> _getListFromSnapshot(QuerySnapshot querySnapshot) {
    List<Offer> _offersList = [];
    querySnapshot.documents.forEach((document) => _offersList.add(Offer(
        name: document['name'],
        description: document['description'],
        address: document['address'],
        parent: document['parent'],
        uid: document['uid'],
        expiryDate: document['expiry'],
        id: document['id'])));
    return _offersList;
  }

  static Future<List<Offer>> getUserFavorites(
      List<dynamic> favorites, String uid) async {
    try {
      var result = await _offersCollection
          .where('id', whereIn: favorites)
          .getDocuments();
      return _getListFromSnapshot(result);
    } catch (err) {
      print('GET USER FAVORITES ERROR $err');
      return [];
    }
  }

  static Future<bool> addOffer(
      String uid,
      String agencyName,
      String description,
      String expiryDate,
      String agencyAddress,
      String parent) async {
    try {
      var documentSnapshot = await _usersCollection.document(uid).get();
      var documents = await _offersCollection.getDocuments();
      int length = documents.documents.length;

      List<dynamic> list = List.from(documentSnapshot.data['offers']);
      list.add(length + 1);
      await _usersCollection.document(uid).updateData({'offers': list});

      _offersCollection.document((length + 1).toString()).setData({
        'name': agencyName,
        'description': description,
        'address': agencyAddress,
        'parent': parent,
        'id': length + 1,
        'uid': uid,
        'expiry': expiryDate,
      });

      return true;
    } catch (err) {
      print('GET USER DOCUMENT ERROR $err');
      return false;
    }
  }

  static Future<bool> addFavorite(int id, String uid) async {
    try {
      var documentSnapshot = await _usersCollection.document(uid).get();

      List<dynamic> list = List.from(documentSnapshot.data['favorite']);
      list.add(id);

      await _usersCollection.document(uid).updateData({'favorite': list});

      return true;
    } catch (err) {
      print('ADD FAVORITE DOCUMENT ERROR $err');
      return false;
    }
  }

  static Future<bool> removeFavorite(int id, String uid) async {
    try {
      var documentSnapshot = await _usersCollection.document(uid).get();

      List<dynamic> list = List.from(documentSnapshot.data['favorite']);
      list.remove(id);

      await _usersCollection.document(uid).updateData({'favorite': list});

      return true;
    } catch (err) {
      print('REMOVE FAVORITE DOCUMENT ERROR $err');
      return false;
    }
  }

  static Future<bool> changeOfferDescription(String value, int id) async {
    try {
      await _offersCollection
          .document(id.toString())
          .updateData({'description': value});
      return true;
    } catch (err) {
      print('ADD OFFERS ERROR $err');
      return false;
    }
  }

  static Future<bool> changeOfferDate(String value, int id) async {
    try {
      await _offersCollection
          .document(id.toString())
          .updateData({'expiry': value});
      return true;
    } catch (err) {
      print('ADD OFFERS ERROR $err');
      return false;
    }
  }
}
