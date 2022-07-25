import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/models/product.model.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/ui/widgets/rounded_picture.dart';
import 'package:fruit_basket/ui/widgets/validator.widget.dart';
import 'package:fruit_basket/util/formatters.dart';
import 'package:uuid/uuid.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel product;
  final Size size;
  final Function()? onTap;

  const ProductGridItem({
    Key? key,
    required this.product,
    required this.size,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: BlocBuilder<LanguageCubit, LanguageState>(
          buildWhen: (prev, curr) => prev.currentLang != curr.currentLang,
          builder: (context, language) =>
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: Key(product.uuid ?? const Uuid().v1()),
                    child: RoundedPicture(
                      url: product.photo,
                      size: 75,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _name(product, language),
                  _description(product, language),
                  _price(context, product),
                ],
              ),
        ),
      ),
    );
  }

  Widget _name(ProductModel product, LanguageState language) {
    var isBr = language.currentLang?.name == 'pt_BR';

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Label(
              capitalize(isBr ? product.nameBr : product.name),
              size: 13,
              weight: FontWeight.bold,
            ),
          ),
          Validator(
            validation: product.promoPercentage > 0,
            child: Icon(
              Icons.whatshot,
              size: 15,
              color: Basket.accent,
            ),
          )
        ],
      ),
    );
  }

  Widget _description(ProductModel product, LanguageState language) {
    var isBr = language.currentLang?.name == 'pt_BR';

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
        child: Label(
          isBr ? product.descriptionBr : product.description,
          size: 11,
          weight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _price(BuildContext context, ProductModel product) {
    final inPromo = product.promoPercentage > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Label(
          currencyFormatter(context, price: product.price),
          size: inPromo ? 10 : 12,
          decoration: inPromo ? TextDecoration.lineThrough : null,
          decorationColor: inPromo ? Basket.textPrimary : null,
          color: inPromo ? Basket.accent : null,
          weight: FontWeight.w500,
        ),
        const SizedBox(width: 7),
        Validator(
            validation: inPromo,
            child: Label(
              currencyFormatter(context, price: product.price * (1 - product.promoPercentage / 100)),
              size: 12,
              weight: FontWeight.w500,
            ))
      ],
    );
  }
}
