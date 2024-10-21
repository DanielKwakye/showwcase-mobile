import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/core/utils/widget_view.dart';
import 'package:showwcase_v3/features/guestbook/data/bloc/guestbook_cubit.dart';
import 'package:showwcase_v3/features/guestbook/data/bloc/guestbook_enums.dart';
import 'package:showwcase_v3/features/guestbook/data/bloc/guestbook_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';

class EditGuestBookPage extends StatefulWidget {
  final String userName;
  final String? message;
  final int guestbookId;

  const EditGuestBookPage({Key? key, required this.userName, this.message, required this.guestbookId, }) : super(key: key);

  @override
  EditGuestBookPageController createState() =>
      EditGuestBookPageController();
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////

class EditGuestBookPageView
    extends WidgetView<EditGuestBookPage, EditGuestBookPageController> {

  const EditGuestBookPageView(EditGuestBookPageController state,
      {super.key}) : super(state);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onBackground,
        ),
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed: () {
                state._guestbookCubit.editGuestbook(userName: widget.userName, message: state._messageController.text,guestBookId: widget.guestbookId);
              },
              child: const Text(
                "Edit",
                style: TextStyle(
                    color: kAppBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
        ],
        title: Text(
          'Guestbook',
          style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontSize: defaultFontSize,
              fontWeight: FontWeight.w600),
        ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(2), child: CustomBorderWidget()),
      ),
      body: BlocListener<GuestbookCubit, GuestbookState>(
        listener: (context, guestBookState) {
          if(guestBookState.status == GuestBookStatus.editGuestBookSuccess){
            state._isLoading.value = false;
            Navigator.pop(context);
          }
          if(guestBookState.status == GuestBookStatus.editGuestbookLoading){
            state._isLoading.value = true;
          }
          if(guestBookState.status == GuestBookStatus.editGuestbookError){
            state._isLoading.value = false;
          }
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children:  [
            CustomTextFieldWidget(
              controller: state._messageController,
              label: 'Write a message',
              maxLines: 5,
            )
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////

class EditGuestBookPageController extends State<EditGuestBookPage> {
  late GuestbookCubit _guestbookCubit;
  late final TextEditingController _messageController ;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  @override
  void initState() {
    _messageController = TextEditingController(text: widget.message);
    _guestbookCubit = context.read<GuestbookCubit>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) => EditGuestBookPageView(this);
}