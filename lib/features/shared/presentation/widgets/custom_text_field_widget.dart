import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatefulWidget {

  final String? label;
  final String? placeHolder;
  final String? initialValue;
  final bool? readOnly;
  final bool? disabled;
  final void Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChange;
  final void Function(String?)? onSaved;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Function(bool?)? onFocusChanged;
  final TextInputType? inputType;
  final bool? obscureText;
  final bool? isPassword;
  final bool? isPhone;
  final int? maxLines;
  final FocusNode? focusNode;
  final String? errorText;
  final Widget? suffix;
  final TextCapitalization textCapitalization;
  final bool showLabel;


  const CustomTextFieldWidget({Key? key,
    this.maxLines = 1,
    this.initialValue,
    this.readOnly = false,
    this.disabled = false,
    this.onTap,
    this.controller,
    this.validator,
    this.onSaved,
    this.prefixIcon,
    this.prefix,
    this.onChange,
    this.label,
    this.placeHolder,
    this.onFocusChanged,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.isPhone = false,
    this.focusNode,
    this.errorText,
    this.suffix,
    this.textCapitalization = TextCapitalization.sentences,
    this.showLabel = true
  }) : super(key: key);

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {

  bool _hideText = true;
  bool hasReceivedFocus = false;
  final double radius = 5;

  @override
  Widget build(BuildContext context) {

    bool readOnly = widget.readOnly!;

    final theme = Theme.of(context);
    if(widget.disabled != null && widget.disabled!){
      readOnly = true;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.label != null && widget.label!.isNotEmpty && widget.showLabel) ...{
          Text(widget.label ?? '', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w600),),
          const SizedBox(height: 10,),
        },
        Focus(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.inputType,
            initialValue: widget.initialValue,
            readOnly: readOnly,
            focusNode: widget.focusNode,
            textCapitalization: (widget.inputType == TextInputType.emailAddress || widget.isPassword == true) ? TextCapitalization.none : widget.textCapitalization,
            onTap: widget.onTap,
            maxLines: widget.maxLines,
            validator: widget.validator,
            obscureText:  widget.isPassword! ?_hideText : widget.obscureText!,
            onSaved:  widget.onSaved,
            onChanged: widget.onChange,
            cursorColor: theme.colorScheme.onPrimary.withOpacity(0.5),
            style: TextStyle(color: theme.colorScheme.onBackground),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
                filled: true,
                errorText: widget.errorText,
                fillColor:  (widget.disabled != null && widget.disabled!)? theme.colorScheme.outline : theme.brightness == Brightness.dark ? const Color(0xff202021) : const Color(0xffF7F7F7),
                hintText: widget.placeHolder,
                hintStyle: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.5)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: theme.colorScheme.outline, width: 1),
                  borderRadius: BorderRadius.circular(radius),
                ),
                border: OutlineInputBorder(
                  borderSide:  BorderSide(color: theme.colorScheme.outline, width: 1),
                  borderRadius: BorderRadius.circular(radius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.outline, width: 1),
                  borderRadius: BorderRadius.circular(radius),
                ),
                suffixIcon:  widget.isPassword! ? IconButton(onPressed: () => setState(() => _hideText = !_hideText), icon: Icon(_hideText ? Icons.visibility_outlined: Icons.visibility_off_outlined)) : widget.suffix ,
                prefixIcon: widget.prefixIcon,
                prefix:  widget.prefix,

            ),
          ),
          onFocusChange: (value) {
            setState(() {
              hasReceivedFocus = value;
              if(widget.onFocusChanged != null){
                widget.onFocusChanged!(value);
              }
            });

          },
        )

      ],
    );
  }
}
