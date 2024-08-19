import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_loader_widget.dart';
import '../../category/providers/category_provider.dart';
import 'parent_item.dart';

class PartnersWidget extends StatelessWidget {
  const PartnersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.parentList != null
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ParentItem(
                    title: categoryProvider.parentList![index].name!,
                    image: categoryProvider.parentList![index].image!,
                    parentId: categoryProvider.parentList![index].id!,
                  );
                },
              )
            : Center(
                child:
                    CustomLoaderWidget(color: Theme.of(context).primaryColor),
              );
      },
    );
  }
}
