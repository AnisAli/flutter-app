import 'package:get/get.dart';

import '../../../exports/index.dart';

class VendorCard extends StatelessWidget {
  final VendorModel vendor;
  final bool? showActiveToggle;

  const VendorCard(
      {Key? key, required this.vendor, this.showActiveToggle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade400, width: 0.5))),
      child: Card(
        borderOnForeground: false,
        elevation: 0,
        margin: const EdgeInsets.all(0),
        color: context.scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (showActiveToggle ?? false) _buildActiveToggle(context),
            _buildVendorInfo(context),
            _buildIcons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("\$${vendor.openBalance?.toStringAsFixed(2) ?? '0.00'}",
              style: context.titleLarge.copyWith(
                fontWeight: FontWeight.w400,
                fontFamily: AppStrings.WORK_SANS,
                letterSpacing: 1,
              )),
          const SpaceH12(),
          Row(
            children: [
              if (vendor.phoneNo?.isNotEmpty == true)
                Icon(
                  CupertinoIcons.phone,
                  size: Sizes.ICON_SIZE_20,
                  color: context.iconColor,
                ),
              if (vendor.isTaxable == true)
                Icon(
                  Icons.account_balance_outlined,
                  size: Sizes.ICON_SIZE_20,
                  color: context.iconColor,
                ),
              if (vendor.email?.isNotEmpty == true)
                Icon(
                  Icons.alternate_email,
                  size: Sizes.ICON_SIZE_20,
                  color: context.iconColor,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded _buildVendorInfo(BuildContext context) {
    String address = "";
    if (vendor.address1 != null) {
      address += "${vendor.address1?.toUpperCase()}";
    }
    if (vendor.city != null) {
      address +=
          "${address.isNotEmpty ? ", " : ""}${vendor.city?.toUpperCase()}";
    }
    if (vendor.state != null) {
      address +=
          "${address.isNotEmpty ? ", " : ""}${vendor.state?.toUpperCase()}";
    }
    if (vendor.postalCode != null) {
      address +=
          "${address.isNotEmpty ? ", " : ""}${vendor.postalCode?.toUpperCase()}";
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vendor.vendorName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodyText1.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            const SpaceH4(),
            Text(
              vendor.companyName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodyText2.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            const SpaceH12(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    address,
                    style: context.captionLarge.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SpaceH2(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveToggle(BuildContext context) {
    return Container(
      color:
          vendor.isActive ?? false ? Colors.transparent : Colors.red.shade800,
      height: double.infinity,
      width: Sizes.WIDTH_6,
    );
  }
}
