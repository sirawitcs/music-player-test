import 'package:flutter/material.dart';

class CustomListile extends StatelessWidget {
  const CustomListile({
    super.key,
    required this.image,
    required this.title,
    required this.subTitlt,
    required this.listiltAction,
    required this.buttonAction,
    required this.icon,
  });
  final String image;
  final String title;
  final String subTitlt;
  final VoidCallback listiltAction;
  final VoidCallback buttonAction;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          onTap: () {
            listiltAction();
          },
          title: Row(
            children: [
              Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(title), Text(subTitlt)],
                ),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              buttonAction();
            },
            iconSize: 32,
            icon: icon,
          ),
        ),
      ],
    );
  }
}
