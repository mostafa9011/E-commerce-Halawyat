import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utill/app_constants.dart';

void showImageDialog(BuildContext context, String? popupImage) {
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
          height: mediaQuery.height * 0.5,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: '${AppConstants.popupImageBasUrl}$popupImage',
                    fit: BoxFit.fill,
                    // height: mediaQuery.height * 0.5,
                    width: double.infinity,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
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
