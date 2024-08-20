import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helper/route_helper.dart';
import '../../../utill/app_constants.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';
import '../../category/providers/category_provider.dart';

class ParentItem extends StatelessWidget {
  const ParentItem({
    Key? key,
    required this.title,
    required this.image,
    required this.parentId,
  }) : super(key: key);
  final String title;
  final String image;
  final int parentId;

  @override
  Widget build(BuildContext context) {
    var categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        categoryProvider.categoryAllProductList = null;
        // log(parentId.toString());
        categoryProvider.getParentProductList(parentId.toString());

        Navigator.of(context).pushNamed(
          RouteHelper.getCategoryProductsRoute(
            categoryId: parentId.toString(),
            subCategory: title,
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage:
                  NetworkImage('${AppConstants.imageBaseUrl}$image'),
              radius: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 4),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: poppinsSemiBold.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
