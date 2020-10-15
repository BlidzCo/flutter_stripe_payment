import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripe_payment/src/web/js/stripe-js.dart'
    show Stripe, initializeStripe;
import "package:stripe_payment/src/web/js/stripe-js/elements.dart"
    show StripeElements, StripeElementsOptions;
import "package:stripe_payment/src/web/js/stripe-js/elements/card.dart"
    show StripeCardElementOptions;
import 'dart:io';
import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class StripeCreditCardForm extends StatefulWidget {
  final CreditCard card;

  StripeCreditCardForm({Key key, @required this.card}) : super(key: key);

  @override
  _StripeCreditCardFormState createState() => _StripeCreditCardFormState();
}

bool stripeContainerRegistered = false;

class _StripeCreditCardFormState extends State<StripeCreditCardForm> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Container(
          child: SizedBox(
              width: 300,
              height: 200,
              child: HtmlElementView(
                viewType: 'stripe-container',
                key: widget.key,
              )));
    } else {
      return Container(
        child: AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  autofillHints: [AutofillHints.creditCardNumber],
                  decoration:
                      const InputDecoration(labelText: 'Credit card number'),
                  key: Key("CreditCardNumber"),
                  initialValue: widget.card.number,
                  onChanged: (value) => widget.card.number = value,
                ),
                TextFormField(
                  autofillHints: [AutofillHints.creditCardExpirationYear],
                  decoration: const InputDecoration(
                      labelText: 'Credit card exipration year'),
                  key: Key("CreditCardExpirationYear"),
                  initialValue: widget.card.expYear.toString(),
                  onChanged: (value) => widget.card.expYear = int.parse(value),
                ),
                TextFormField(
                  autofillHints: [AutofillHints.creditCardExpirationMonth],
                  decoration: const InputDecoration(
                      labelText: 'Credit card exipration month'),
                  key: Key("CreditCardExpirationMonth"),
                  initialValue: widget.card.expMonth.toString(),
                  onChanged: (value) => widget.card.expMonth = int.parse(value),
                ),
                TextFormField(
                  autofillHints: [AutofillHints.creditCardSecurityCode],
                  decoration: const InputDecoration(
                      labelText: 'Credit card security code'),
                  key: Key("CreditCardCVC"),
                  initialValue: widget.card.cvc,
                  onChanged: (value) => widget.card.cvc = value,
                )
              ],
            ),
            key: widget.key),
      );
    }
  }

  dynamic token;

  @override
  void initState() {
    if (kIsWeb && !stripeContainerRegistered) {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory('stripe-container',
          (int viewId) {
        // html.DivElement container = html.DivElement()
        //   ..id = 'stripe-container'
        //   ..innerHtml =
        //       '<span class="stripe-test">Loading Stripe card form...</span><button id="stripe-submit">Submit</button>'
        //   ..style.border = 'none'
        //   ..style.width = "100px";

        // container.append(html.ScriptElement()
        //   ..text = """
        // const shadowRoot = document.querySelector("flt-platform-view").shadowRoot;
        // const container = shadowRoot.querySelector("#stripe-container");
        // const stripe = Stripe('pk_test_aSaULNS8cJU6Tvo20VAXy6rp');
        // const elements = stripe.elements();
        // const card = elements.create('card');
        // card.mount(container.querySelector('.stripe-test'));
        // container.querySelector('#stripe-submit').addEventListener('click', handle);

        // function handle() {
        //   console.log(shadowRoot, shadowRoot.host, shadowRoot.host.querySelector('#stripe-container'), container)
        //   stripe.createToken(card);
        // }
        // """);

        html.IFrameElement container = html.IFrameElement();

        html.DivElement test = html.DivElement();
        test.innerHtml =
            '<span class="stripe-test">Loading Stripe card form...</span><button id="stripe-submit">Submit</button>';

        container.parentNode.append(test);

        return container;
      });

      stripeContainerRegistered = true;

      // WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   mountCard();
      // });
    }
    super.initState();
  }

  Future<void> mountCard() async {
    token = await StripePayment.cardForm('stripe-container');
  }
}

class _MyAppState extends State<MyApp> {
  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  final String _currentSecret = null; //set this yourself, e.g using curl
  PaymentIntentResult _paymentIntent;
  Source _source;

  ScrollController _controller = ScrollController();

  CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _source = null;
                  _paymentIntent = null;
                  _paymentMethod = null;
                  _paymentToken = null;
                });
              },
            )
          ],
        ),
        body: ListView(
          controller: _controller,
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text("Create Token with Card:"),
            StripeCreditCardForm(card: testCard),
            Divider(),
            RaisedButton(
              child: Text("Create Source"),
              onPressed: () {
                StripePayment.createSourceWithParams(SourceParams(
                  type: 'ideal',
                  amount: 1099,
                  currency: 'eur',
                  returnURL: 'example://stripe-redirect',
                )).then((source) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Received ${source.sourceId}')));
                  setState(() {
                    _source = source;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Create Token with Card Form"),
              onPressed: () {
                StripePayment.paymentRequestWithCardForm(
                        CardFormPaymentRequest())
                    .then((paymentMethod) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Received ${paymentMethod.id}')));
                  setState(() {
                    _paymentMethod = paymentMethod;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Create Token with Card"),
              onPressed: () {
                if (kIsWeb) {
                  StripePayment.tokenFromCardForm();
                } else {
                  StripePayment.createTokenWithCard(
                    testCard,
                  ).then((token) {
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Received ${token.tokenId}')));
                    setState(() {
                      _paymentToken = token;
                    });
                  }).catchError(setError);
                }
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Create Payment Method with Card"),
              onPressed: () {
                StripePayment.createPaymentMethod(
                  PaymentMethodRequest(
                    card: testCard,
                  ),
                ).then((paymentMethod) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Received ${paymentMethod.id}')));
                  setState(() {
                    _paymentMethod = paymentMethod;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Create Payment Method with existing token"),
              onPressed: _paymentToken == null
                  ? null
                  : () {
                      StripePayment.createPaymentMethod(
                        PaymentMethodRequest(
                          card: CreditCard(
                            token: _paymentToken.tokenId,
                          ),
                        ),
                      ).then((paymentMethod) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Received ${paymentMethod.id}')));
                        setState(() {
                          _paymentMethod = paymentMethod;
                        });
                      }).catchError(setError);
                    },
            ),
            Divider(),
            RaisedButton(
              child: Text("Confirm Payment Intent"),
              onPressed: _paymentMethod == null || _currentSecret == null
                  ? null
                  : () {
                      StripePayment.confirmPaymentIntent(
                        PaymentIntent(
                          clientSecret: _currentSecret,
                          paymentMethodId: _paymentMethod.id,
                        ),
                      ).then((paymentIntent) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                'Received ${paymentIntent.paymentIntentId}')));
                        setState(() {
                          _paymentIntent = paymentIntent;
                        });
                      }).catchError(setError);
                    },
            ),
            RaisedButton(
              child: Text("Authenticate Payment Intent"),
              onPressed: _currentSecret == null
                  ? null
                  : () {
                      StripePayment.authenticatePaymentIntent(
                              clientSecret: _currentSecret)
                          .then((paymentIntent) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                'Received ${paymentIntent.paymentIntentId}')));
                        setState(() {
                          _paymentIntent = paymentIntent;
                        });
                      }).catchError(setError);
                    },
            ),
            Divider(),
            RaisedButton(
              child: Text("Native payment"),
              onPressed: () {
                if (!kIsWeb && Platform.isIOS) {
                  _controller.jumpTo(450);
                }
                StripePayment.paymentRequestWithNativePay(
                  androidPayOptions: AndroidPayPaymentRequest(
                    totalPrice: "1.20",
                    currencyCode: "EUR",
                  ),
                  applePayOptions: ApplePayPaymentOptions(
                    countryCode: 'DE',
                    currencyCode: 'EUR',
                    items: [
                      ApplePayItem(
                        label: 'Test',
                        amount: '13',
                      )
                    ],
                  ),
                ).then((token) {
                  setState(() {
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Received ${token.tokenId}')));
                    _paymentToken = token;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Complete Native Payment"),
              onPressed: () {
                StripePayment.completeNativePayRequest().then((_) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Completed successfully')));
                }).catchError(setError);
              },
            ),
            Divider(),
            Text('Current source:'),
            Text(
              JsonEncoder.withIndent('  ').convert(_source?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current token:'),
            Text(
              JsonEncoder.withIndent('  ')
                  .convert(_paymentToken?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current payment method:'),
            Text(
              JsonEncoder.withIndent('  ')
                  .convert(_paymentMethod?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current payment intent:'),
            Text(
              JsonEncoder.withIndent('  ')
                  .convert(_paymentIntent?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current error: $_error'),
          ],
        ),
      ),
    );
  }
}
