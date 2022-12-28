import 'dart:async';
// import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:master_app/Provider/Firebase/fire_store.dart';
import 'package:master_app/navegationPage.dart';
import 'package:provider/provider.dart';
// import 'package:sen_assistant/src/Bloc/GlobalBloc.dart';
// import 'package:sen_assistant/src/NavegacionPage.dart';
// import 'package:sen_assistant/src/pages/StepOneToFour/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/bigData.dart';
import '../../main.dart';
import '../LogIn.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  // final bloC = GlobalBloc();

  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  final InAppPurchase _iap = InAppPurchase.instance;

  Map<String, dynamic> productos_ids = {};

  // String del producto seleccionado por el usuario
  late String prod_id;

  /// Products for sale
  List<ProductDetails> _products = [];
  Map<String, dynamic> prods = {
    "6": {'title': 'Semestral', 'Descripcion': 'none', 'price': "8"},
    "12": {'title': 'Anual', 'Descripcion': 'Promo', 'price': "12"},
  };

  /// Past purchases
  final List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  late StreamSubscription _subscription;

  /// Consumable credits the user can buy
  int credits = 0;

  // Producto seleccionado
  late ProductDetails prodSelect;

  // Temp variable
  int seleccion = 1;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Initialize data
  void _initialize() async {
    // Check availability of In App Purchases
    available = await _iap.isAvailable();

    // Bajamos el listado de los productos disponibles para esta app
    productos_ids = await FireStore().bajarDataCloud("Global", "ProductosIds");

    if (available) {
      await _getProducts();
      // await _getPastPurchases("none");

      // Ahora si verificamos si nuestro usuario esta activo o no.
      // if (bloC.pref.membershipDate != "" && bloC.activeMembership() == false)
      //   _spendCredits(_hasPurchased(bloC.pref.prodId));

      // Verify and deliver a purchase with your own business logic
      // _verifyPurchase();
    }
    // Listen to new purchases
    _subscription = _iap.purchaseStream.listen((data) => setState(() {
          print('NEW PURCHASE');
          _purchases.addAll(data);
          _verifyPurchase();
        }));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: TextButton(
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () async {
              // limpiamos la preferencias por si antes tuvo una sesion abierta con otro usuario.
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              // debemos borrar las notificaciones tambien.
              // bloC.localNotification.deleteAllNotification();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const MyApp()));
            }),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      Text('Aceleta tu negocio',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange[800],
                          ),
                          textAlign: TextAlign.center),
                      const Text(
                          'Accede a las herramientas mas poderosas de la industria',
                          style: TextStyle(
                              // fontSize: 35.0,
                              // fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.height * 0.3,
                  width: media.width * 0.8,
                  child: Image.asset('assets/imagenes/rocket.jpg', scale: 1.5),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: media.height * 0.015),
                  padding:
                      EdgeInsets.symmetric(horizontal: media.height * 0.02),
                  child: Column(
                    children: [
                      Text("Ponle Turbo",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange[800],
                              fontSize: 16),
                          textAlign: TextAlign.center),
                      const Text(
                          "Agenda, Inteligencia Artificial, Marketing Digital, Sistema educativo",
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.height * 0.25,
                  width: media.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (_products.isEmpty &&
                              defaultTargetPlatform == TargetPlatform.iOS)
                          ? Container(
                              alignment: Alignment.center,
                              width: media.width,
                              // height: media.height,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 2,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    String key = prods.keys.toList()[i];
                                    return GestureDetector(
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          height: media.height * 0.3,
                                          width: media.width * 0.4,
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  media.height * 0.0078),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: (seleccion == i)
                                                      ? Colors.blue[800]!
                                                      : Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: media.height * 0.04,
                                                width: media.width * 0.8,
                                                decoration: BoxDecoration(
                                                    color: (seleccion == i)
                                                        ? Colors.blue[800]
                                                        : Colors.grey,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10))),
                                                alignment: Alignment.center,
                                                child: Text(prods[key]['title'],
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              SizedBox(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      (prods[key]['title']
                                                              .contains(
                                                                  'Semestral'))
                                                          ? '6'
                                                          : '12',
                                                      style: const TextStyle(
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    const Text(
                                                      "meses",
                                                      style: TextStyle(
                                                          fontSize: 22.0),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(r"$ " + prods[key]['price'],
                                                  style: TextStyle(
                                                      color: (seleccion == i)
                                                          ? Colors.green[800]
                                                          : Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22)),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            // prodSelect = prod;
                                            seleccion = i;
                                            print("Seleccion: $seleccion");
                                          });
                                        });
                                  }),
                            )
                          : Container(),
                      for (var prod in _products)
                        GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              height: media.height * 0.3,
                              width: media.width * 0.4,
                              margin: EdgeInsets.symmetric(
                                  horizontal: media.height * 0.0078),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (prodSelect == prod)
                                          ? Colors.blue[800]!
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: media.height * 0.04,
                                    width: media.width * 0.8,
                                    decoration: BoxDecoration(
                                        color: (prodSelect == prod)
                                            ? Colors.blue[800]
                                            : Colors.grey,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    alignment: Alignment.center,
                                    child: Text(prod.title,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                  SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          (prod.title.contains('Semestral'))
                                              ? '6'
                                              : '12',
                                          style: const TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const Text(
                                          "meses",
                                          style: TextStyle(fontSize: 22.0),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(r"$ " + prod.price,
                                      style: TextStyle(
                                          color: (prodSelect == prod)
                                              ? Colors.green[800]
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                // prodSelect = prod;
                                prodSelect = prod;
                                print("Seleccion: $prodSelect");
                              });
                            }),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: media.height * 0.05,
                  width: media.width * 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "¡Comprar!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () => _buyProduct(prodSelect),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Private methods go here

  /// Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from(productos_ids.keys.toList());
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
      prodSelect = _products[1];
    });
  }

  /// Gets past purchases
  // Future<void> _getPastPurchases(String came) async {

  //   QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

  //   for (PurchaseDetails purchase in response.pastPurchases) {
  //     //if (Platform.isIOS) {
  //     //_iap.completePurchase(purchase);
  //     //}

  //     // OR for consumables

  //     // TODO query your database for state of consumable products.

  //     //setState(() {
  //     // _purchases = response.pastPurchases;
  //     //});
  //     final pending = Platform.isIOS
  //         ? purchase.pendingCompletePurchase
  //         : purchase.billingClientPurchase!.isAcknowledged;

  //     if (pending) {
  //       String email =
  //           (bloC.pref.email.isNotEmpty) ? bloC.pref.email : "prueba@gmail.com";
  //       String nombre = (bloC.pref.nombreApellido.isNotEmpty)
  //           ? '${bloC.pref.nombreApellido[0]} ${bloC.pref.nombreApellido[1]}'
  //           : "Pepe Perez";
  //       await InAppPurchaseConnection.instance.completePurchase(purchase);
  //       bloC.cloudFirestore.updateDataCloud(
  //           "Global", "compras verificadas", {"$email $nombre": "Verificado"});
  //     }
  //   }
  //   if (came != "compra")
  //     setState(() {
  //       _purchases = response.pastPurchases;
  //     });
  // }

  /// Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    PurchaseDetails retrn =
        _purchases.firstWhere((purchase) => purchase.productID == productID);
    return retrn;
  }

  /// Verificamos que la compra se haya realizado, esperando que entren informacion por el Stream
  void _verifyPurchase() async {
    PurchaseDetails? purchase = _hasPurchased(prod_id);

    // TODO serverside verification & record consumable in the database

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      final bigdata = Provider.of<BigData>(context);
      // Si la compra fue exitosa, relaizamos los cambios
      DateTime expDate;
      // Segun el producto comprado, calculamos la fecha de vencimiento de la membresia.
      if (productos_ids[prod_id] == "year") {
        expDate = DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
      } else {
        expDate = DateTime(
            DateTime.now().year, DateTime.now().month + 6, DateTime.now().day);
      }
      String exp = "${expDate.year - expDate.month - expDate.day}";
      bigdata.update({
        ...bigdata.bigData,
        "Membresia": {"fecha": exp, "Prod_id": prod_id}
      });
      // Eliminamos la compra del historial luego de verificar que se realizo
      // asi la proxima vez que venga la vuelve a encontrar
      _spendCredits(_hasPurchased(prod_id));
      // Actualizamos la base de datos en la nube al comprar el producto.
      FireStore().updateDataCloud(
          "UsersData", bigdata.bigData["User"]["Email"], bigdata.bigData);
      // _getPastPurchases("compra");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const MarketScreen()));
    }
  }

  /// Purchase a product
  void _buyProduct(ProductDetails prod) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
    // Verificacmos si realmente compro el producto
    prod_id = prod.id;
  }

  /// Spend credits and consume purchase when they run pit
  void _spendCredits(PurchaseDetails purchase) async {
    /// TODO update the state of the consumable to a backend database
    // Mark consumed when credits run out
    var res = await _iap.restorePurchases();
    // await _getPastPurchases("none");
    setState(() {});
  }
}
