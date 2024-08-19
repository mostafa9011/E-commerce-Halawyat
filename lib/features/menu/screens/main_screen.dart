import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_grocery/features/menu/domain/models/custom_drawer_controller_model.dart';
import 'package:flutter_grocery/common/enums/html_type_enum.dart';
import 'package:flutter_grocery/features/menu/domain/models/main_screen_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/third_party_chat_widget.dart';
import 'package:flutter_grocery/features/address/screens/address_list_screen.dart';
import 'package:flutter_grocery/features/cart/screens/cart_screen.dart';
import 'package:flutter_grocery/features/category/screens/all_categories_screen.dart';
import 'package:flutter_grocery/features/chat/screens/chat_screen.dart';
import 'package:flutter_grocery/features/coupon/screens/coupon_screen.dart';
import 'package:flutter_grocery/features/home/screens/home_screens.dart';
import 'package:flutter_grocery/features/html/screens/html_viewer_screen.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/screens/loyalty_screen.dart';
import 'package:flutter_grocery/features/order/screens/order_list_screen.dart';
import 'package:flutter_grocery/features/order/screens/order_search_screen.dart';
import 'package:flutter_grocery/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:flutter_grocery/features/menu/screens/setting_screen.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/screens/wallet_screen.dart';
import 'package:flutter_grocery/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_asset_image_widget.dart';
import '../../../common/widgets/custom_image_widget.dart';
import '../../../utill/color_resources.dart';
import '../../auth/providers/auth_provider.dart';
import '../../notification/screens/notification_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../widgets/menu_list_web_widget.dart';
import '../widgets/sign_out_dialog_widget.dart';

List<MainScreenModel> screenList = [
  // MainScreenModel(const HomeScreen(), 'home', Images.home),
  // MainScreenModel(const AllCategoriesScreen(), 'all_categories', Images.list),
  MainScreenModel(const CartScreen(), 'shopping_bag', Images.orderBag),
  MainScreenModel(const WishListScreen(), 'favourite', Images.favouriteIcon),
  MainScreenModel(const OrderListScreen(), 'my_order', Images.orderList),
  MainScreenModel(
      const OrderSearchScreen(), 'track_order', Images.orderDetails),
  MainScreenModel(const AddressListScreen(), 'address', Images.location),
  MainScreenModel(const CouponScreen(), 'coupon', Images.coupon),
  MainScreenModel(
      const ChatScreen(
        orderModel: null,
      ),
      'live_chat',
      Images.chat),
  MainScreenModel(const SettingsScreen(), 'settings', Images.settings),
  if (Provider.of<SplashProvider>(Get.context!, listen: false)
      .configModel!
      .walletStatus!)
    MainScreenModel(const WalletScreen(), 'wallet', Images.wallet),
  if (Provider.of<SplashProvider>(Get.context!, listen: false)
      .configModel!
      .loyaltyPointStatus!)
    MainScreenModel(const LoyaltyScreen(), 'loyalty_point', Images.loyaltyIcon),
  MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition),
      'terms_and_condition', Images.termsAndConditions),
  MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy),
      'privacy_policy', Images.privacyPolicy),
  MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.aboutUs),
      'about_us', Images.aboutUs),
  if (Provider.of<SplashProvider>(Get.context!, listen: false)
      .configModel!
      .returnPolicyStatus!)
    MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.returnPolicy),
        'return_policy', Images.returnPolicy),
  if (Provider.of<SplashProvider>(Get.context!, listen: false)
      .configModel!
      .refundPolicyStatus!)
    MainScreenModel(const HtmlViewerScreen(htmlType: HtmlType.refundPolicy),
        'refund_policy', Images.refundPolicy),
  if (Provider.of<SplashProvider>(Get.context!, listen: false)
      .configModel!
      .cancellationPolicyStatus!)
    MainScreenModel(
        const HtmlViewerScreen(htmlType: HtmlType.cancellationPolicy),
        'cancellation_policy',
        Images.cancellationPolicy),
  MainScreenModel(
      const HtmlViewerScreen(htmlType: HtmlType.faq), 'faq', Images.faq),
];

class MainScreen extends StatefulWidget {
  final bool isReload;
  final CustomDrawerController drawerController;

  const MainScreen(
      {Key? key, required this.drawerController, this.isReload = true})
      : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool canExit = kIsWeb;
  int _selectedIndex = 0;

  final List<Widget> _bottomNavScreens = [
    const HomeScreen(),
    const AllCategoriesScreen(),
    const NotificationScreen(),
    const ChatScreen(orderModel: null),
    const MoreScreen(),
  ];

  @override
  void initState() {
    if (widget.isReload) {
      HomeScreen.loadData(true, Get.context!);
    }
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        return CustomPopScopeWidget(
          child: Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              final referMenu = MainScreenModel(const ReferAndEarnScreen(),
                  'referAndEarn', Images.referralIcon);
              if ((splash.configModel?.referEarnStatus ?? false) &&
                  profileProvider.userInfoModel?.referCode != null &&
                  screenList[9].title != 'referAndEarn') {
                screenList
                    .removeWhere((menu) => menu.screen == referMenu.screen);
                screenList.insert(9, referMenu);
              }

              return Consumer<LocationProvider>(
                builder: (context, locationProvider, child) => InkWell(
                  onTap: () {
                    if (!ResponsiveHelper.isDesktop(context) &&
                        widget.drawerController.isOpen()) {
                      widget.drawerController.toggle();
                    }
                  },
                  child: Scaffold(
                    floatingActionButton: !ResponsiveHelper.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50.0),
                            child: ThirdPartyChatWidget(
                              configModel: splash.configModel!,
                            ),
                          )
                        : null,
                    appBar: ResponsiveHelper.isDesktop(context)
                        ? null
                        : AppBar(
                            backgroundColor: Theme.of(context).cardColor,
                            // leading: IconButton(
                            //     icon: Image.asset(Images.moreIcon,
                            //         color: Theme.of(context).primaryColor,
                            //         height: 30,
                            //         width: 30),
                            //     onPressed: () {
                            //       widget.drawerController.toggle();
                            //     }),
                            title: splash.pageIndex == 0
                                ? Row(children: [
                                    Image.asset(Images.appLogo, width: 25),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    Expanded(
                                        child: Text(
                                      AppConstants.appName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: poppinsMedium.copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                    )),
                                  ])
                                : Text(
                                    getTranslated(
                                        screenList[splash.pageIndex].title,
                                        context),
                                    style: poppinsMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).primaryColor),
                                  ),
                            actions: //splash.pageIndex == 0
                                // ?
                            [
                                    IconButton(
                                      icon: Image.asset(Images.search,
                                          color: Theme.of(context).primaryColor,
                                          width: 25),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, RouteHelper.searchProduct);
                                      },
                                    ),
                                    IconButton(
                                        icon: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Icon(Icons.shopping_cart,
                                                  color: Theme.of(context)
                                                      .hintColor
                                                      .withOpacity(isDarkTheme
                                                          ? 0.9
                                                          : 0.4),
                                                  size: 30),
                                              Positioned(
                                                top: -7,
                                                right: -2,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  child: Text(
                                                      '${Provider.of<CartProvider>(context).cartList.length}',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          fontSize: 10)),
                                                ),
                                              ),
                                            ]),
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartScreen(),));
                                        }),
                                  ],
                                // : splash.pageIndex == 2
                                //     ? [
                                //         Center(child: Consumer<CartProvider>(
                                //             builder:
                                //                 (context, cartProvider, _) {
                                //           return Text(
                                //               '${cartProvider.cartList.length} ${getTranslated('items', context)}',
                                //               style: poppinsMedium.copyWith(
                                //                   color: Theme.of(context)
                                //                       .primaryColor));
                                //         })),
                                //         const SizedBox(width: 20)
                                //       ]
                                //     : null,
                          ),
                    body: _bottomNavScreens[_selectedIndex],
                    bottomNavigationBar: BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'الرئيسية',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.list),
                          label: 'الفئات',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.notifications),
                          label: 'الاشعارات',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.chat),
                          label: 'المحادثة',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: 'الصفحة الشخصية',
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: Theme.of(context).primaryColor,
                      unselectedItemColor: Colors.grey,
                      onTap: _onItemTapped,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      body: ListView.builder(
        itemCount: screenList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [

              if (index == 0)Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) => Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(RouteHelper.profile, arguments: const ProfileScreen());
                        },
                        leading: ClipOval(
                          child: isLoggedIn ? splashProvider.baseUrls != null ?
                          CustomImageWidget(
                            placeholder: Images.profile,
                            image: '${splashProvider.baseUrls?.customerImageUrl}/${profileProvider.userInfoModel?.image}',
                            height: 50, width: 50, fit: BoxFit.cover,
                          ) : const SizedBox() : Image.asset(Images.profile, height: 50, width: 50, fit: BoxFit.cover),
                        ),
                        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                            '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                            style: poppinsRegular.copyWith(color: Provider.of<ThemeProvider>(context).darkTheme
                                ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                                : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context): Theme.of(context).primaryColor,),
                          ) : Container(height: 10, width: 150, color: ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context): Theme.of(context).canvasColor) : Text(
                            getTranslated('guest', context),
                            style: poppinsRegular.copyWith( color: Provider.of<ThemeProvider>(context).darkTheme
                                ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                                : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context): Theme.of(context).primaryColor,),
                          ),
                          if(isLoggedIn) const SizedBox(height: Dimensions.paddingSizeSmall),

                          if(isLoggedIn && profileProvider.userInfoModel != null ) Text(
                              profileProvider.userInfoModel!.phone ?? '',
                              style: poppinsRegular.copyWith(color: Provider.of<ThemeProvider>(context).darkTheme
                                  ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                                  : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context): Theme.of(context).primaryColor,)
                          ),
                        ]),
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.notifications,
                    //       color: Provider.of<ThemeProvider>(context).darkTheme
                    //           ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                    //           : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context):  Theme.of(context).canvasColor),
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, RouteHelper.notification, arguments: const NotificationScreen());
                    //   },
                    // ),
                  ],
                ),
              ),
              ListTile(
                leading: screenList[index]
                        .icon
                        .endsWith('.svg') // Check if it's an SVG file
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(
                          screenList[index].icon,
                          color: Theme.of(context)
                              .primaryColor, // Set the color of the SVG icon
                          placeholderBuilder: (BuildContext context) =>
                              const CircularProgressIndicator(), // Placeholder while loading SVG
                        ),
                      )
                    : Image.asset(
                        screenList[index].icon,
                        width: 24,
                        height: 24,
                        color: Theme.of(context).primaryColor,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error_outline,
                              size: 24, color: Colors.red);
                        },
                      ),
                title: Text(getTranslated(screenList[index].title, context)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(
                              getTranslated(screenList[index].title, context)),
                        ),
                        body: screenList[index].screen,
                      ),
                    ),
                  );
                },
              ),
              if (index == screenList.length - 1)
                ResponsiveHelper.isDesktop(context)
                    ? MenuListWebWidget(isLoggedIn: isLoggedIn)
                    : SizedBox(
                        width: Dimensions.webScreenWidth,
                        child: Consumer<SplashProvider>(
                          builder: (context, splash, child) {
                            return ListTile(
                              onTap: () {
                                if (isLoggedIn) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          const SignOutDialogWidget());
                                } else {
                                  splashProvider.setPageIndex(0);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteHelper.getLoginRoute(),
                                      (route) => false);
                                }
                              },
                              leading: CustomAssetImageWidget(
                                isLoggedIn ? Images.logOut : Images.logIn,
                                width: 25,
                                height: 25,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                getTranslated(
                                    isLoggedIn ? 'log_out' : 'login', context),
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Provider.of<ThemeProvider>(context)
                                          .darkTheme
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color
                                          ?.withOpacity(0.6)
                                      : ResponsiveHelper.isDesktop(context)
                                          ? ColorResources.getDarkColor(context)
                                          : Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      )
            ],
          );
        },
      ),
    );
  }
}
