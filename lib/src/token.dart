class Token {
  BankAccount bankAccount;
  CreditCard card;
  double created;
  bool livemode;
  String tokenId;
  Extra extra;
  Contact contact;

  Token(
      {this.bankAccount,
      this.card,
      this.created,
      this.livemode,
      this.tokenId,
      this.extra,
      this.contact});

  factory Token.fromJson(Map<dynamic, dynamic> json) {
    return Token(
      bankAccount: json['bankAccount'] != null
          ? BankAccount.fromJson(json['bankAccount'])
          : null,
      card: json['card'] != null ? CreditCard.fromJson(json['card']) : null,
      created: json['created'] is int
          ? (json['created'] as int).toDouble()
          : json['created'],
      livemode: json['livemode'],
      tokenId: json['tokenId'],
      extra: json['extra'] != null ? Extra.fromJson(json['extra']) : null,
      contact:
          json['contact'] != null ? Contact.fromJson(json['contact']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.created != null) data['created'] = this.created;
    if (this.livemode != null) data['livemode'] = this.livemode;
    if (this.tokenId != null) data['tokenId'] = this.tokenId;
    if (this.bankAccount != null) {
      data['bankAccount'] = this.bankAccount.toJson();
    }
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    if (this.extra != null) {
      data['extra'] = this.extra.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact.toJson();
    }
    return data;
  }
}

class BankAccount {
  String accountHolderName;
  String accountHolderType;
  String accountNumber;
  String bankName;
  String countryCode;
  String currency;
  String fingerprint;
  String last4;
  String routingNumber;

  BankAccount(
      {this.accountHolderName,
      this.accountHolderType,
      this.accountNumber,
      this.bankName,
      this.countryCode,
      this.currency,
      this.fingerprint,
      this.last4,
      this.routingNumber});

  factory BankAccount.fromJson(Map<dynamic, dynamic> json) {
    return BankAccount(
      accountHolderName: json['accountHolderName'],
      accountHolderType: json['accountHolderType'],
      accountNumber: json['accountNumber'],
      bankName: json['bankName'],
      countryCode: json['countryCode'],
      currency: json['currency'],
      fingerprint: json['fingerprint'],
      last4: json['last4'],
      routingNumber: json['routingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accountHolderName != null)
      data['accountHolderName'] = this.accountHolderName;
    if (this.accountHolderType != null)
      data['accountHolderType'] = this.accountHolderType;
    if (this.accountNumber != null) data['accountNumber'] = this.accountNumber;
    if (this.bankName != null) data['bankName'] = this.bankName;
    if (this.countryCode != null) data['countryCode'] = this.countryCode;
    if (this.currency != null) data['currency'] = this.currency;
    if (this.fingerprint != null) data['fingerprint'] = this.fingerprint;
    data['last4'] = this.last4;
    if (this.routingNumber != null) data['routingNumber'] = this.routingNumber;
    return data;
  }
}

class Contact {
  String name;
  String phoneNumber;
  String emailAddress;
  String street;
  String city;
  String state;
  String country;
  // ignore: non_constant_identifier_names
  String ISOCountryCode;
  String postalCode;
  String supplementarySubLocality;

  Contact(
      {this.name,
      this.phoneNumber,
      this.emailAddress,
      this.street,
      this.city,
      this.state,
      this.country,
      // ignore: non_constant_identifier_names
      this.ISOCountryCode,
      this.postalCode,
      this.supplementarySubLocality});

  factory Contact.fromJson(Map<dynamic, dynamic> json) {
    return Contact(
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      emailAddress: json["emailAddress"],
      street: json["street"] ??
          "${json["address1"]} ${json["address2"] ?? ""}".trim(),
      city: json["city"] ?? json["locality"],
      state: json["state"] ?? json["administrativeArea"],
      country: json["country"] ?? json["countryCode"],
      // ignore: non_constant_identifier_names
      ISOCountryCode: json["ISOCountryCode"] ?? json["countryCode"],
      postalCode: json["postalCode"],
      supplementarySubLocality: json["supplementarySubLocality"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.name != null) data['name'] = this.name;
    if (this.phoneNumber != null) data['phoneNumber'] = this.phoneNumber;
    if (this.emailAddress != null) data['emailAddress'] = this.emailAddress;
    if (this.street != null) data['street'] = this.street;
    if (this.city != null) data['city'] = this.city;
    if (this.state != null) data['state'] = this.state;
    if (this.country != null) data['country'] = this.country;
    // ignore: non_constant_identifier_names
    if (this.ISOCountryCode != null)
      data['ISOCountryCode'] = this.ISOCountryCode;
    if (this.postalCode != null) data['postalCode'] = this.postalCode;
    if (this.supplementarySubLocality != null)
      data['supplementarySubLocality'] = this.supplementarySubLocality;
    return data;
  }
}

class Extra {
  String accountHolderName;
  String email;
  Contact billingContact;
  Contact shippingContact;

  Extra(
      {this.accountHolderName,
      this.email,
      this.billingContact,
      this.shippingContact});

  factory Extra.fromJson(Map<dynamic, dynamic> json) {
    return Extra(
      accountHolderName: json['accountHolderName'],
      email: json['email'],
      billingContact: json['billingContact'] != null
          ? Contact.fromJson(json['billingContact'])
          : null,
      shippingContact: json['shippingContact'] != null
          ? Contact.fromJson(json['shippingContact'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accountHolderName != null)
      data['accountHolderName'] = this.accountHolderName;
    if (this.email != null) data['email'] = this.email;
    if (this.billingContact != null) {
      data['billingContact'] = this.billingContact.toJson();
    }
    if (this.shippingContact != null) {
      data['shippingContact'] = this.shippingContact.toJson();
    }
    return data;
  }
}

class CreditCard {
  String addressCity;
  String addressCountry;
  String addressLine1;
  String addressLine2;
  String addressState;
  String addressZip;
  String brand;
  String cardId;
  String country;
  String currency;
  int expMonth;
  int expYear;
  String funding;
  String last4;
  String name;
  String number;
  String cvc;
  String token;

  CreditCard(
      {this.addressCity,
      this.addressCountry,
      this.addressLine1,
      this.addressLine2,
      this.addressState,
      this.addressZip,
      this.brand,
      this.cardId,
      this.currency,
      this.country,
      this.expMonth,
      this.expYear,
      this.number,
      this.token,
      this.cvc,
      this.funding,
      this.last4,
      this.name});

  factory CreditCard.fromJson(Map<dynamic, dynamic> json) {
    return CreditCard(
        addressCity: json['addressCity'],
        addressCountry: json['addressCountry'],
        addressLine1: json['addressLine1'],
        addressLine2: json['addressLine2'],
        addressState: json['addressState'],
        addressZip: json['addressZip'],
        brand: json['brand'],
        cardId: json['cardId'],
        currency: json['currency'],
        country: json['country'],
        expMonth: json['expMonth'],
        expYear: json['expYear'],
        funding: json['funding'],
        last4: json['last4'],
        name: json['name'],
        cvc: json['cvc'],
        number: json['number'],
        token: json['token']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressCity != null) data['addressCity'] = this.addressCity;
    if (this.addressCountry != null)
      data['addressCountry'] = this.addressCountry;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    if (this.addressState != null) data['addressState'] = this.addressState;
    if (this.addressZip != null) data['addressZip'] = this.addressZip;
    if (this.brand != null) data['brand'] = this.brand;
    if (this.cardId != null) data['cardId'] = this.cardId;
    if (this.country != null) data['country'] = this.country;
    if (this.expMonth != null) data['expMonth'] = this.expMonth;
    if (this.expYear != null) data['expYear'] = this.expYear;
    if (this.funding != null) data['funding'] = this.funding;
    if (this.currency != null) data['currency'] = this.currency;
    data['last4'] = this.last4;
    if (this.name != null) data['name'] = this.name;
    if (this.number != null) data['number'] = this.number;
    if (this.cvc != null) data['cvc'] = this.cvc;
    if (this.token != null) data['token'] = this.token;
    return data;
  }
}
