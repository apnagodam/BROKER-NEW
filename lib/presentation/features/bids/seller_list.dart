import 'package:ag_broker/domain/entities/trade_list_model.dart';
import 'package:ag_broker/presentation/common/edit_bids.dart';
import 'package:ag_broker/presentation/providers/sbt_provider.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerList extends ConsumerWidget {
  const SellerList({
    super.key,
    required this.data,
    required this.index,
    required this.productId,
    required this.commodityId,
    required this.commodityName,
    required this.districtName,
  });
  final SellerDatum data;
  final String commodityId;
  final int index;
  final productId;
  final String commodityName;
  final String districtName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final sellPriceController = TextEditingController();
    final sellWeightController = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Text(localizations.seller, textAlign: TextAlign.start),
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
                  '${(data.userName ?? "").isEmpty ? "${localizations.seller} ${index + 1}" : data.userName}',
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Text('${data.qty ?? "0.0"}', textAlign: TextAlign.start),
              ),
              Expanded(child: Text('${data.rate ?? "0.0"}')),
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: data.type.toString() == "1",
                child: Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    itemBuilder: (ctx) => [
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
                        onTap: () {
                          sellPriceController.text = '${data.rate ?? "0.0"}';
                          sellWeightController.text = '${data.qty ?? "0.0"}';
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            builder: (bottomsheetContext) => EditBidsScreen(
                              sbtData: null,
                              sbtSellData: data,
                              productId: productId,
                              type: "2",
                              commodityId: commodityId,
                              commodityName: commodityName,
                              districtName: districtName,
                            ),
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
                              .watch(sbtStateProvider.notifier)
                              .deleteBids(productId, "${data.tradeId}");
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
