import 'package:flutter/material.dart';
import 'package:pos_mobile/core/models/menu.dart';

class MenuItem extends StatelessWidget {
  final Menu menu;
  MenuItem({this.menu});

  int discountValue() {
    return (menu.discountType == "fixed"
            ? (menu.price - menu.discountValue)
            : (menu.price * ((100 - menu.discountValue) / 100)))
        .toInt();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          {Navigator.of(context).pushNamed("menu_detail", arguments: menu)},
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey, width: 0.0)),
        child: Row(children: [
          ClipRRect(
            borderRadius: new BorderRadius.circular(8.0),
            child: menu.photo == ""
                ? Container(
                    child: Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey,
                  ))
                : Image.network(menu.photo,
                    height: 80, width: 80, fit: BoxFit.cover),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(menu.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                Text(menu.description),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        style: TextStyle(color: Colors.black),
                        text: menu.isDiscount
                            ? 'Rp ${discountValue()}'
                            : 'Rp ${menu.price.toInt()}'),
                    TextSpan(text: "  "),
                    menu.isDiscount
                        ? TextSpan(
                            text: 'Rp ${menu.price.toInt()}',
                            style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough))
                        : TextSpan(text: "")
                  ]),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
