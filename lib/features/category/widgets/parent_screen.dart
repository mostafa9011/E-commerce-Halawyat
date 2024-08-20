import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/custom_loader_widget.dart';
import '../../../common/widgets/web_app_bar_widget.dart';
import '../../../helper/responsive_helper.dart';
import '../../home/widgets/parent_item.dart';
import '../providers/category_provider.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({
    Key? key,
    required this.subCategoryName,
  }) : super(key: key);
  final String subCategoryName;

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  // void loadData() {
  //   final CategoryProvider categoryProvider =
  //       Provider.of<CategoryProvider>(context);

  //   categoryProvider.getParentList(context, false);
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // loadData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: WebAppBarWidget(),
            )
          : CustomAppBarWidget(
              title: widget.subCategoryName,
              isCenter: false,
              isElevation: true,
              fromCategory: true,
            )) as PreferredSizeWidget?,
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return categoryProvider.parentList!.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 30),
                    itemCount: categoryProvider.parentList?.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      return ParentItem(
                        image: '${categoryProvider.parentList![index].image}',
                        title: categoryProvider.parentList![index].name!,
                        parentId: categoryProvider.parentList![index].id!,
                      );
                      // return SubCategoryWidget(
                      //   index: index,
                      //   image:
                      //       '${AppConstants.imageBaseUrl}${categoryProvider.parentList![index].image}',
                      // );
                    },
                  ),
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
