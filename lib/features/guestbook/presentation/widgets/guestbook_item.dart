import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showwcase_v3/app/routing/route_constants.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/guestbook/data/bloc/guestbook_cubit.dart';
import 'package:showwcase_v3/features/guestbook/data/models/guestbook_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';

class GuestBookItem extends StatelessWidget {
  final GuestBookModel guestbook;
  final Function onDeleted;
  final Function onEdit;
  final String userName;

  const GuestBookItem({Key? key,
    required this.guestbook,
    required this.onDeleted,
    required this.onEdit, required this.userName})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            pushToProfile(context, user: guestbook.user!);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: CustomUserAvatarWidget(
              networkImage: guestbook.user!.profilePictureKey,
              size: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  pushToProfile(context, user: guestbook.user!);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Wrap(

                       children: [
                         Text(
                           guestbook.user!.displayName!,
                           style: TextStyle(
                               color: guestbook.user?.role == "community_lead"
                                   ? kAppGold
                                   : theme.colorScheme.onBackground,
                               fontWeight: FontWeight.w800,
                               fontSize: defaultFontSize),
                         ),
                         const SizedBox(
                           width: 5,
                         ),
                         Text(
                           guestbook.user!.activity?.emoji != null &&
                               !guestbook.user!.activity!.emoji!.contains('?')
                               ? guestbook.user!.activity!.emoji!
                               : '🔎',
                           style: TextStyle(
                             color: theme.colorScheme.onBackground,
                             fontSize: defaultFontSize,
                           ),
                         ), // emoji
                         const SizedBox(
                           width: 5,
                         ),
                         Text(
                           '@${guestbook.user!.username!}',
                           style: const TextStyle(
                               color: Color(0xff999999),
                               fontSize: 14,
                               overflow: TextOverflow.ellipsis),
                         ),
                         const SizedBox(
                           width: 10,
                         ),
                       ],
                    )),
                    Text(
                      getFormattedDateWithIntl(guestbook.createdAt!,
                          format: 'dd MMM, yy'),
                      style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: defaultFontSize - 4),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (AppStorage.currentUserSession!.id == guestbook.user!.id)
                      Align(
                        alignment: Alignment.centerRight,
                        child: PopupMenuButton<String>(
                          padding: const EdgeInsets.only(right: 0.0),
                          onSelected: (menu) {
                            _onMoreMenuItemTapped(context: context, menu: menu);
                          },
                          offset: const Offset(0, 20),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          color: theme.colorScheme.background,
                          shadowColor:
                              theme.colorScheme.onPrimary.withOpacity(0.3),
                          itemBuilder: (ctx) => [
                            _buildPopupMenuItem(
                                context, 'Edit', Icons.edit_outlined, "edit"),
                            const PopupMenuDivider(),
                            _buildPopupMenuItem(context, 'Delete',
                                Icons.delete_outline, "delete"),
                          ],
                          child: Container(
                            height: 15,
                            width: 15,
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.more_horiz,
                                color: theme.colorScheme.onPrimary
                                    .withOpacity(0.6)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(guestbook.message!,
                  style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontSize: defaultFontSize)),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ],
    );
  }

  void _onMoreMenuItemTapped(
      {required BuildContext context, required String menu}) {
    if (menu == "edit") {
      context.push(context.generateRoutePath(subLocation: editGuestBook),
          extra: {
            'userName': guestbook, 'message': guestbook.message, 'guestbookId': guestbook.id
          });
      onEdit();
    } else if (menu == "delete") {
      _showDeleteDialog(context);
    }
  }

  void _showDeleteDialog(BuildContext context)
  {

    Map<String, dynamic>? data = {};

    data.putIfAbsent("title", () =>  "Are you sure?");
    data.putIfAbsent("subTitle", () => 'Are you sure you want to permanently delete this guestbook? This will permanently delete this Guestbook and will not be recoverable');
    data.putIfAbsent("cancelActionText", () => 'Confirm');
    data.putIfAbsent("confirmActionText", () => 'Cancel');


    showConfirmDialog(context, title: data['title'],
      subtitle: data['subTitle'],
      cancelAction: data['cancelActionText'],
      confirmAction: data['confirmActionText'],
      onConfirmTapped: () async {
        context.read<GuestbookCubit>().deleteGuestbook(userName: userName,guestBookId: guestbook.id!);
      }

        );

    // onDeleted!(thread.id!);
    // resetPageState();

  }

  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, String title, IconData iconData, String value) {
    return PopupMenuItem(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      value: value,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 8,
          ),
          Icon(
            iconData,
            color: theme(context).colorScheme.onBackground,
            size: 16,
          ),
          // const SizedBox(width: 15,),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: TextStyle(color: theme(context).colorScheme.onBackground),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
