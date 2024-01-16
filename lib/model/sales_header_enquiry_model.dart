import 'dart:convert';

List<SalesHeaderEnquiry> salesHeaderEnquiryFromJson(String str) =>
    List<SalesHeaderEnquiry>.from(
        json.decode(str).map((x) => SalesHeaderEnquiry.fromJson(x)));

String salesHeaderEnquiryToJson(List<SalesHeaderEnquiry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesHeaderEnquiry {
  final String shopCode;
  final String staffCode;
  final List<TxSalesDetail> txSalesDetails;
  final List<TxPayment> txPayments;
  final int txSalesHeaderId;
  final int accountId;
  final int shopId;
  final String txCode;
  final DateTime txDate;
  final String receiptNo;
  final bool isCurrentTx;
  final bool voided;
  final bool enabled;
  final int tableId;
  final String tableCode;
  final dynamic previousTableId;
  final dynamic previousTableCode;
  final int sectionId;
  final String sectionName;
  final DateTime checkinDatetime;
  final DateTime checkoutDatetime;
  final int checkinUserId;
  final CashierUserName checkinUserName;
  final int checkoutUserId;
  final CashierUserName checkoutUserName;
  final int cashierUserId;
  final CashierUserName cashierUserName;
  final DateTime cashierDatetime;
  final int amountPaid;
  final int amountChange;
  final double amountSubtotal;
  final int amountServiceCharge;
  final int amountDiscount;
  final int amountTotal;
  final double amountRounding;
  final bool txCompleted;
  final bool txChecked;
  final DateTime createdDate;
  final CashierUserName createdBy;
  final DateTime modifiedDate;
  final CashierUserName modifiedBy;
  final bool isTakeAway;
  final dynamic takeAwayRunningIndex;
  final dynamic disabledReasonId;
  final dynamic disabledReasonDesc;
  final dynamic disabledByUserId;
  final dynamic disabledByUserName;
  final dynamic disabledDateTime;
  final int workdayPeriodDetailId;
  final String workdayPeriodName;
  final dynamic discountId;
  final dynamic discountName;
  final String cashDrawerCode;
  final int receiptPrintCount;
  final int txRevokeCount;
  final dynamic serviceChargeId;
  final dynamic serviceChargeName;
  final int amountTips;
  final dynamic isTimeLimited;
  final dynamic timeLimitedMinutes;
  final dynamic cusCount;
  final dynamic discountByUserId;
  final dynamic discountByUserName;
  final dynamic amountPointTotal;
  final dynamic memberPointRemain;
  final dynamic taxationId;
  final dynamic taxationName;
  final int amountTaxation;
  final dynamic amountMinChargeOffset;
  final dynamic isMinChargeOffsetWaived;
  final bool isMinChargeTx;
  final dynamic isMinChargePerHead;
  final dynamic minChargeAmount;
  final dynamic minChargeMemberAmount;
  final dynamic isPrepaidRechargeTx;
  final bool isInvoicePrintPending;
  final int invoiceNum;
  final int orderNum;
  final dynamic isDepositTx;
  final dynamic totalDepositAmount;
  final dynamic depositRemark;
  final dynamic isDepositOutstanding;
  final dynamic isReturnTx;
  final dynamic hasReturned;
  final dynamic returnedDateTime;
  final dynamic returnedTxSalesHeaderId;
  final dynamic newTxSalesHeaderIdForReturn;
  final int apiGatewayRefId;
  final dynamic apiGatewayName;
  final dynamic apiGatewayRefRemark;
  final dynamic tableRemark;
  final dynamic txSalesHeaderRemark;
  final int totalPaymentMethodSurchargeAmount;
  final bool isNonSalesTx;
  final bool isNoOtherLoyaltyTx;
  final int startWorkdayPeriodDetailId;
  final String startWorkdayPeriodName;
  final dynamic odoOrderToken;
  final bool isOdoTx;
  final int amountOverpayment;
  final int txStatusId;
  final dynamic overridedChecklistPrinterName;
  final int orderSourceTypeId;
  final dynamic orderSourceRefId;
  final int? orderChannelId;
  final dynamic orderChannelCode;
  final dynamic orderChannelName;
  final dynamic apiGatewayRefCode;
  final dynamic apiGatewayResponseCode;
  final dynamic discount;
  final dynamic reason;
  final dynamic serviceCharge;
  final dynamic shop;
  final dynamic shopWorkdayPeriodDetail;
  final dynamic tableMaster;
  final dynamic tableMasterNavigation;
  final dynamic tableSection;
  final dynamic user;
  final dynamic user1;
  final dynamic user2;
  final dynamic userNavigation;
  final dynamic memberTxLog;
  final dynamic txSalesHeaderAddress;
  final List<dynamic> txReceiptReprintLog;
  final List<dynamic> txSalesDeliveryDetail;
  final List<dynamic> txSalesDetailTxSalesHeader;
  final List<dynamic> txSalesHeaderLog;
  final List<dynamic> txSalesHeaderRevokeLog;
  final List<dynamic> txSalesDeliveryService;

  SalesHeaderEnquiry({
    required this.shopCode,
    required this.staffCode,
    required this.txSalesDetails,
    required this.txPayments,
    required this.txSalesHeaderId,
    required this.accountId,
    required this.shopId,
    required this.txCode,
    required this.txDate,
    required this.receiptNo,
    required this.isCurrentTx,
    required this.voided,
    required this.enabled,
    required this.tableId,
    required this.tableCode,
    required this.previousTableId,
    required this.previousTableCode,
    required this.sectionId,
    required this.sectionName,
    required this.checkinDatetime,
    required this.checkoutDatetime,
    required this.checkinUserId,
    required this.checkinUserName,
    required this.checkoutUserId,
    required this.checkoutUserName,
    required this.cashierUserId,
    required this.cashierUserName,
    required this.cashierDatetime,
    required this.amountPaid,
    required this.amountChange,
    required this.amountSubtotal,
    required this.amountServiceCharge,
    required this.amountDiscount,
    required this.amountTotal,
    required this.amountRounding,
    required this.txCompleted,
    required this.txChecked,
    required this.createdDate,
    required this.createdBy,
    required this.modifiedDate,
    required this.modifiedBy,
    required this.isTakeAway,
    required this.takeAwayRunningIndex,
    required this.disabledReasonId,
    required this.disabledReasonDesc,
    required this.disabledByUserId,
    required this.disabledByUserName,
    required this.disabledDateTime,
    required this.workdayPeriodDetailId,
    required this.workdayPeriodName,
    required this.discountId,
    required this.discountName,
    required this.cashDrawerCode,
    required this.receiptPrintCount,
    required this.txRevokeCount,
    required this.serviceChargeId,
    required this.serviceChargeName,
    required this.amountTips,
    required this.isTimeLimited,
    required this.timeLimitedMinutes,
    required this.cusCount,
    required this.discountByUserId,
    required this.discountByUserName,
    required this.amountPointTotal,
    required this.memberPointRemain,
    required this.taxationId,
    required this.taxationName,
    required this.amountTaxation,
    required this.amountMinChargeOffset,
    required this.isMinChargeOffsetWaived,
    required this.isMinChargeTx,
    required this.isMinChargePerHead,
    required this.minChargeAmount,
    required this.minChargeMemberAmount,
    required this.isPrepaidRechargeTx,
    required this.isInvoicePrintPending,
    required this.invoiceNum,
    required this.orderNum,
    required this.isDepositTx,
    required this.totalDepositAmount,
    required this.depositRemark,
    required this.isDepositOutstanding,
    required this.isReturnTx,
    required this.hasReturned,
    required this.returnedDateTime,
    required this.returnedTxSalesHeaderId,
    required this.newTxSalesHeaderIdForReturn,
    required this.apiGatewayRefId,
    required this.apiGatewayName,
    required this.apiGatewayRefRemark,
    required this.tableRemark,
    required this.txSalesHeaderRemark,
    required this.totalPaymentMethodSurchargeAmount,
    required this.isNonSalesTx,
    required this.isNoOtherLoyaltyTx,
    required this.startWorkdayPeriodDetailId,
    required this.startWorkdayPeriodName,
    required this.odoOrderToken,
    required this.isOdoTx,
    required this.amountOverpayment,
    required this.txStatusId,
    required this.overridedChecklistPrinterName,
    required this.orderSourceTypeId,
    required this.orderSourceRefId,
    required this.orderChannelId,
    required this.orderChannelCode,
    required this.orderChannelName,
    required this.apiGatewayRefCode,
    required this.apiGatewayResponseCode,
    required this.discount,
    required this.reason,
    required this.serviceCharge,
    required this.shop,
    required this.shopWorkdayPeriodDetail,
    required this.tableMaster,
    required this.tableMasterNavigation,
    required this.tableSection,
    required this.user,
    required this.user1,
    required this.user2,
    required this.userNavigation,
    required this.memberTxLog,
    required this.txSalesHeaderAddress,
    required this.txReceiptReprintLog,
    required this.txSalesDeliveryDetail,
    required this.txSalesDetailTxSalesHeader,
    required this.txSalesHeaderLog,
    required this.txSalesHeaderRevokeLog,
    required this.txSalesDeliveryService,
  });

  factory SalesHeaderEnquiry.fromJson(Map<String, dynamic> json) =>
      SalesHeaderEnquiry(
        shopCode: json["shopCode"],
        staffCode: json["staffCode"],
        txSalesDetails: List<TxSalesDetail>.from(
            json["txSalesDetails"].map((x) => TxSalesDetail.fromJson(x))),
        txPayments: List<TxPayment>.from(
            json["txPayments"].map((x) => TxPayment.fromJson(x))),
        txSalesHeaderId: json["txSalesHeaderId"],
        accountId: json["accountId"],
        shopId: json["shopId"],
        txCode: json["txCode"],
        txDate: DateTime.parse(json["txDate"]),
        receiptNo: json["receiptNo"],
        isCurrentTx: json["isCurrentTx"],
        voided: json["voided"],
        enabled: json["enabled"],
        tableId: json["tableId"],
        tableCode: json["tableCode"],
        previousTableId: json["previousTableId"],
        previousTableCode: json["previousTableCode"],
        sectionId: json["sectionId"],
        sectionName: json["sectionName"],
        checkinDatetime: DateTime.parse(json["checkinDatetime"]),
        checkoutDatetime: DateTime.parse(json["checkoutDatetime"]),
        checkinUserId: json["checkinUserId"],
        checkinUserName: cashierUserNameValues.map[json["checkinUserName"]]!,
        checkoutUserId: json["checkoutUserId"],
        checkoutUserName: cashierUserNameValues.map[json["checkoutUserName"]]!,
        cashierUserId: json["cashierUserId"],
        cashierUserName: cashierUserNameValues.map[json["cashierUserName"]]!,
        cashierDatetime: DateTime.parse(json["cashierDatetime"]),
        amountPaid: json["amountPaid"],
        amountChange: json["amountChange"],
        amountSubtotal: json["amountSubtotal"]?.toDouble(),
        amountServiceCharge: json["amountServiceCharge"],
        amountDiscount: json["amountDiscount"],
        amountTotal: json["amountTotal"],
        amountRounding: json["amountRounding"]?.toDouble(),
        txCompleted: json["txCompleted"],
        txChecked: json["txChecked"],
        createdDate: DateTime.parse(json["createdDate"]),
        createdBy: cashierUserNameValues.map[json["createdBy"]]!,
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        modifiedBy: cashierUserNameValues.map[json["modifiedBy"]]!,
        isTakeAway: json["isTakeAway"],
        takeAwayRunningIndex: json["takeAwayRunningIndex"],
        disabledReasonId: json["disabledReasonId"],
        disabledReasonDesc: json["disabledReasonDesc"],
        disabledByUserId: json["disabledByUserId"],
        disabledByUserName: json["disabledByUserName"],
        disabledDateTime: json["disabledDateTime"],
        workdayPeriodDetailId: json["workdayPeriodDetailId"],
        workdayPeriodName: json["workdayPeriodName"],
        discountId: json["discountId"],
        discountName: json["discountName"],
        cashDrawerCode: json["cashDrawerCode"],
        receiptPrintCount: json["receiptPrintCount"],
        txRevokeCount: json["txRevokeCount"],
        serviceChargeId: json["serviceChargeId"],
        serviceChargeName: json["serviceChargeName"],
        amountTips: json["amountTips"],
        isTimeLimited: json["isTimeLimited"],
        timeLimitedMinutes: json["timeLimitedMinutes"],
        cusCount: json["cusCount"],
        discountByUserId: json["discountByUserId"],
        discountByUserName: json["discountByUserName"],
        amountPointTotal: json["amountPointTotal"],
        memberPointRemain: json["memberPointRemain"],
        taxationId: json["taxationId"],
        taxationName: json["taxationName"],
        amountTaxation: json["amountTaxation"],
        amountMinChargeOffset: json["amountMinChargeOffset"],
        isMinChargeOffsetWaived: json["isMinChargeOffsetWaived"],
        isMinChargeTx: json["isMinChargeTx"],
        isMinChargePerHead: json["isMinChargePerHead"],
        minChargeAmount: json["minChargeAmount"],
        minChargeMemberAmount: json["minChargeMemberAmount"],
        isPrepaidRechargeTx: json["isPrepaidRechargeTx"],
        isInvoicePrintPending: json["isInvoicePrintPending"],
        invoiceNum: json["invoiceNum"],
        orderNum: json["orderNum"],
        isDepositTx: json["isDepositTx"],
        totalDepositAmount: json["totalDepositAmount"],
        depositRemark: json["depositRemark"],
        isDepositOutstanding: json["isDepositOutstanding"],
        isReturnTx: json["isReturnTx"],
        hasReturned: json["hasReturned"],
        returnedDateTime: json["returnedDateTime"],
        returnedTxSalesHeaderId: json["returnedTxSalesHeaderId"],
        newTxSalesHeaderIdForReturn: json["newTxSalesHeaderIdForReturn"],
        apiGatewayRefId: json["apiGatewayRefId"],
        apiGatewayName: json["apiGatewayName"],
        apiGatewayRefRemark: json["apiGatewayRefRemark"],
        tableRemark: json["tableRemark"],
        txSalesHeaderRemark: json["txSalesHeaderRemark"],
        totalPaymentMethodSurchargeAmount:
            json["totalPaymentMethodSurchargeAmount"],
        isNonSalesTx: json["isNonSalesTx"],
        isNoOtherLoyaltyTx: json["isNoOtherLoyaltyTx"],
        startWorkdayPeriodDetailId: json["startWorkdayPeriodDetailId"],
        startWorkdayPeriodName: json["startWorkdayPeriodName"],
        odoOrderToken: json["odoOrderToken"],
        isOdoTx: json["isOdoTx"],
        amountOverpayment: json["amountOverpayment"],
        txStatusId: json["txStatusId"],
        overridedChecklistPrinterName: json["overridedChecklistPrinterName"],
        orderSourceTypeId: json["orderSourceTypeId"],
        orderSourceRefId: json["orderSourceRefId"],
        orderChannelId: json["orderChannelId"],
        orderChannelCode: json["orderChannelCode"],
        orderChannelName: json["orderChannelName"],
        apiGatewayRefCode: json["apiGatewayRefCode"],
        apiGatewayResponseCode: json["apiGatewayResponseCode"],
        discount: json["discount"],
        reason: json["reason"],
        serviceCharge: json["serviceCharge"],
        shop: json["shop"],
        shopWorkdayPeriodDetail: json["shopWorkdayPeriodDetail"],
        tableMaster: json["tableMaster"],
        tableMasterNavigation: json["tableMasterNavigation"],
        tableSection: json["tableSection"],
        user: json["user"],
        user1: json["user1"],
        user2: json["user2"],
        userNavigation: json["userNavigation"],
        memberTxLog: json["memberTxLog"],
        txSalesHeaderAddress: json["txSalesHeaderAddress"],
        txReceiptReprintLog:
            List<dynamic>.from(json["txReceiptReprintLog"].map((x) => x)),
        txSalesDeliveryDetail:
            List<dynamic>.from(json["txSalesDeliveryDetail"].map((x) => x)),
        txSalesDetailTxSalesHeader: List<dynamic>.from(
            json["txSalesDetailTxSalesHeader"].map((x) => x)),
        txSalesHeaderLog:
            List<dynamic>.from(json["txSalesHeaderLog"].map((x) => x)),
        txSalesHeaderRevokeLog:
            List<dynamic>.from(json["txSalesHeaderRevokeLog"].map((x) => x)),
        txSalesDeliveryService:
            List<dynamic>.from(json["txSalesDeliveryService"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "shopCode": shopCode,
        "staffCode": staffCode,
        "txSalesDetails":
            List<dynamic>.from(txSalesDetails.map((x) => x.toJson())),
        "txPayments": List<dynamic>.from(txPayments.map((x) => x.toJson())),
        "txSalesHeaderId": txSalesHeaderId,
        "accountId": accountId,
        "shopId": shopId,
        "txCode": txCode,
        "txDate": txDate.toIso8601String(),
        "receiptNo": receiptNo,
        "isCurrentTx": isCurrentTx,
        "voided": voided,
        "enabled": enabled,
        "tableId": tableId,
        "tableCode": tableCode,
        "previousTableId": previousTableId,
        "previousTableCode": previousTableCode,
        "sectionId": sectionId,
        "sectionName": sectionName,
        "checkinDatetime": checkinDatetime.toIso8601String(),
        "checkoutDatetime": checkoutDatetime.toIso8601String(),
        "checkinUserId": checkinUserId,
        "checkinUserName": cashierUserNameValues.reverse[checkinUserName],
        "checkoutUserId": checkoutUserId,
        "checkoutUserName": cashierUserNameValues.reverse[checkoutUserName],
        "cashierUserId": cashierUserId,
        "cashierUserName": cashierUserNameValues.reverse[cashierUserName],
        "cashierDatetime": cashierDatetime.toIso8601String(),
        "amountPaid": amountPaid,
        "amountChange": amountChange,
        "amountSubtotal": amountSubtotal,
        "amountServiceCharge": amountServiceCharge,
        "amountDiscount": amountDiscount,
        "amountTotal": amountTotal,
        "amountRounding": amountRounding,
        "txCompleted": txCompleted,
        "txChecked": txChecked,
        "createdDate": createdDate.toIso8601String(),
        "createdBy": cashierUserNameValues.reverse[createdBy],
        "modifiedDate": modifiedDate.toIso8601String(),
        "modifiedBy": cashierUserNameValues.reverse[modifiedBy],
        "isTakeAway": isTakeAway,
        "takeAwayRunningIndex": takeAwayRunningIndex,
        "disabledReasonId": disabledReasonId,
        "disabledReasonDesc": disabledReasonDesc,
        "disabledByUserId": disabledByUserId,
        "disabledByUserName": disabledByUserName,
        "disabledDateTime": disabledDateTime,
        "workdayPeriodDetailId": workdayPeriodDetailId,
        "workdayPeriodName": workdayPeriodName,
        "discountId": discountId,
        "discountName": discountName,
        "cashDrawerCode": cashDrawerCode,
        "receiptPrintCount": receiptPrintCount,
        "txRevokeCount": txRevokeCount,
        "serviceChargeId": serviceChargeId,
        "serviceChargeName": serviceChargeName,
        "amountTips": amountTips,
        "isTimeLimited": isTimeLimited,
        "timeLimitedMinutes": timeLimitedMinutes,
        "cusCount": cusCount,
        "discountByUserId": discountByUserId,
        "discountByUserName": discountByUserName,
        "amountPointTotal": amountPointTotal,
        "memberPointRemain": memberPointRemain,
        "taxationId": taxationId,
        "taxationName": taxationName,
        "amountTaxation": amountTaxation,
        "amountMinChargeOffset": amountMinChargeOffset,
        "isMinChargeOffsetWaived": isMinChargeOffsetWaived,
        "isMinChargeTx": isMinChargeTx,
        "isMinChargePerHead": isMinChargePerHead,
        "minChargeAmount": minChargeAmount,
        "minChargeMemberAmount": minChargeMemberAmount,
        "isPrepaidRechargeTx": isPrepaidRechargeTx,
        "isInvoicePrintPending": isInvoicePrintPending,
        "invoiceNum": invoiceNum,
        "orderNum": orderNum,
        "isDepositTx": isDepositTx,
        "totalDepositAmount": totalDepositAmount,
        "depositRemark": depositRemark,
        "isDepositOutstanding": isDepositOutstanding,
        "isReturnTx": isReturnTx,
        "hasReturned": hasReturned,
        "returnedDateTime": returnedDateTime,
        "returnedTxSalesHeaderId": returnedTxSalesHeaderId,
        "newTxSalesHeaderIdForReturn": newTxSalesHeaderIdForReturn,
        "apiGatewayRefId": apiGatewayRefId,
        "apiGatewayName": apiGatewayName,
        "apiGatewayRefRemark": apiGatewayRefRemark,
        "tableRemark": tableRemark,
        "txSalesHeaderRemark": txSalesHeaderRemark,
        "totalPaymentMethodSurchargeAmount": totalPaymentMethodSurchargeAmount,
        "isNonSalesTx": isNonSalesTx,
        "isNoOtherLoyaltyTx": isNoOtherLoyaltyTx,
        "startWorkdayPeriodDetailId": startWorkdayPeriodDetailId,
        "startWorkdayPeriodName": startWorkdayPeriodName,
        "odoOrderToken": odoOrderToken,
        "isOdoTx": isOdoTx,
        "amountOverpayment": amountOverpayment,
        "txStatusId": txStatusId,
        "overridedChecklistPrinterName": overridedChecklistPrinterName,
        "orderSourceTypeId": orderSourceTypeId,
        "orderSourceRefId": orderSourceRefId,
        "orderChannelId": orderChannelId,
        "orderChannelCode": orderChannelCode,
        "orderChannelName": orderChannelName,
        "apiGatewayRefCode": apiGatewayRefCode,
        "apiGatewayResponseCode": apiGatewayResponseCode,
        "discount": discount,
        "reason": reason,
        "serviceCharge": serviceCharge,
        "shop": shop,
        "shopWorkdayPeriodDetail": shopWorkdayPeriodDetail,
        "tableMaster": tableMaster,
        "tableMasterNavigation": tableMasterNavigation,
        "tableSection": tableSection,
        "user": user,
        "user1": user1,
        "user2": user2,
        "userNavigation": userNavigation,
        "memberTxLog": memberTxLog,
        "txSalesHeaderAddress": txSalesHeaderAddress,
        "txReceiptReprintLog":
            List<dynamic>.from(txReceiptReprintLog.map((x) => x)),
        "txSalesDeliveryDetail":
            List<dynamic>.from(txSalesDeliveryDetail.map((x) => x)),
        "txSalesDetailTxSalesHeader":
            List<dynamic>.from(txSalesDetailTxSalesHeader.map((x) => x)),
        "txSalesHeaderLog": List<dynamic>.from(txSalesHeaderLog.map((x) => x)),
        "txSalesHeaderRevokeLog":
            List<dynamic>.from(txSalesHeaderRevokeLog.map((x) => x)),
        "txSalesDeliveryService":
            List<dynamic>.from(txSalesDeliveryService.map((x) => x)),
      };
}

enum CashierUserName { JOHN_DOE }

final cashierUserNameValues =
    EnumValues({"John Doe": CashierUserName.JOHN_DOE});

class TxPayment {
  final dynamic linkedGateway;
  final int txPaymentId;
  final int accountId;
  final int shopId;
  final int txSalesHeaderId;
  final int paymentMethodId;
  final String paymentMethodName;
  final int totalAmount;
  final int paidAmount;
  final bool enabled;
  final DateTime createdDate;
  final CashierUserName createdBy;
  final DateTime modifiedDate;
  final CashierUserName modifiedBy;
  final dynamic oclNum;
  final dynamic oclRemainValue;
  final dynamic oclDeviceNum;
  final dynamic refNum;
  final dynamic remark1;
  final dynamic remark2;
  final dynamic remark3;
  final dynamic remark4;
  final dynamic remark5;
  final dynamic remark6;
  final dynamic remark7;
  final dynamic remark8;
  final dynamic remark9;
  final dynamic remark10;
  final int changeAmount;
  final int cashoutAmount;
  final int tipAmount;
  final dynamic isDepositPayment;
  final dynamic depositReceivedByUserId;
  final dynamic depositReceivedByUserName;
  final dynamic depositReceivedDatetime;
  final dynamic depositWorkdayDetailId;
  final dynamic depositWorkdayPeriodDetailId;
  final dynamic depositWorkdayPeriodName;
  final int paymentMethodSurchargeAmount;
  final dynamic paymentMethodSurchargeRate;
  final bool isNonSalesTxPayment;
  final dynamic isPreprintedCouponTxPayment;
  final int overpaymentAmount;
  final dynamic paymentCurrency;
  final dynamic paymentPathway;
  final dynamic paymentRemark;
  final dynamic changeAmountFx;
  final bool isChangeAmountFx;
  final bool isFxPayment;
  final dynamic paidAmountFx;
  final dynamic paymentFxRate;
  final dynamic totalAmountFx;
  final dynamic isOdoTx;
  final dynamic isOnlinePayment;
  final int txChargesRate;
  final int txTotalCharges;
  final int txTipCharges;
  final int txNetTotal;
  final int txNetTip;
  final dynamic paymentMethod;
  final dynamic shop;

  TxPayment({
    required this.linkedGateway,
    required this.txPaymentId,
    required this.accountId,
    required this.shopId,
    required this.txSalesHeaderId,
    required this.paymentMethodId,
    required this.paymentMethodName,
    required this.totalAmount,
    required this.paidAmount,
    required this.enabled,
    required this.createdDate,
    required this.createdBy,
    required this.modifiedDate,
    required this.modifiedBy,
    required this.oclNum,
    required this.oclRemainValue,
    required this.oclDeviceNum,
    required this.refNum,
    required this.remark1,
    required this.remark2,
    required this.remark3,
    required this.remark4,
    required this.remark5,
    required this.remark6,
    required this.remark7,
    required this.remark8,
    required this.remark9,
    required this.remark10,
    required this.changeAmount,
    required this.cashoutAmount,
    required this.tipAmount,
    required this.isDepositPayment,
    required this.depositReceivedByUserId,
    required this.depositReceivedByUserName,
    required this.depositReceivedDatetime,
    required this.depositWorkdayDetailId,
    required this.depositWorkdayPeriodDetailId,
    required this.depositWorkdayPeriodName,
    required this.paymentMethodSurchargeAmount,
    required this.paymentMethodSurchargeRate,
    required this.isNonSalesTxPayment,
    required this.isPreprintedCouponTxPayment,
    required this.overpaymentAmount,
    required this.paymentCurrency,
    required this.paymentPathway,
    required this.paymentRemark,
    required this.changeAmountFx,
    required this.isChangeAmountFx,
    required this.isFxPayment,
    required this.paidAmountFx,
    required this.paymentFxRate,
    required this.totalAmountFx,
    required this.isOdoTx,
    required this.isOnlinePayment,
    required this.txChargesRate,
    required this.txTotalCharges,
    required this.txTipCharges,
    required this.txNetTotal,
    required this.txNetTip,
    required this.paymentMethod,
    required this.shop,
  });

  factory TxPayment.fromJson(Map<String, dynamic> json) => TxPayment(
        linkedGateway: json["linkedGateway"],
        txPaymentId: json["txPaymentId"],
        accountId: json["accountId"],
        shopId: json["shopId"],
        txSalesHeaderId: json["txSalesHeaderId"],
        paymentMethodId: json["paymentMethodId"],
        paymentMethodName: json["paymentMethodName"],
        totalAmount: json["totalAmount"],
        paidAmount: json["paidAmount"],
        enabled: json["enabled"],
        createdDate: DateTime.parse(json["createdDate"]),
        createdBy: cashierUserNameValues.map[json["createdBy"]]!,
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        modifiedBy: cashierUserNameValues.map[json["modifiedBy"]]!,
        oclNum: json["oclNum"],
        oclRemainValue: json["oclRemainValue"],
        oclDeviceNum: json["oclDeviceNum"],
        refNum: json["refNum"],
        remark1: json["remark1"],
        remark2: json["remark2"],
        remark3: json["remark3"],
        remark4: json["remark4"],
        remark5: json["remark5"],
        remark6: json["remark6"],
        remark7: json["remark7"],
        remark8: json["remark8"],
        remark9: json["remark9"],
        remark10: json["remark10"],
        changeAmount: json["changeAmount"],
        cashoutAmount: json["cashoutAmount"],
        tipAmount: json["tipAmount"],
        isDepositPayment: json["isDepositPayment"],
        depositReceivedByUserId: json["depositReceivedByUserId"],
        depositReceivedByUserName: json["depositReceivedByUserName"],
        depositReceivedDatetime: json["depositReceivedDatetime"],
        depositWorkdayDetailId: json["depositWorkdayDetailId"],
        depositWorkdayPeriodDetailId: json["depositWorkdayPeriodDetailId"],
        depositWorkdayPeriodName: json["depositWorkdayPeriodName"],
        paymentMethodSurchargeAmount: json["paymentMethodSurchargeAmount"],
        paymentMethodSurchargeRate: json["paymentMethodSurchargeRate"],
        isNonSalesTxPayment: json["isNonSalesTxPayment"],
        isPreprintedCouponTxPayment: json["isPreprintedCouponTxPayment"],
        overpaymentAmount: json["overpaymentAmount"],
        paymentCurrency: json["paymentCurrency"],
        paymentPathway: json["paymentPathway"],
        paymentRemark: json["paymentRemark"],
        changeAmountFx: json["changeAmountFx"],
        isChangeAmountFx: json["isChangeAmountFx"],
        isFxPayment: json["isFxPayment"],
        paidAmountFx: json["paidAmountFx"],
        paymentFxRate: json["paymentFxRate"],
        totalAmountFx: json["totalAmountFx"],
        isOdoTx: json["isOdoTx"],
        isOnlinePayment: json["isOnlinePayment"],
        txChargesRate: json["txChargesRate"],
        txTotalCharges: json["txTotalCharges"],
        txTipCharges: json["txTipCharges"],
        txNetTotal: json["txNetTotal"],
        txNetTip: json["txNetTip"],
        paymentMethod: json["paymentMethod"],
        shop: json["shop"],
      );

  Map<String, dynamic> toJson() => {
        "linkedGateway": linkedGateway,
        "txPaymentId": txPaymentId,
        "accountId": accountId,
        "shopId": shopId,
        "txSalesHeaderId": txSalesHeaderId,
        "paymentMethodId": paymentMethodId,
        "paymentMethodName": paymentMethodName,
        "totalAmount": totalAmount,
        "paidAmount": paidAmount,
        "enabled": enabled,
        "createdDate": createdDate.toIso8601String(),
        "createdBy": cashierUserNameValues.reverse[createdBy],
        "modifiedDate": modifiedDate.toIso8601String(),
        "modifiedBy": cashierUserNameValues.reverse[modifiedBy],
        "oclNum": oclNum,
        "oclRemainValue": oclRemainValue,
        "oclDeviceNum": oclDeviceNum,
        "refNum": refNum,
        "remark1": remark1,
        "remark2": remark2,
        "remark3": remark3,
        "remark4": remark4,
        "remark5": remark5,
        "remark6": remark6,
        "remark7": remark7,
        "remark8": remark8,
        "remark9": remark9,
        "remark10": remark10,
        "changeAmount": changeAmount,
        "cashoutAmount": cashoutAmount,
        "tipAmount": tipAmount,
        "isDepositPayment": isDepositPayment,
        "depositReceivedByUserId": depositReceivedByUserId,
        "depositReceivedByUserName": depositReceivedByUserName,
        "depositReceivedDatetime": depositReceivedDatetime,
        "depositWorkdayDetailId": depositWorkdayDetailId,
        "depositWorkdayPeriodDetailId": depositWorkdayPeriodDetailId,
        "depositWorkdayPeriodName": depositWorkdayPeriodName,
        "paymentMethodSurchargeAmount": paymentMethodSurchargeAmount,
        "paymentMethodSurchargeRate": paymentMethodSurchargeRate,
        "isNonSalesTxPayment": isNonSalesTxPayment,
        "isPreprintedCouponTxPayment": isPreprintedCouponTxPayment,
        "overpaymentAmount": overpaymentAmount,
        "paymentCurrency": paymentCurrency,
        "paymentPathway": paymentPathway,
        "paymentRemark": paymentRemark,
        "changeAmountFx": changeAmountFx,
        "isChangeAmountFx": isChangeAmountFx,
        "isFxPayment": isFxPayment,
        "paidAmountFx": paidAmountFx,
        "paymentFxRate": paymentFxRate,
        "totalAmountFx": totalAmountFx,
        "isOdoTx": isOdoTx,
        "isOnlinePayment": isOnlinePayment,
        "txChargesRate": txChargesRate,
        "txTotalCharges": txTotalCharges,
        "txTipCharges": txTipCharges,
        "txNetTotal": txNetTotal,
        "txNetTip": txNetTip,
        "paymentMethod": paymentMethod,
        "shop": shop,
      };
}

class TxSalesDetail {
  final CategoryName categoryName;
  final bool isPriceInPercentage;
  final dynamic departmentRevenueAmount;
  final dynamic promoCode;
  final dynamic promoName;
  final int txSalesDetailId;
  final int accountId;
  final int txSalesHeaderId;
  final dynamic previousTxSalesHeaderId;
  final int seqNo;
  final bool isSubItem;
  final bool isModifier;
  final dynamic parentTxSalesDetailId;
  final int subItemLevel;
  final String itemPath;
  final int itemSetRunningIndex;
  final int itemOrderRunningIndex;
  final DateTime orderDateTime;
  final int orderUserId;
  final CashierUserName orderUserName;
  final int itemId;
  final int categoryId;
  final String itemCode;
  final String itemName;
  final dynamic itemNameAlt2;
  final int qty;
  final double price;
  final double amount;
  final bool enabled;
  final bool voided;
  final bool printedKitchen;
  final int printedKitchenByUserId;
  final CashierUserName printedKitchenByUserName;
  final DateTime printedKitchenDateTime;
  final dynamic disabledReasonId;
  final dynamic disabledReasonDesc;
  final dynamic disabledByUserId;
  final dynamic disabledByUserName;
  final dynamic disabledDateTime;
  final dynamic chaseCount;
  final dynamic chaseUserId;
  final dynamic chaseUserName;
  final dynamic chaseDateTime;
  final DateTime createdDate;
  final CashierUserName createdBy;
  final DateTime modifiedDate;
  final CashierUserName modifiedBy;
  final bool isPromoComboItem;
  final int shopId;
  final dynamic itemNameAlt;
  final dynamic itemNameAl3;
  final dynamic itemNameAl4;
  final dynamic itemPosName;
  final dynamic itemPosNameAlt;
  final int departmentId;
  final DepartmentName departmentName;
  final bool isPointPaidItem;
  final int amountPoint;
  final int point;
  final bool isNonTaxableItem;
  final dynamic isItemOnHold;
  final dynamic itemOnHoldDateTime;
  final dynamic itemOnHoldUserId;
  final dynamic itemOnHoldUserName;
  final dynamic isItemFired;
  final dynamic itemFiredDateTime;
  final dynamic itemFiredUserId;
  final dynamic itemFiredUserName;
  final int takeawaySurcharge;
  final bool isItemShowInKitchenChecklist;
  final bool isPrepaidRechargeItem;
  final dynamic apiGatewayName;
  final dynamic apiGatewayRefId;
  final dynamic apiGatewayRefRemark;
  final int amountItemDiscount;
  final int amountItemTaxation;
  final int amountItemSurcharge;
  final dynamic promoHeaderId;
  final dynamic promoDeductAmount;
  final dynamic promoQty;
  final dynamic promoRevenueOffset;
  final dynamic linkedItemSetRunningIndex;
  final dynamic linkedItemOrderRunningIndex;
  final dynamic linkedItemId;
  final bool isTxOnHold;
  final bool isVariance;
  final dynamic groupHeaderId;
  final dynamic groupBatchName;
  final dynamic discountId;
  final dynamic discountName;
  final dynamic apiGatewayRefCode;
  final String sopLookupPath;
  final int orderSourceTypeId;
  final dynamic subDepartmentId;
  final dynamic subDepartmentName;
  final dynamic department;
  final dynamic itemCategory;
  final dynamic itemMaster;
  final dynamic reason;
  final dynamic shop;
  final dynamic txSalesDetailNavigation;
  final dynamic txSalesHeader;
  final dynamic txSalesHeaderNavigation;
  final dynamic user;
  final dynamic user1;
  final dynamic user2;
  final dynamic userNavigation;
  final List<dynamic> inverseTxSalesDetailNavigation;
  final List<dynamic> rawMaterialTxSalesDetail;
  final List<dynamic> txSalesDetailLog;

  TxSalesDetail({
    required this.categoryName,
    required this.isPriceInPercentage,
    required this.departmentRevenueAmount,
    required this.promoCode,
    required this.promoName,
    required this.txSalesDetailId,
    required this.accountId,
    required this.txSalesHeaderId,
    required this.previousTxSalesHeaderId,
    required this.seqNo,
    required this.isSubItem,
    required this.isModifier,
    required this.parentTxSalesDetailId,
    required this.subItemLevel,
    required this.itemPath,
    required this.itemSetRunningIndex,
    required this.itemOrderRunningIndex,
    required this.orderDateTime,
    required this.orderUserId,
    required this.orderUserName,
    required this.itemId,
    required this.categoryId,
    required this.itemCode,
    required this.itemName,
    required this.itemNameAlt2,
    required this.qty,
    required this.price,
    required this.amount,
    required this.enabled,
    required this.voided,
    required this.printedKitchen,
    required this.printedKitchenByUserId,
    required this.printedKitchenByUserName,
    required this.printedKitchenDateTime,
    required this.disabledReasonId,
    required this.disabledReasonDesc,
    required this.disabledByUserId,
    required this.disabledByUserName,
    required this.disabledDateTime,
    required this.chaseCount,
    required this.chaseUserId,
    required this.chaseUserName,
    required this.chaseDateTime,
    required this.createdDate,
    required this.createdBy,
    required this.modifiedDate,
    required this.modifiedBy,
    required this.isPromoComboItem,
    required this.shopId,
    required this.itemNameAlt,
    required this.itemNameAl3,
    required this.itemNameAl4,
    required this.itemPosName,
    required this.itemPosNameAlt,
    required this.departmentId,
    required this.departmentName,
    required this.isPointPaidItem,
    required this.amountPoint,
    required this.point,
    required this.isNonTaxableItem,
    required this.isItemOnHold,
    required this.itemOnHoldDateTime,
    required this.itemOnHoldUserId,
    required this.itemOnHoldUserName,
    required this.isItemFired,
    required this.itemFiredDateTime,
    required this.itemFiredUserId,
    required this.itemFiredUserName,
    required this.takeawaySurcharge,
    required this.isItemShowInKitchenChecklist,
    required this.isPrepaidRechargeItem,
    required this.apiGatewayName,
    required this.apiGatewayRefId,
    required this.apiGatewayRefRemark,
    required this.amountItemDiscount,
    required this.amountItemTaxation,
    required this.amountItemSurcharge,
    required this.promoHeaderId,
    required this.promoDeductAmount,
    required this.promoQty,
    required this.promoRevenueOffset,
    required this.linkedItemSetRunningIndex,
    required this.linkedItemOrderRunningIndex,
    required this.linkedItemId,
    required this.isTxOnHold,
    required this.isVariance,
    required this.groupHeaderId,
    required this.groupBatchName,
    required this.discountId,
    required this.discountName,
    required this.apiGatewayRefCode,
    required this.sopLookupPath,
    required this.orderSourceTypeId,
    required this.subDepartmentId,
    required this.subDepartmentName,
    required this.department,
    required this.itemCategory,
    required this.itemMaster,
    required this.reason,
    required this.shop,
    required this.txSalesDetailNavigation,
    required this.txSalesHeader,
    required this.txSalesHeaderNavigation,
    required this.user,
    required this.user1,
    required this.user2,
    required this.userNavigation,
    required this.inverseTxSalesDetailNavigation,
    required this.rawMaterialTxSalesDetail,
    required this.txSalesDetailLog,
  });

  factory TxSalesDetail.fromJson(Map<String, dynamic> json) => TxSalesDetail(
        categoryName: categoryNameValues.map[json["categoryName"]]!,
        isPriceInPercentage: json["isPriceInPercentage"],
        departmentRevenueAmount: json["departmentRevenueAmount"],
        promoCode: json["promoCode"],
        promoName: json["promoName"],
        txSalesDetailId: json["txSalesDetailId"],
        accountId: json["accountId"],
        txSalesHeaderId: json["txSalesHeaderId"],
        previousTxSalesHeaderId: json["previousTxSalesHeaderId"],
        seqNo: json["seqNo"],
        isSubItem: json["isSubItem"],
        isModifier: json["isModifier"],
        parentTxSalesDetailId: json["parentTxSalesDetailId"],
        subItemLevel: json["subItemLevel"],
        itemPath: json["itemPath"],
        itemSetRunningIndex: json["itemSetRunningIndex"],
        itemOrderRunningIndex: json["itemOrderRunningIndex"],
        orderDateTime: DateTime.parse(json["orderDateTime"]),
        orderUserId: json["orderUserId"],
        orderUserName: cashierUserNameValues.map[json["orderUserName"]]!,
        itemId: json["itemId"],
        categoryId: json["categoryId"],
        itemCode: json["itemCode"],
        itemName: json["itemName"],
        itemNameAlt2: json["itemNameAlt2"],
        qty: json["qty"],
        price: json["price"]?.toDouble(),
        amount: json["amount"]?.toDouble(),
        enabled: json["enabled"],
        voided: json["voided"],
        printedKitchen: json["printedKitchen"],
        printedKitchenByUserId: json["printedKitchenByUserId"],
        printedKitchenByUserName:
            cashierUserNameValues.map[json["printedKitchenByUserName"]]!,
        printedKitchenDateTime: DateTime.parse(json["printedKitchenDateTime"]),
        disabledReasonId: json["disabledReasonId"],
        disabledReasonDesc: json["disabledReasonDesc"],
        disabledByUserId: json["disabledByUserId"],
        disabledByUserName: json["disabledByUserName"],
        disabledDateTime: json["disabledDateTime"],
        chaseCount: json["chaseCount"],
        chaseUserId: json["chaseUserId"],
        chaseUserName: json["chaseUserName"],
        chaseDateTime: json["chaseDateTime"],
        createdDate: DateTime.parse(json["createdDate"]),
        createdBy: cashierUserNameValues.map[json["createdBy"]]!,
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        modifiedBy: cashierUserNameValues.map[json["modifiedBy"]]!,
        isPromoComboItem: json["isPromoComboItem"],
        shopId: json["shopId"],
        itemNameAlt: json["itemNameAlt"],
        itemNameAl3: json["itemNameAl3"],
        itemNameAl4: json["itemNameAl4"],
        itemPosName: json["itemPosName"],
        itemPosNameAlt: json["itemPosNameAlt"],
        departmentId: json["departmentId"],
        departmentName: departmentNameValues.map[json["departmentName"]]!,
        isPointPaidItem: json["isPointPaidItem"],
        amountPoint: json["amountPoint"],
        point: json["point"],
        isNonTaxableItem: json["isNonTaxableItem"],
        isItemOnHold: json["isItemOnHold"],
        itemOnHoldDateTime: json["itemOnHoldDateTime"],
        itemOnHoldUserId: json["itemOnHoldUserId"],
        itemOnHoldUserName: json["itemOnHoldUserName"],
        isItemFired: json["isItemFired"],
        itemFiredDateTime: json["itemFiredDateTime"],
        itemFiredUserId: json["itemFiredUserId"],
        itemFiredUserName: json["itemFiredUserName"],
        takeawaySurcharge: json["takeawaySurcharge"],
        isItemShowInKitchenChecklist: json["isItemShowInKitchenChecklist"],
        isPrepaidRechargeItem: json["isPrepaidRechargeItem"],
        apiGatewayName: json["apiGatewayName"],
        apiGatewayRefId: json["apiGatewayRefId"],
        apiGatewayRefRemark: json["apiGatewayRefRemark"],
        amountItemDiscount: json["amountItemDiscount"],
        amountItemTaxation: json["amountItemTaxation"],
        amountItemSurcharge: json["amountItemSurcharge"],
        promoHeaderId: json["promoHeaderId"],
        promoDeductAmount: json["promoDeductAmount"],
        promoQty: json["promoQty"],
        promoRevenueOffset: json["promoRevenueOffset"],
        linkedItemSetRunningIndex: json["linkedItemSetRunningIndex"],
        linkedItemOrderRunningIndex: json["linkedItemOrderRunningIndex"],
        linkedItemId: json["linkedItemId"],
        isTxOnHold: json["isTxOnHold"],
        isVariance: json["isVariance"],
        groupHeaderId: json["groupHeaderId"],
        groupBatchName: json["groupBatchName"],
        discountId: json["discountId"],
        discountName: json["discountName"],
        apiGatewayRefCode: json["apiGatewayRefCode"],
        sopLookupPath: json["sopLookupPath"],
        orderSourceTypeId: json["orderSourceTypeId"],
        subDepartmentId: json["subDepartmentId"],
        subDepartmentName: json["subDepartmentName"],
        department: json["department"],
        itemCategory: json["itemCategory"],
        itemMaster: json["itemMaster"],
        reason: json["reason"],
        shop: json["shop"],
        txSalesDetailNavigation: json["txSalesDetailNavigation"],
        txSalesHeader: json["txSalesHeader"],
        txSalesHeaderNavigation: json["txSalesHeaderNavigation"],
        user: json["user"],
        user1: json["user1"],
        user2: json["user2"],
        userNavigation: json["userNavigation"],
        inverseTxSalesDetailNavigation: List<dynamic>.from(
            json["inverseTxSalesDetailNavigation"].map((x) => x)),
        rawMaterialTxSalesDetail:
            List<dynamic>.from(json["rawMaterialTxSalesDetail"].map((x) => x)),
        txSalesDetailLog:
            List<dynamic>.from(json["txSalesDetailLog"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "categoryName": categoryNameValues.reverse[categoryName],
        "isPriceInPercentage": isPriceInPercentage,
        "departmentRevenueAmount": departmentRevenueAmount,
        "promoCode": promoCode,
        "promoName": promoName,
        "txSalesDetailId": txSalesDetailId,
        "accountId": accountId,
        "txSalesHeaderId": txSalesHeaderId,
        "previousTxSalesHeaderId": previousTxSalesHeaderId,
        "seqNo": seqNo,
        "isSubItem": isSubItem,
        "isModifier": isModifier,
        "parentTxSalesDetailId": parentTxSalesDetailId,
        "subItemLevel": subItemLevel,
        "itemPath": itemPath,
        "itemSetRunningIndex": itemSetRunningIndex,
        "itemOrderRunningIndex": itemOrderRunningIndex,
        "orderDateTime": orderDateTime.toIso8601String(),
        "orderUserId": orderUserId,
        "orderUserName": cashierUserNameValues.reverse[orderUserName],
        "itemId": itemId,
        "categoryId": categoryId,
        "itemCode": itemCode,
        "itemName": itemName,
        "itemNameAlt2": itemNameAlt2,
        "qty": qty,
        "price": price,
        "amount": amount,
        "enabled": enabled,
        "voided": voided,
        "printedKitchen": printedKitchen,
        "printedKitchenByUserId": printedKitchenByUserId,
        "printedKitchenByUserName":
            cashierUserNameValues.reverse[printedKitchenByUserName],
        "printedKitchenDateTime": printedKitchenDateTime.toIso8601String(),
        "disabledReasonId": disabledReasonId,
        "disabledReasonDesc": disabledReasonDesc,
        "disabledByUserId": disabledByUserId,
        "disabledByUserName": disabledByUserName,
        "disabledDateTime": disabledDateTime,
        "chaseCount": chaseCount,
        "chaseUserId": chaseUserId,
        "chaseUserName": chaseUserName,
        "chaseDateTime": chaseDateTime,
        "createdDate": createdDate.toIso8601String(),
        "createdBy": cashierUserNameValues.reverse[createdBy],
        "modifiedDate": modifiedDate.toIso8601String(),
        "modifiedBy": cashierUserNameValues.reverse[modifiedBy],
        "isPromoComboItem": isPromoComboItem,
        "shopId": shopId,
        "itemNameAlt": itemNameAlt,
        "itemNameAl3": itemNameAl3,
        "itemNameAl4": itemNameAl4,
        "itemPosName": itemPosName,
        "itemPosNameAlt": itemPosNameAlt,
        "departmentId": departmentId,
        "departmentName": departmentNameValues.reverse[departmentName],
        "isPointPaidItem": isPointPaidItem,
        "amountPoint": amountPoint,
        "point": point,
        "isNonTaxableItem": isNonTaxableItem,
        "isItemOnHold": isItemOnHold,
        "itemOnHoldDateTime": itemOnHoldDateTime,
        "itemOnHoldUserId": itemOnHoldUserId,
        "itemOnHoldUserName": itemOnHoldUserName,
        "isItemFired": isItemFired,
        "itemFiredDateTime": itemFiredDateTime,
        "itemFiredUserId": itemFiredUserId,
        "itemFiredUserName": itemFiredUserName,
        "takeawaySurcharge": takeawaySurcharge,
        "isItemShowInKitchenChecklist": isItemShowInKitchenChecklist,
        "isPrepaidRechargeItem": isPrepaidRechargeItem,
        "apiGatewayName": apiGatewayName,
        "apiGatewayRefId": apiGatewayRefId,
        "apiGatewayRefRemark": apiGatewayRefRemark,
        "amountItemDiscount": amountItemDiscount,
        "amountItemTaxation": amountItemTaxation,
        "amountItemSurcharge": amountItemSurcharge,
        "promoHeaderId": promoHeaderId,
        "promoDeductAmount": promoDeductAmount,
        "promoQty": promoQty,
        "promoRevenueOffset": promoRevenueOffset,
        "linkedItemSetRunningIndex": linkedItemSetRunningIndex,
        "linkedItemOrderRunningIndex": linkedItemOrderRunningIndex,
        "linkedItemId": linkedItemId,
        "isTxOnHold": isTxOnHold,
        "isVariance": isVariance,
        "groupHeaderId": groupHeaderId,
        "groupBatchName": groupBatchName,
        "discountId": discountId,
        "discountName": discountName,
        "apiGatewayRefCode": apiGatewayRefCode,
        "sopLookupPath": sopLookupPath,
        "orderSourceTypeId": orderSourceTypeId,
        "subDepartmentId": subDepartmentId,
        "subDepartmentName": subDepartmentName,
        "department": department,
        "itemCategory": itemCategory,
        "itemMaster": itemMaster,
        "reason": reason,
        "shop": shop,
        "txSalesDetailNavigation": txSalesDetailNavigation,
        "txSalesHeader": txSalesHeader,
        "txSalesHeaderNavigation": txSalesHeaderNavigation,
        "user": user,
        "user1": user1,
        "user2": user2,
        "userNavigation": userNavigation,
        "inverseTxSalesDetailNavigation":
            List<dynamic>.from(inverseTxSalesDetailNavigation.map((x) => x)),
        "rawMaterialTxSalesDetail":
            List<dynamic>.from(rawMaterialTxSalesDetail.map((x) => x)),
        "txSalesDetailLog": List<dynamic>.from(txSalesDetailLog.map((x) => x)),
      };
}

enum CategoryName { BREAKFAST, DINNER, LUNCH }

final categoryNameValues = EnumValues({
  "Breakfast": CategoryName.BREAKFAST,
  "Dinner": CategoryName.DINNER,
  "Lunch": CategoryName.LUNCH
});

enum DepartmentName { KITCHEN }

final departmentNameValues = EnumValues({"Kitchen": DepartmentName.KITCHEN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
