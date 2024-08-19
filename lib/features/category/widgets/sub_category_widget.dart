import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';
import '../../../helper/route_helper.dart';
import '../providers/category_provider.dart';

class SubCategoryWidget extends StatelessWidget {
  const SubCategoryWidget({
    Key? key,
    required this.index,
    required this.image,
  }) : super(key: key);
  final int index;
  final String image;

  @override
  Widget build(BuildContext context) {
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        categoryProvider.parentProductList = null;
        Navigator.of(context).pushNamed(
          RouteHelper.getCategoryProductsRoute(
            categoryId:
                '${categoryProvider.categoryList![categoryProvider.categoryIndex].id}',
          ),
        );

        categoryProvider.onChangeSelectIndex(index);
        categoryProvider.initCategoryProductList(
            '${categoryProvider.subCategoryList![index].id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: double.maxFinite,
              height: 30,
              child: Text(
                categoryProvider.subCategoryList![index].name!,
                style: poppinsRegular.copyWith(
                  color: categoryProvider.selectedCategoryIndex == index
                      ? Theme.of(context).primaryColor //canvasColor
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
