import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/chat/presentation/widgets/chat_shimmer.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_user_avatar_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';


class CommunityInvite extends StatefulWidget {
  final CommunityModel? communityModel;

  const CommunityInvite({super.key, required this.communityModel});

  @override
  State<CommunityInvite> createState() => _CommunityInviteState();
}

class _CommunityInviteState extends State<CommunityInvite> {
  late final CommunityAdminCubit _communityAdminCubit;


  @override
  void initState() {
    super.initState();
    _communityAdminCubit = context.read<CommunityAdminCubit>();
  }

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
        title: Text(
          'Invite',
          style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: defaultFontSize),
        ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(2), child: CustomBorderWidget()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Invite friends to ${widget.communityModel?.name}',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '${widget.communityModel?.totalMembers} Members',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Share invite link',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w700,
                fontSize: 14),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'https://www.showwcase.com/${widget.communityModel?.slug}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          final FlutterShareMe flutterShareMe =
                              FlutterShareMe();
                          flutterShareMe.shareToSystem(
                              msg:
                                  'Join ${widget.communityModel!.name} on Showwcase \n https://showwcase.com/community/${widget.communityModel!.slug}');
                        },
                        icon: const Icon(
                          Icons.share,
                          size: 15,
                        )),
                    IconButton(
                        onPressed: () {
                          copyTextToClipBoard(context,
                              'https://www.showwcase.com/${widget.communityModel?.slug}');
                        },
                        icon: SvgPicture.asset(
                          'assets/svg/copy_icon.svg',
                          height: 20,
                          color: theme.colorScheme.onBackground,
                        )),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CupertinoSearchTextField(
            style: TextStyle(color: theme.colorScheme.onBackground),
            padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
            backgroundColor: theme.colorScheme.surface,
            placeholder: 'Search your people',
            borderRadius: BorderRadius.circular(80),
            placeholderStyle: TextStyle(
                fontSize: defaultFontSize, color: theme.colorScheme.onPrimary),
            prefixIcon: const Icon(Icons.search),
            onChanged: (String value) {
              EasyDebounce.debounce(
                  'community-invite-debouncer',
                  // <-- An ID for this particular debouncer
                  const Duration(milliseconds: 500),
                  // <-- The debounce duration
                  () {
                    _communityAdminCubit.searchPeople(text: value);
                // <-- The target method
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<CommunityAdminCubit, CommunityAdminState>(
            bloc: _communityAdminCubit,
            buildWhen: (previous, current) {
              if (current is SearchPeopleLoading ||
                  current is SearchPeopleSuccess ||
                  current is SearchPeopleError) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if(state is SearchPeopleLoading){
                return const ChatShimmer();
              }
              if(state is SearchPeopleSuccess){
                return Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListView.separated(
                    itemCount: state.networkResponse.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final ValueNotifier<String> _isInviteLoading = ValueNotifier<String>('no_invite');
                      UserModel networkResponse = state.networkResponse[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                         if(_isInviteLoading.value.isNotEmpty){
                           _isInviteLoading.value = 'loading';
                           _communityAdminCubit.sendCommunityInvite(userId: state.networkResponse[index].id, communityId: widget.communityModel?.id);
                           _isInviteLoading.value = '';
                         }else {
                           context.showSnackBar('This user has already been invited', appearance: Appearance.secondary);
                         }
                        },
                        child: Row(
                          children: [
                            CustomUserAvatarWidget(
                              size: 50,
                              username: networkResponse.username,
                              networkImage:
                              networkResponse.profilePictureKey ?? '',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${networkResponse.displayName}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: theme.colorScheme.onBackground,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '@${networkResponse.username}',
                                              style: TextStyle(
                                                  color: theme.colorScheme.onPrimary,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )),
                                    ValueListenableBuilder(
                                      valueListenable: _isInviteLoading,
                                      builder: (BuildContext context, String value, Widget? child) {
                                        if (checksEqual(value, 'no_invite')) {
                                          return const SizedBox.shrink();
                                        } else {
                                          return checksEqual(value, 'loading') ?
                                          const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Center(
                                                child:
                                                CircularProgressIndicator
                                                    .adaptive(
                                                  backgroundColor: kAppBlue,
                                                  strokeWidth: 2,
                                                )))
                                              :  Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: theme.colorScheme.surface),
                                          child: Text(
                                            'Invited',
                                            style: TextStyle(
                                                color: theme.colorScheme.onBackground,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        );
                                        }
                                      },
                                    )
                                  ],
                                ))
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                  ),
                );
              }
              if(state is SearchPeopleError){}
             return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
