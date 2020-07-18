import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:input_sheet/components/IpsCard.dart';
import 'package:input_sheet/components/IpsError.dart';
import 'package:input_sheet/components/IpsIcon.dart';
import 'package:input_sheet/components/IpsLabel.dart';
import 'package:input_sheet/components/IpsValue.dart';
import 'package:input_sheet/input_sheet.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:taamin/components/loading_widget.dart';
import 'package:taamin/components/offer_widget.dart';
import 'package:taamin/constants/styles.dart';
import 'package:taamin/constants/toast.dart';
import 'package:taamin/models/offer.dart';
import 'package:taamin/repository/info_repository.dart';
import 'package:taamin/repository/user_repository.dart';
import 'package:taamin/routes.dart';
import 'package:taamin/services/database_service.dart';

class ProviderPage extends StatefulWidget {
  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  final Map<String, String> _parents = {
    '0': 'Saham Assurance',
    '1': 'Wafa Assurance',
    '2': 'RMA',
    '3': 'Axa Assurance Maroc',
    '4': 'Atlanta',
    '5 ': 'Sanad',
    '6': 'Allianz Assurance Maroc',
    '7': 'MAMDA',
    '8': 'CAT',
    '9': 'MCMA',
    '10': 'Saham Assistance',
    '11': 'Maroc Assistance',
    '12': 'MATU',
    '13': 'Wafa IMA Assistance',
    '14': 'Euler Hermes ACMAR',
    '15': 'Axa Assistance Maroc',
    '16': 'Marocaine Vie',
    '17': 'Coface Maroc',
  };

  Future<List<Offer>> _offers;

  getFavorite() async {
    _offers = DatabaseService.getUserFavorites(
        Provider.of<InfoRepository>(context, listen: false).offers,
        Provider.of<UserRepository>(context, listen: false).user.uid);
  }

  @override
  void initState() {
    getFavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserRepository>(context, listen: false).user.uid;
    return Consumer<InfoRepository>(
      builder: (context, info, child) {
        return info.provider
            ? Container(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Routes.sailor.navigate('/offer', params: {
                          'uid': Provider.of<UserRepository>(context,
                                  listen: false)
                              .user
                              .uid,
                          'info': info,
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.2),
                        padding: EdgeInsets.all(12),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Ajouter une offre',
                          style: buttonFont,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Text("Appuyez pour modifier ou supprimer",
                          textAlign: TextAlign.center, style: offerTitleFont),
                    ),
                    FutureBuilder(
                        future: _offers,
                        builder: (context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? Container(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: Stack(children: <Widget>[
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                                onTap: () => Routes.sailor
                                                        .navigate('/offer',
                                                            params: {
                                                          'offer': snapshot
                                                              .data[index],
                                                        }),
                                                child: OfferWidget(
                                                    snapshot.data[index]))),
                                  ]))
                              : LoadingWidget();
                        }),
                  ]),
                ))
            : LoadingOverlay(
                isLoading: info.state == InfoState.Changing,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(12),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(24),
                      child: Text(
                          "Vous devez d'abord soumettre une demande , remplissez les espaces puis appuyez sur 'Terminer'",
                          textAlign: TextAlign.center,
                          style: offerTitleFont),
                    ),
                    IpsCard(
                      label: IpsLabel("Nom d'agence"),
                      value: IpsValue(
                          info.agencyName ?? "Appuyez pour modifier..."),
                      icon: IpsIcon(FeatherIcons.user),
                      error: IpsError(
                          info.agencyName == null || info.agencyName.isEmpty
                              ? 'Nom est vide'
                              : ''),
                      onClick: () => InputSheet(
                        context,
                        label: "Nom d'agence",
                        cancelText: "Annuler",
                        doneText: "Confirmer",
                      ).text(
                          placeholder: "Écrivez ici...",
                          value: info.agencyName,
                          onDone: (String value) {
                            value.isNotEmpty
                                ? info.changeAgencyName(value, uid)
                                : DoNothingAction();
                          }),
                    ),
                    SizedBox(height: 12),
                    IpsCard(
                      label: IpsLabel("parent de l'entreprise"),
                      value: IpsValue(
                          info.agencyParent ?? "Appuyez pour modifier..."),
                      icon: IpsIcon(FeatherIcons.menu),
                      error: IpsError(info.agencyParent == null
                          ? "Choisissez parent de l'entreprise"
                          : ''),
                      onClick: () => InputSheet(
                        context,
                        label: "Choisissez parent de l'entreprise",
                        cancelText: "Annuler",
                        doneText: "Confirmer",
                      ).options(
                        value: info.agencyParent,
                        options: _parents,
                        onDone: (String value) {
                          info.changeAgencyParent(_parents[value], uid);
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    IpsCard(
                      label: IpsLabel("Adresse et ville de l'agence"),
                      value: IpsValue(
                          info.agencyAddress ?? "Appuyez pour modifier..."),
                      icon: IpsIcon(FeatherIcons.home),
                      error: IpsError(info.agencyAddress == null ||
                              info.agencyAddress.isEmpty
                          ? 'Adresse est vide'
                          : ''),
                      onClick: () => InputSheet(
                        context,
                        label: "Adresse et ville de l'agence",
                        cancelText: "Annuler",
                        doneText: "Confirmer",
                      ).text(
                        placeholder: "Écrivez ici...",
                        value: info.agencyAddress,
                        onDone: (String value) {
                          value.isNotEmpty
                              ? info.changeAgencyAddress(value, uid)
                              : DoNothingAction();
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        info.agencyAddress != null &&
                                info.agencyName != null &&
                                info.agencyParent != null
                            ? info.request(uid)
                            : DoNothingAction();
                            toast('la demande est envoyée');
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.2),
                        padding: EdgeInsets.all(12),
                        color: info.agencyAddress != null &&
                                info.agencyName != null &&
                                info.agencyParent != null
                            ? Theme.of(context).primaryColor
                            : Colors.grey[400],
                        child: Text(
                          'Terminer',
                          style: buttonFont,
                        ),
                        alignment: Alignment.center,
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}
