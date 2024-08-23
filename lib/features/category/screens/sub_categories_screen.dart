import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_loader_widget.dart';
import '../../../common/widgets/no_data_widget.dart';
import '../../../localization/language_constraints.dart';
import '../providers/category_provider.dart';
import '../widgets/sub_category_widget.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({
    Key? key,
    required this.categoryId,
    this.subCategoryName,
  }) : super(key: key);
  final String categoryId;
  final String? subCategoryName;

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  void _loadData(BuildContext context) async {
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    if (categoryProvider.selectedCategoryIndex == -1) {
      // categoryProvider.getCategory(int.tryParse(widget.categoryId), context);
      categoryProvider.getSubCategoryList(context, widget.categoryId);

      // categoryProvider.initCategoryProductList(widget.categoryId);
    }
  }

  @override
  void initState() {
    _loadData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var mediaQuery = MediaQuery.of(context).size;

    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    String? appBarText = 'Sub Categories';
    if (widget.subCategoryName != null && widget.subCategoryName != 'null') {
      appBarText = widget.subCategoryName;
    } else {
      appBarText = categoryProvider.categoryModel?.name ?? 'name';
    }
    categoryProvider.initializeAllSortBy(context);
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: WebAppBarWidget(),
            )
          : CustomAppBarWidget(
              title: appBarText,
              isCenter: false,
              isElevation: true,
              fromCategory: true,
            )) as PreferredSizeWidget?,
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return categoryProvider.subcategoryLoding == false
              ? categoryProvider.subCategoryList!.isNotEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 30),
                        itemCount: categoryProvider.subCategoryList?.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return SubCategoryWidget(
                            index: index,
                            image:
                                '${AppConstants.imageBaseUrl}${categoryProvider.subCategoryList![index].image}',
                          );
                        },
                      ),
                    )
                  : NoDataWidget(
                      title: getTranslated('category_not_found', context),
                    )
              : Center(
                  child:
                      CustomLoaderWidget(color: Theme.of(context).primaryColor),
                );
        },
      ),
    );
  }
}
