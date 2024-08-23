import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/providers/localization_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/title_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/home/providers/banner_provider.dart';
import 'package:flutter_grocery/features/home/providers/flash_deal_provider.dart';
import 'package:flutter_grocery/features/home/widgets/all_product_list_widget.dart';
import 'package:flutter_grocery/features/home/widgets/banners_widget.dart';
import 'package:flutter_grocery/features/home/widgets/category_web_widget.dart';
import 'package:flutter_grocery/features/home/widgets/flash_deal_home_card_widget.dart';
import 'package:flutter_grocery/features/home/widgets/home_item_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:provider/provider.dart';
import '../../../utill/app_constants.dart';
import '../../category/widgets/parent_screen.dart';
import '../widgets/partners_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<void> loadData(bool reload, BuildContext context,
      {bool fromLanguage = false}) async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final flashDealProvider =
        Provider.of<FlashDealProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final withLListProvider =
        Provider.of<WishListProvider>(context, listen: false);
    final localizationProvider =
        Provider.of<LocalizationProvider>(context, listen: false);

    ConfigModel config =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    if (reload) {
      Provider.of<SplashProvider>(context, listen: false).initConfig();
    }
    if (fromLanguage &&
        (authProvider.isLoggedIn() || config.isGuestCheckout!)) {
      localizationProvider.changeLanguage();
    }
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(context, reload);

    Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context, reload);

    if (productProvider.dailyProductModel == null) {
      productProvider.getItemList(1,
          isUpdate: false, productType: ProductType.dailyItem);
    }

    if (productProvider.featuredProductModel == null) {
      productProvider.getItemList(1,
          isUpdate: false, productType: ProductType.featuredItem);
    }

    if (productProvider.mostViewedProductModel == null) {
      productProvider.getItemList(1,
          isUpdate: false, productType: ProductType.mostReviewed);
    }

    productProvider.getAllProductList(1, reload, isUpdate: false);

    if (authProvider.isLoggedIn()) {
      withLListProvider.getWishListProduct();
    }

    if ((config.flashDealProductStatus ?? false) &&
        flashDealProvider.flashDealModel == null) {
      flashDealProvider.getFlashDealProducts(1, isUpdate: false);
    }

    // Parent Category
    Provider.of<CategoryProvider>(context, listen: false).getParentList(
      context,
      reload,
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeApp(); // Automatically call this function when the app starts
  }

  void _initializeApp() {
    // Using addPostFrameCallback to show dialog after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showImageDialog(context); // Show the pop-up with an image
    });
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var mediaQuery = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: mediaQuery.height * 0.6,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: AppConstants.popupImage,
                    fit: BoxFit.fill,
                    height: mediaQuery.height * 0.5,
                    width: double.infinity,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  // child: Image.network(
                  //   AppConstants.popupImage, // Replace with your image URL
                  //   fit: BoxFit.fill,
                  //   height: mediaQuery.height * 0.5,
                  //   width: double.infinity,
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await HomeScreen.loadData(true, context);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Scaffold(
            appBar: ResponsiveHelper.isDesktop(context)
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(120),
                    child: WebAppBarWidget())
                : null,
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webScreenWidth,
                      child: Column(
                        children: [
                          // Banner
                          Consumer<BannerProvider>(
                              builder: (context, banner, child) {
                            return (banner.bannerList?.isEmpty ?? false)
                                ? const SizedBox()
                                : const BannersWidget();
                          }),

                          /// Category
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.paddingSizeLarge
                                  : Dimensions.paddingSizeSmall,
                            ),
                            child: const CategoryWidget(),
                          ),

                          //parteners
                          TitleWidget(
                              title: getTranslated('our_partners', context),
                              onTap: () {
                                categoryProvider.getParentList(context, false);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ParentScreen(
                                        subCategoryName: getTranslated(
                                            'our_partners', context),
                                      );
                                    },
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: PartnersWidget(),
                          ),

                          /// Flash Deal
                          if (splashProvider
                                  .configModel?.flashDealProductStatus ??
                              false)
                            const FlashDealHomeCardWidget(),

                          Consumer<ProductProvider>(
                              builder: (context, productProvider, child) {
                            bool isDalyProduct =
                                (productProvider.dailyProductModel == null ||
                                    (productProvider.dailyProductModel?.products
                                            ?.isNotEmpty ??
                                        false));
                            bool isFeaturedProduct =
                                (productProvider.featuredProductModel == null ||
                                    (productProvider.featuredProductModel
                                            ?.products?.isNotEmpty ??
                                        false));
                            bool isMostViewedProduct =
                                (productProvider.mostViewedProductModel ==
                                        null ||
                                    (productProvider.mostViewedProductModel
                                            ?.products?.isNotEmpty ??
                                        false));

                            return Column(children: [
                              isDalyProduct
                                  ? Column(children: [
                                      TitleWidget(
                                          title: getTranslated(
                                              'daily_needs', context),
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              RouteHelper.getHomeItemRoute(
                                                  ProductType.dailyItem),
                                            );
                                          }),
                                      HomeItemWidget(
                                          productList: productProvider
                                              .dailyProductModel?.products),
                                    ])
                                  : const SizedBox(),
                              if ((splashProvider
                                          .configModel?.featuredProductStatus ??
                                      false) &&
                                  isFeaturedProduct)
                                Column(children: [
                                  TitleWidget(
                                      title: getTranslated(
                                          ProductType.featuredItem, context),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteHelper.getHomeItemRoute(
                                                ProductType.featuredItem));
                                      }),
                                  HomeItemWidget(
                                      productList: productProvider
                                          .featuredProductModel?.products,
                                      isFeaturedItem: true),
                                ]),
                              if ((splashProvider.configModel
                                          ?.mostReviewedProductStatus ??
                                      false) &&
                                  isMostViewedProduct)
                                Column(children: [
                                  TitleWidget(
                                      title: getTranslated(
                                          ProductType.mostReviewed, context),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteHelper.getHomeItemRoute(
                                                ProductType.mostReviewed));
                                      }),
                                  HomeItemWidget(
                                      productList: productProvider
                                          .mostViewedProductModel?.products),
                                ])
                            ]);
                          }),

                          ResponsiveHelper.isMobilePhone()
                              ? const SizedBox(height: 10)
                              : const SizedBox.shrink(),

                          AllProductListWidget(
                              scrollController: scrollController),
                        ],
                      ),
                    ),
                  ),
                ),
                const FooterWebWidget(footerType: FooterType.sliver),
              ],
            ),
          ),
        );
      },
    );
  }
}
