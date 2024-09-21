// Pop-up image
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/custom_daialog.dart';
import 'package:provider/provider.dart';
import '../../features/splash/providers/splash_provider.dart';

void showPopUpDialog(BuildContext context) {
  // Using addPostFrameCallback to show dialog after build is complete
  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      String? popupImage =
          Provider.of<SplashProvider>(context, listen: false).popupModel!.image;

      int popup = Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .isPopup!;

      if (popup == 1) {
        showImageDialog(context, popupImage); // Show the pop-up with an image
      }
    },
  );
}
