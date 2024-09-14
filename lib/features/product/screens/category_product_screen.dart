import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/product_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/web_product_shimmer_widget.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/product/widgets/category_cart_title_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../splash/providers/splash_provider.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryId;
  final String? subCategoryName;
  const CategoryProductScreen({
    Key? key,
    required this.categoryId,
    this.subCategoryName,
  }) : super(key: key);

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  void _loadData(BuildContext context) async {
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    if (categoryProvider.parentProductList == null &&
        categoryProvider.categoryAllProductList == null) {
      categoryProvider.getCategory(int.tryParse(widget.categoryId), context);

      categoryProvider.getSubCategoryList(context, widget.categoryId);
      categoryProvider.initCategoryProductList(widget.categoryId);
    }
  }

  @override
  void initState() {
    _loadData(context);
    super.initState();
  }

  String getCategoryImage(int categoryId) {
    var categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    var categoryList = categoryProvider.categoryList;
    var splashProvider = Provider.of<SplashProvider>(context, listen: false);

    if (categoryList != null &&
        categoryProvider.categoryAllProductList != null) {
      for (var category in categoryList) {
        if (category.id == categoryId) {
          return '${splashProvider.baseUrls?.categoryImageUrl}/${category.image}';
        }
      }
    }
    if (categoryProvider.parentProductList != null) {
      for (var category in categoryProvider.parentList!) {
        if (category.id == categoryId) {
          return '${AppConstants.imageBaseUrl}${category.image}';
        }
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    //     void _loadData(BuildContext context) async {
    //   final CategoryProvider categoryProvider =
    //       Provider.of<CategoryProvider>(context, listen: false);
    //   if (categoryProvider.selectedCategoryIndex == -1 &&
    //       categoryProvider.parentProductList == null) {
    //     categoryProvider.getCategory(int.tryParse(widget.categoryId), context);

    //     categoryProvider.getSubCategoryList(context, widget.categoryId);
    //     categoryProvider.initCategoryProductList(widget.categoryId);
    //   }
    // }
    // final CategoryProvider categoryProvider =
    //     Provider.of<CategoryProvider>(context, listen: false);

    String appBarText = 'Sub Categories';
    appBarText = widget.subCategoryName ?? appBarText;
    // if (widget.subCategoryName != null && widget.subCategoryName != 'null') {
    //   appBarText = widget.subCategoryName ?? appBarText;
    // } else {
    //   appBarText = categoryProvider.categoryModel?.name ?? 'name';
    // }
    // categoryProvider.initializeAllSortBy(context);
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
          : CustomAppBarWidget(
              title: appBarText,
              isCenter: false,
              isElevation: true,
              fromCategory: true,
            )) as PreferredSizeWidget?,
      body: Consumer<CategoryProvider>(
        builder: (context, productProvider, child) {
          return Column(
            crossAxisAlignment: ResponsiveHelper.isDesktop(context)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 125, //70
                width: Dimensions.webScreenWidth,
                child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    return categoryProvider.categoryAllProductList != null
                        ? categoryProvider.subCategoryList!.isNotEmpty
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                height: 32,
                                child: SizedBox(
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? 1170
                                      : MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: Dimensions
                                                        .paddingSizeDefault),
                                                child: InkWell(
                                                  onTap: () {
                                                    categoryProvider
                                                        .onChangeSelectIndex(
                                                            -1);
                                                    productProvider
                                                        .initCategoryProductList(
                                                      widget.categoryId,
                                                    );
                                                  },
                                                  hoverColor:
                                                      Colors.transparent,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: Dimensions
                                                                .paddingSizeSmall,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: categoryProvider
                                                                        .selectedCategoryIndex ==
                                                                    -1
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : ColorResources
                                                                    .getGreyColor(
                                                                        context),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                          ),
                                                          child: Container(
                                                            width: mediaQuery
                                                                    .width *
                                                                0.2,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: categoryProvider
                                                                          .selectedCategoryIndex ==
                                                                      -1
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : ColorResources
                                                                      .getGreyColor(
                                                                          context),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                  // '${AppConstants.imageBaseUrl}${categoryProvider.subCategoryList?[0].image}'),
                                                                  getCategoryImage(
                                                                    int.parse(
                                                                      widget
                                                                          .categoryId,
                                                                    ),
                                                                  ),
                                                                ),
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        getTranslated(
                                                            'all', context),
                                                        style: poppinsRegular
                                                            .copyWith(
                                                          color: categoryProvider
                                                                      .selectedCategoryIndex ==
                                                                  -1
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor //canvasColor
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              //sub category list
                                              ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: categoryProvider
                                                    .subCategoryList!.length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      categoryProvider
                                                          .onChangeSelectIndex(
                                                              index);

                                                      productProvider
                                                          .initCategoryProductList(
                                                        '${categoryProvider.subCategoryList![index].id}',
                                                      );
                                                    },
                                                    hoverColor:
                                                        Colors.transparent,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              right: Dimensions
                                                                  .paddingSizeSmall,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        4),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: categoryProvider
                                                                          .selectedCategoryIndex ==
                                                                      index
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : ColorResources
                                                                      .getGreyColor(
                                                                          context),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                            ),
                                                            child: Container(
                                                              width: mediaQuery
                                                                      .width *
                                                                  0.2,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: categoryProvider
                                                                            .selectedCategoryIndex ==
                                                                        index
                                                                    ? Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                    : ColorResources
                                                                        .getGreyColor(
                                                                            context),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    '${AppConstants.imageBaseUrl}${categoryProvider.subCategoryList![index].image}',
                                                                  ),
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          categoryProvider
                                                                  .subCategoryList?[
                                                                      index]
                                                                  .name ??
                                                              '',
                                                          style: poppinsRegular
                                                              .copyWith(
                                                            color: categoryProvider
                                                                        .selectedCategoryIndex ==
                                                                    index
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor //canvasColor
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // if(ResponsiveHelper.isDesktop(context)) Spacer(),
                                      if (ResponsiveHelper.isDesktop(context))
                                        PopupMenuButton(
                                          elevation: 20,
                                          enabled: true,
                                          icon: Icon(Icons.more_vert,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color),
                                          onSelected: (dynamic value) {
                                            int index = categoryProvider
                                                .allSortBy
                                                .indexOf(value);

                                            categoryProvider
                                                .sortCategoryProduct(index);
                                          },
                                          itemBuilder: (context) {
                                            return categoryProvider.allSortBy
                                                .map(
                                              (choice) {
                                                return PopupMenuItem(
                                                  value: choice,
                                                  child: Text(
                                                    getTranslated(
                                                        choice, context),
                                                  ),
                                                );
                                              },
                                            ).toList();
                                          },
                                        )
                                    ],
                                  ),
                                ),
                              )
                            // : const SubcategoryTitleShimmer()
                            : Padding(
                                padding: const EdgeInsets.only(
                                  left: Dimensions.paddingSizeDefault,
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  hoverColor: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: Dimensions.paddingSizeSmall,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          decoration: BoxDecoration(
                                            color: categoryProvider
                                                        .selectedCategoryIndex ==
                                                    -1
                                                ? Theme.of(context).primaryColor
                                                : ColorResources.getGreyColor(
                                                    context),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Container(
                                            width: mediaQuery.width * 0.2,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    getCategoryImage(
                                                      int.parse(
                                                        widget.categoryId,
                                                      ),
                                                    ),
                                                  ),
                                                  fit: BoxFit.fitWidth,
                                                )),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                Dimensions.paddingSizeDefault *
                                                    1.8),
                                        child: Text(
                                          getTranslated('all', context),
                                          style: poppinsRegular.copyWith(
                                            color: categoryProvider
                                                        .selectedCategoryIndex ==
                                                    -1
                                                ? Theme.of(context)
                                                    .primaryColor //canvasColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                        : productProvider.parentProductList != null
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: Dimensions.paddingSizeDefault,
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  hoverColor: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: mediaQuery.width * 0.2,
                                          margin: const EdgeInsets.only(
                                            right: Dimensions.paddingSizeSmall,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  getCategoryImage(
                                                    int.parse(
                                                      widget.categoryId,
                                                    ),
                                                  ),
                                                ),
                                                fit: BoxFit.fitWidth,
                                              )),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right:
                                                Dimensions.paddingSizeDefault *
                                                    1.8),
                                        child: Text(
                                          getTranslated('all', context),
                                          style: poppinsRegular.copyWith(
                                            color: categoryProvider
                                                        .selectedCategoryIndex ==
                                                    -1
                                                ? Theme.of(context)
                                                    .primaryColor //canvasColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SubcategoryTitleShimmer();
                  },
                ),
              ),
              Expanded(
                child: productProvider.parentProductList == null
                    ? CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: productProvider
                                    .subCategoryProductList.isNotEmpty
                                ? Center(
                                    child: SizedBox(
                                      width: Dimensions.webScreenWidth,
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing:
                                              ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? 13
                                                  : 10,
                                          mainAxisSpacing:
                                              ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? 13
                                                  : 10,
                                          childAspectRatio:
                                              ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? (1 / 1.4)
                                                  : (1 / 1.8),
                                          crossAxisCount:
                                              ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? 5
                                                  : 2,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeSmall,
                                            vertical:
                                                Dimensions.paddingSizeSmall),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: productProvider
                                            .subCategoryProductList.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ProductWidget(
                                            product: productProvider
                                                .subCategoryProductList[index],
                                            isCenter: true,
                                            isGrid: true,
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: SizedBox(
                                      width: Dimensions.webScreenWidth,
                                      child: (productProvider.hasData ?? false)
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .paddingSizeSmall),
                                              child: _ProductShimmer(
                                                isEnabled: true,
                                              ),
                                            )
                                          : NoDataWidget(
                                              isFooter: false,
                                              title: getTranslated(
                                                  'not_product_found',
                                                  context)),
                                    ),
                                  ),
                          ),
                          const FooterWebWidget(footerType: FooterType.sliver),
                        ],
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            //don't use ==null because can't be null
                            child: productProvider.parentProductList!.isNotEmpty
                                ? Center(
                                    child: SizedBox(
                                      width: Dimensions.webScreenWidth,
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing:
                                              ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? 13
                                                  : 10,
                                          mainAxisSpacing:
                                              ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? 13
                                                  : 10,
                                          childAspectRatio:
                                              ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? (1 / 1.4)
                                                  : (1 / 1.8),
                                          crossAxisCount:
                                              ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? 5
                                                  : 2,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeSmall,
                                            vertical:
                                                Dimensions.paddingSizeSmall),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: productProvider
                                            .parentProductList!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ProductWidget(
                                            product: productProvider
                                                .parentProductList![index],
                                            isCenter: true,
                                            isGrid: true,
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : productProvider.isParentProductLoading
                                    // shimmer
                                    ? const Center(
                                        child: SizedBox(
                                          width: Dimensions.webScreenWidth,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                            child: _ProductShimmer(
                                                isEnabled: true),
                                          ),
                                        ),
                                      )
                                    //empty List
                                    : NoDataWidget(
                                        isFooter: false,
                                        title: getTranslated(
                                            'not_product_found', context),
                                      ),
                          ),
                          const FooterWebWidget(footerType: FooterType.sliver),
                        ],
                      ),
              ),
              const CategoryCartTitleWidget(),
            ],
          );
        },
      ),
    );
  }
}

class SubcategoryTitleShimmer extends StatelessWidget {
  const SubcategoryTitleShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 20),
      itemCount: 5,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge,
                  vertical: Dimensions.paddingSizeExtraSmall),
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.titleLarge!.color,
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 20,
                width: 60,
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorResources.getGreyColor(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProductShimmer extends StatelessWidget {
  final bool isEnabled;

  const _ProductShimmer({Key? key, required this.isEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
        childAspectRatio:
            ResponsiveHelper.isDesktop(context) ? (1 / 1.4) : (1 / 1.6),
        crossAxisCount: ResponsiveHelper.isDesktop(context)
            ? 5
            : ResponsiveHelper.isTab(context)
                ? 2
                : 2,
      ),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) =>
          const WebProductShimmerWidget(isEnabled: true),
      itemCount: 20,
    );
  }
}
