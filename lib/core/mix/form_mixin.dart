
import 'package:flutter/cupertino.dart';

mixin FormMixin {

  /// checks if any fields are empty
  String? isRequired(String? value){
    if(value == null || value == ''){
      return 'This field is required';
    }
    return null;
  }

  /// Validates the required fields and calls a save method on the form
  bool validateAndSaveOnSubmit(BuildContext ctx) {
    final form = Form.of(ctx);

    if(!form.validate()){
      return false;
    }

    form.save();
    return true;

  }


  String? isValidEmailAddress(String? value) {
    final emailAddressRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!emailAddressRegex.hasMatch(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

}