import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:input_sheet/components/IpsCard.dart';
import 'package:input_sheet/components/IpsError.dart';
import 'package:input_sheet/components/IpsIcon.dart';
import 'package:input_sheet/components/IpsLabel.dart';
import 'package:input_sheet/components/IpsPhoto.dart';
import 'package:input_sheet/components/IpsValue.dart';
import 'package:input_sheet/input_sheet.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:taamin/repository/info_repository.dart';
import 'package:taamin/repository/user_repository.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, String> _languages = {
    "0": "Francais",
    "1": "Arabe",
  };

  File _photo;

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserRepository>(context, listen: false).user.uid;
    return Consumer<InfoRepository>(
      builder: (context, info, child) {
        return LoadingOverlay(
          isLoading: info.state == InfoState.Changing,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(6),
            children: <Widget>[
              IpsCard(
                label: IpsLabel("Nom et Prenom"),
                value: IpsValue(info.name ?? "Appuyez pour modifier..."),
                icon: IpsIcon(FeatherIcons.user),
                error: IpsError(info.name == null || info.name.isEmpty
                    ? 'Nom est vide'
                    : ''),
                onClick: () => InputSheet(
                  context,
                  label: "Nom et Prenom",
                  cancelText: "Annuler",
                  doneText: "Confirmer",
                ).text(
                    placeholder: "Écrivez ici...",
                    value: info.name,
                    onDone: (String value) {
                      value.isNotEmpty
                          ? info.changeName(value, uid)
                          : DoNothingAction();
                    }),
              ),
              SizedBox(height: 12),
              IpsCard(
                label: IpsLabel("Votre langue préférée"),
                value: IpsValue(info.language ?? "Appuyez pour modifier..."),
                icon: IpsIcon(FeatherIcons.menu),
                error: IpsError(''),
                onClick: () => InputSheet(
                  context,
                  label: "Choisissez une langue",
                  cancelText: "Annuler",
                  doneText: "Confirmer",
                ).options(
                  value: info.language,
                  options: _languages,
                  onDone: (String value) {
                    info.changeLanguage(_languages[value], uid);
                  },
                ),
              ),
              SizedBox(height: 12),
              IpsCard(
                label: IpsLabel("Date de naissance"),
                value: IpsValue(info.birth ?? "Appuyez pour modifier..."),
                icon: IpsIcon(FeatherIcons.calendar),
                error: IpsError(
                    info.birth == null ? 'Date de naissance est vide' : ''),
                onClick: () => InputSheet(
                  context,
                  label: "Choisissez une date",
                  cancelText: "Annuler",
                  doneText: "Confirmer",
                ).date(
                  value: info.birth,
                  minDateTime:
                      DateTime.now().subtract(Duration(days: 365 * 100)),
                  maxDateTime:
                      DateTime.fromMillisecondsSinceEpoch(1577833100 * 1000),
                  format: "yyyy/MM/dd",
                  pickerFormat: "yyyy|MMMM|dd",
                  onDone: (String value) {
                    info.changeBirth(value, uid);
                  },
                ),
              ),
              SizedBox(height: 12),
              IpsCard(
                label: IpsLabel("Ville"),
                value: IpsValue(info.city ?? "Appuyez pour modifier..."),
                icon: IpsIcon(FeatherIcons.home),
                error: IpsError(info.city == null || info.city.isEmpty
                    ? 'Ville est vide'
                    : ''),
                onClick: () => InputSheet(
                  context,
                  label: "Ville",
                  cancelText: "Annuler",
                  doneText: "Confirmer",
                ).text(
                  placeholder: "Écrivez ici...",
                  value: info.city,
                  onDone: (String value) {
                    value.isNotEmpty
                        ? info.changeCity(value, uid)
                        : DoNothingAction();
                  },
                ),
              ),
              SizedBox(height: 12),
              info.image != null
                  ? Image.network(
                      info.image,
                    )
                  : Container(
                      alignment: Alignment.center,
                      height: 250,
                      child: IpsPhoto(
                        file: _photo,
                        onClick: () => InputSheet(
                          context,
                          cancelText: "Cancel",
                          doneText: "Confirm",
                        ).photo(
                          file: _photo,
                          onDone: (File file, Uint8List thumbnail) {
                            info.changeImage(file, uid);
                            _photo = file;
                          },
                        ),
                      ),
                    ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
