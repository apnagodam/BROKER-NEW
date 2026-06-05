// To parse this JSON data, do
//
//     final walletStatementModel = walletStatementModelFromJson(jsonString);

import 'dart:convert';

WalletStatementModel walletStatementModelFromJson(dynamic str) =>
    WalletStatementModel.fromJson(json.decode(str));

dynamic walletStatementModelToJson(WalletStatementModel data) =>
    json.encode(data.toJson());

class WalletStatementModel {
  dynamic status;
  dynamic message;
  List<TransactionData>? data;
  dynamic openingBalance;
  dynamic closingBalance;

  WalletStatementModel({
    this.status,
    this.message,
    this.data,
    this.openingBalance,
    this.closingBalance,
  });

  factory WalletStatementModel.fromJson(Map<dynamic, dynamic> json) =>
      WalletStatementModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<TransactionData>.from(
                json["data"]!.map((x) => TransactionData.fromJson(x)),
              ),
        openingBalance: json["opening_balance"],
        closingBalance: json["closing_balance"],
      );

  Map<dynamic, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "opening_balance": openingBalance,
    "closing_balance": closingBalance,
  };
}

class TransactionData {
  dynamic id;
  dynamic userId;
  dynamic label;
  dynamic narration;
  dynamic referenceNo;
  dynamic amount;
  dynamic type;
  dynamic balance;
  dynamic status;
  dynamic date;
  dynamic power;

  TransactionData({
    this.id,
    this.userId,
    this.label,
    this.narration,
    this.referenceNo,
    this.amount,
    this.type,
    this.balance,
    this.status,
    this.date,
    this.power,
  });

  factory TransactionData.fromJson(Map<dynamic, dynamic> json) =>
      TransactionData(
        id: json["id"],
        userId: json["user_id"],
        label: json["label"],
        narration: json["narration"],
        referenceNo: json["reference_no"],
        amount: json["amount"],
        type: json["type"],
        balance: json["balance"],
        status: json["status"],
        date: json["date"],
        power: json["power"],
      );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "label": label,
    "narration": narration,
    "reference_no": referenceNo,
    "amount": amount,
    "type": type,
    "balance": balance,
    "status": status,
    "date": date,
    "power": power,
  };
}
