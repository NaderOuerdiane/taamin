import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:input_sheet/components/IpsCard.dart';
import 'package:input_sheet/components/IpsError.dart';
import 'package:input_sheet/components/IpsIcon.dart';
import 'package:input_sheet/components/IpsLabel.dart';
import 'package:input_sheet/components/IpsValue.dart';
import 'package:input_sheet/input_sheet.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sailor/sailor.dart';
import 'package:taamin/constants/styles.dart';
import 'package:taamin/models/offer.dart';
import 'package:taamin/repository/info_repository.dart';
import 'package:taamin/services/database_service.dart';

class OfferPage extends StatefulWidget {
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  bool _loading = false;
  String _description;
  String _birth;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final Offer offer = Sailor.param(context, 'offer');
    final String uid = Sailor.param(context, 'uid');
    final InfoRepository info = Sailor.param(context, 'info');
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _loading,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
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
            ListView(shrinkWrap: true, padding: EdgeInsets.all(12), children: <
                Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Text(
                    "tout ajout / modification prendra un certain temps pour prendre effet",
                    textAlign: TextAlign.center,
                    style: offerTitleFont),
              ),
              SizedBox(height: height * 0.1),
              IpsCard(
                label: IpsLabel("Description"),
                value: IpsValue(_description ??
                    offer.description ??
                    "Appuyez pour modifier..."),
                icon: IpsIcon(FeatherIcons.info),
                error:
                    IpsError(_description == '' ? 'Description est vide' : ''),
                onClick: () => InputSheet(
                  context,
                  label: "Description",
                  cancelText: "Annuler",
                  doneText: "Confirmer",
                ).text(
                    placeholder: "Écrivez ici...",
                    value: _description ?? offer.description,
                    onDone: (String value) async {
                      setState(() {
                        _loading = true;
                      });
                      _description = value;

                      value.isNotEmpty && offer.description != null
                          ? await DatabaseService.changeOfferDescription(
                              value, offer.id)
                          : DoNothingAction();
                      setState(() {
                        _loading = false;
                      });
                    }),
              ),
              SizedBox(height: 12),
              IpsCard(
                label: IpsLabel("Date d'expiration"),
                value: IpsValue(
                    _birth ?? offer.expiryDate ?? "Appuyez pour modifier..."),
                icon: IpsIcon(FeatherIcons.calendar),
                error: IpsError(_birth == '' ? 'Date est vide' : ''),
                onClick: () => InputSheet(
                  context,
                  label: "Choisissez une date",
                  cancelText: "Annuler",
                  doneText: "Confirmer",
                ).date(
                  value: _birth ?? offer.expiryDate,
                  minDateTime: DateTime.now(),
                  maxDateTime: DateTime.now().add(Duration(days: 365)),
                  format: "yyyy/MM/dd",
                  pickerFormat: "yyyy|MMMM|dd",
                  onDone: (String value) async {
                    setState(() {
                      _loading = true;
                    });
                    _birth = value;
                    offer.description != null
                        ? await DatabaseService.changeOfferDate(value, offer.id)
                        : DoNothingAction();
                    setState(() {
                      _loading = false;
                    });
                  },
                ),
              ),
              SizedBox(height: 12),
              offer.description == null
                  ? GestureDetector(
                      onTap: () async {
                        setState(() {
                          _loading = true;
                        });
                        await DatabaseService.addOffer(
                            uid,
                            info.agencyName,
                            _description,
                            _birth,
                            info.agencyAddress,
                            info.agencyParent);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.2),
                        padding: EdgeInsets.all(12),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Ajouter',
                          style: buttonFont,
                        ),
                        alignment: Alignment.center,
                      ),
                    )
                  : Container(),
            ])
          ]),
        ),
      ),
    );
  }
}
