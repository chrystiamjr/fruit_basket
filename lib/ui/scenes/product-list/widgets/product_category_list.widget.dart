import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fruit_basket/blocs/category/category.cubit.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/blocs/product/product.cubit.dart';
import 'package:fruit_basket/models/product_filter.model.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/validator.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

import 'product_upper_card.widget.dart';

class ProductCategoryList extends StatelessWidget {
  const ProductCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isBR = getLanguageCubit(context).state.currentLang!.name == 'pt_BR';

    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (_, category) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _displayClear(context, category.selectedIndex),
            ...category.categories.map((e) {
              int index = category.categories.indexOf(e);
              int icon = int.parse('0x${e.icon}');

              return GestureDetector(
                onTap: () async {
                  await getCategoryCubit(context).changeSelected(index);
                  await getProductCubit(context).filter(ProductFilter(
                    type: FilterType.exists,
                    field: 'tags',
                    value: e.uuid,
                  ));
                },
                child: ProductUppercard(
                  size: getSize(context),
                  icon: IconDataSolid(icon),
                  iconSize: 25,
                  color: Basket.fromText(e.color),
                  title: isBR ? e.nameBr : e.name,
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _displayClear(BuildContext context, int index) {
    return Validator(
        validation: index >= 0,
        child: GestureDetector(
          onTap: () async {
            await getCategoryCubit(context).redefineSelection();
            await getProductCubit(context).filter(ProductFilter(
              type: FilterType.clear,
            ));
          },
          child: ProductUppercard(
            size: getSize(context),
            icon: FontAwesomeIcons.xmark,
            iconSize: 25,
            color: Basket.textPrimary,
            title: 'products.resetCard'.tr(),
          ),
        ));
  }
}
