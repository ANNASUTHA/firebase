import 'package:flutter/material.dart';

enum LeadingType { Back, Close, Menu }

class SimpleAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? text;
  final VoidCallback? onPressed;
  final LeadingType? leadingType;
  final List<Widget>? actions;

  const SimpleAppBar(
      {Key? key, this.text, this.onPressed, this.leadingType, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: leadingType != null
          ? IconButton(
              icon: Icon(
                _leadingIcon(leadingType: leadingType),
                color: Colors.black,
              ),
              onPressed: onPressed,
            )
          : Container(),
      title: Text(
        text ?? '',
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.headline6!.copyWith(height: 1.5),
      ),
      backgroundColor: Colors.white,
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  IconData _leadingIcon({LeadingType? leadingType}) {
    switch (leadingType) {
      case LeadingType.Back:
        return Icons.arrow_back_rounded;
      case LeadingType.Close:
        return Icons.close;
      case LeadingType.Menu:
        return Icons.menu;
      default:
        return Icons.arrow_back_rounded;
    }
  }
}
