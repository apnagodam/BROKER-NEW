// ignore_for_file: unnecessary_string_interpolations

import 'package:ag_broker/domain/entities/trade_list_model.dart';
import 'package:ag_broker/presentation/common/edit_bids.dart';
import 'package:ag_broker/presentation/providers/sbt_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ag_broker/l10n/app_localizations.dart';

class BuyerList extends ConsumerWidget {
  const BuyerList({
    super.key,
    required this.data,
    required this.index,
    required this.productId,
    required this.commodityId,
    required this.commodityName,
    required this.districtName,
  });

  final BuyerDatum? data;
  final int? index;
  final String productId;
  final String commodityId;
  final String commodityName;
  final String districtName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final buyPriceController = TextEditingController(text: '0');
    final buyWeightController = TextEditingController(text: '0');

    Future.delayed(Duration.zero, () {
      buyPriceController.text = data != null ? '${data!.rate}' : '0';

      buyWeightController.text = data != null ? '${data!.qty}' : '0';
    });
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   height: 30,
          //   color: ColorConstant.maingreen,
          //   child: Center(
          //       child: Text(
          //         "msg_buyerbid".tr,
          //         style: TextStyle(
          //
          //             color: Colors.white,
          //             fontSize: Adaptive.sp(16)),
          //       )),
          // ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(localizations.buyer, textAlign: TextAlign.start),
              ),
              Expanded(
                child: Text(
                  localizations.quantityQtl,
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Text(localizations.rate, textAlign: TextAlign.start),
              ),
              Text(localizations.edit, textAlign: TextAlign.start),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${(data?.userName ?? "").isEmpty ? "${localizations.buyer} ${index! + 1}" : data?.userName}',
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(child: Text('${data?.qty}', textAlign: TextAlign.start)),
              Expanded(child: Text('${data!.rate ?? "0.0"}')),
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: data?.type.toString() == "1",
                child: Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.pencil_circle_fill,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            ),
                            SizedBox(width: 10),
                            Text(
                              localizations.edit,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          buyPriceController.text = '${data?.rate ?? "0.0"}';
                          buyWeightController.text = '${data?.qty ?? "0.0"}';

                          showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            enableDrag: true,
                            builder: (context) {
                              return EditBidsScreen(
                                sbtData: data,
                                sbtSellData: null,
                                productId: productId,
                                type: "1",
                                commodityId: commodityId,
                                commodityName: commodityName,
                                districtName: districtName,
                              );
                            },
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.delete,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            ),
                            SizedBox(width: 10),
                            Text(
                              localizations.delete,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await ref
                              .read(sbtStateProvider.notifier)
                              .deleteBids(productId, "${data?.tradeId}");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
