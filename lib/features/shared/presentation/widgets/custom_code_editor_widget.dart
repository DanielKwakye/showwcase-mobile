import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' hide ModalBottomSheetRoute ;
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';

class CustomCodeEditorWidget extends StatefulWidget {

  final Function(String)? onChange;
  final Function(String)? onLanguageChanged;
  final Function() onClose;
  final String? initialCodeContent;

  const CustomCodeEditorWidget({
    this.onChange,
    this.onLanguageChanged,
    required this.onClose,
    this.initialCodeContent,
    Key? key}) : super(key: key);

  @override
  _CustomCodeEditorWidgetController createState() => _CustomCodeEditorWidgetController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class _CustomCodeEditorWidgetView extends WidgetView<CustomCodeEditorWidget, _CustomCodeEditorWidgetController> {

  const _CustomCodeEditorWidgetView(_CustomCodeEditorWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(right: 15),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          // child: CustomCodeEditorWidget(onClose: () => state.attachCode.value = false,)
          child: Container(
            color: (codeTheme['root'] as TextStyle).backgroundColor,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 1, top: 1),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showLanguages(context),
                        child: Row(
                          children: [
                            Text(state.language.capitalize(), style: const TextStyle(color: kAppWhite),),
                            const SizedBox(width: 5,),
                            const Icon(Icons.keyboard_arrow_down_outlined, color: kAppGray,),
                          ],
                        ),
                      ),
                      const Spacer(),
                      CloseButton(
                        color: kAppGray,
                        onPressed: state._onCloseTapped,)
                    ],
                  ),
                ),

                // const Divider(color: kAppGray,),
                CodeTheme(
                  data: const CodeThemeData(styles: codeTheme),
                  child: CodeField(
                      // expands: true,
                      wrap: false,
                      // maxLines: 50,
                      controller: state._codeController,
                      onChanged: widget.onChange,
                      textStyle: const TextStyle(fontFamily: 'SourceCode'),
                    ),
                )

              ],
            ),
          )
      ),
    );
  }


  _showLanguages(BuildContext context){

    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor:  Colors.transparent,
      builder: (ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(ctx).pop();
          },
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.4,
            maxChildSize: 0.90,
            builder: (_, controller) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 0, right: 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text('Select Language', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onBackground),),
                      ),
                      const CustomBorderWidget(top: 15,),
                      Expanded(child: SingleChildScrollView(
                        controller: controller,
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
                            ...state._getSortedSupportedLanguages().map((key) => Row(
                              children: [
                                Radio<String>(value: key, groupValue: state.language, onChanged: (newValue) =>  state._onSelectLanguageTapped(newValue!)),
                                GestureDetector(onTap: () => state._onSelectLanguageTapped(key),
                                  child: Text(key.capitalize(), style: TextStyle(color: theme.colorScheme.onBackground),),
                                )
                              ],
                            )
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );

  }

}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class _CustomCodeEditorWidgetController extends State<CustomCodeEditorWidget> {

  late CodeController _codeController;
  late String codeInitialText;
  String language = defaultCodeLanguage;

  @override
  void initState() {
    super.initState();

    codeInitialText = !widget.initialCodeContent.isNullOrEmpty() ? widget.initialCodeContent! : "// code";

    _setUpController(code: codeInitialText);

     onWidgetBindingComplete(onComplete: (){
       if(widget.onChange != null){
         widget.onChange!(codeInitialText);
       }
     });
    if(!widget.initialCodeContent.isNullOrEmpty()){
      _codeController.text = widget.initialCodeContent!;
    }
  }

  _setUpController({required String code}){
    _codeController = CodeController(
        text: code,
        language: supportedLanguages[language],
        // theme: codeTheme,
        // onChange: widget.onChange,

    );
  }

  @override
  Widget build(BuildContext context) => _CustomCodeEditorWidgetView(this);

  _onCloseTapped(){
    _codeController.text = codeInitialText;
    widget.onClose();
  }

  _onSelectLanguageTapped(String newValue){
    Navigator.of(context).pop();
    setState(() {
      language = newValue;
      _setUpController(code: _codeController.text);
      if(widget.onLanguageChanged != null){
        widget.onLanguageChanged!(newValue);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
   _codeController.dispose();
  }

  List<String> _getSortedSupportedLanguages(){
    final languagesInString = [...supportedLanguages.keys.toList()];
    languagesInString.sort();
    return languagesInString;
  }

}