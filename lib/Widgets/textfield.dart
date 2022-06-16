import 'package:flutter/material.dart';

class SimpleTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? textEditingController;
  final bool? isEnable;
  final String? Function(String?)? validator;
  final int? maxLength;
  final bool? isPasswordField;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  const SimpleTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.textCapitalization,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.textEditingController,
    this.isEnable = true,
    this.validator,
    this.maxLength,
    this.isPasswordField = false,
    this.focusNode, this.textInputAction,
  }) : super(key: key);

  @override
  _SimpleTextFieldState createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  bool _obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // initialValue: 'Input text',
      decoration: InputDecoration(
        labelText: widget.labelText,
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.transparent,
        // hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 1, color: Colors.grey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 0.5, color: Colors.grey)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 0.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1, color: Color(0xff0097D7))),
        isDense: true,
        enabled: widget.isEnable!,
        counterText: "",
        hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.grey.shade500),
        labelStyle: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.grey.shade500),
        errorStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Color(0xfff44336),
              fontWeight: FontWeight.normal,
            ),
        suffixIcon: widget.isPasswordField!
            ? TextButton(
                onPressed: () {
                  setState(() {
                    _obsecureText = !_obsecureText;
                  });
                },
                child: Text(
                  _obsecureText ? 'SHOW' : 'HIDE',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
              )
            : widget.suffixIcon,
      ),
      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.normal),
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      controller: widget.textEditingController,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: widget.maxLength,
      obscureText: widget.isPasswordField! ? _obsecureText : false,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
    );
  }
}

class SearchTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final Function()? onPressed;
  final VoidCallback? onTap;
  final TextEditingController? textEditingController;
  const SearchTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.onPressed,
    this.prefixIcon,
    this.textEditingController,
    this.onTap,
  }) : super(key: key);

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _defaultSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextFormField(
            // initialValue: 'Input text',
            onTap: widget.onTap,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              filled: true,
              fillColor: Colors.grey[250],
              contentPadding: EdgeInsets.only(left: 16, top: 2, bottom: 2),
              // prefixIcon: Icon(
              //   Icons.search,
              //   // color: Colors.grey.shade700,
              // ),
              suffixIcon: Icon(
                Icons.search,
                color: Colors.transparent,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey.shade500),
            ),
            style: Theme.of(context).textTheme.subtitle1,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            onChanged: widget.onChanged,
            controller: widget.textEditingController ?? _defaultSearchController,
            textInputAction: TextInputAction.send,
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.transparent, // border color
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15), // border color
                shape: BoxShape.circle,
              ),
              height: 36,
              width: 36,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.send_rounded,
                  size: 20,
                  color: Color(0xff3A67B1),
                ),
                onPressed: widget.onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
