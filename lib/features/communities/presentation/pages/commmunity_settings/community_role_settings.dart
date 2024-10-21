import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_admin_role.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/edit_community_role_name.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';


class CommunityRoleSettings extends StatefulWidget {
  final CommunityModel? communitiesResponse;

  final CommunityAdminRoleModel? roleResponse;

  const CommunityRoleSettings(
      {super.key,
      required this.communitiesResponse,
      required this.roleResponse});

  @override
  State<CommunityRoleSettings> createState() => _CommunityRoleSettingsState();
}

class _CommunityRoleSettingsState extends State<CommunityRoleSettings> {
  late ValueNotifier<bool> _createThreads;
  late ValueNotifier<bool> manageThreads;
  late ValueNotifier<bool> _inviteMembers;
  late ValueNotifier<bool> _removeMembers;
  late ValueNotifier<bool> _manageCommunity;
  late ValueNotifier<bool> _roleManage;
  late ValueNotifier<bool> _administrator;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<String> _roleName = ValueNotifier('');
  late CommunityAdminCubit communityAdminCubit;

  late List<int> permissionIds;

  late CommunityAdminRoleModel? roleResponse;
  ValueNotifier<bool> activateDeleteAccountButton = ValueNotifier(false);
  ValueNotifier<bool> isDeletingAccount = ValueNotifier(false);
  Map<String, int> targetStrings = {
    "admin": 7,
    "community_manage": 5,
    "member_invite": 3,
    "member_remove": 4,
    "roles_manage": 6,
    "thread_create": 1,
    "thread_manage": 2
  };

  @override
  void initState() {
    communityAdminCubit = context.read<CommunityAdminCubit>();
    permissionIds = [];
    roleResponse = widget.roleResponse;
    _roleName.value = roleResponse!.name!;
    _createThreads =
        ValueNotifier(roleResponse!.permissions!.contains('thread_create'));
    manageThreads =
        ValueNotifier(roleResponse!.permissions!.contains('thread_manage'));
    _inviteMembers =
        ValueNotifier(roleResponse!.permissions!.contains('member_invite'));
    _removeMembers =
        ValueNotifier(roleResponse!.permissions!.contains('member_remove'));
    _manageCommunity =
        ValueNotifier(roleResponse!.permissions!.contains('community_manage'));
    _roleManage =
        ValueNotifier(roleResponse!.permissions!.contains('roles_manage'));
    _administrator =
        ValueNotifier(roleResponse!.permissions!.contains('admin'));
    addNumbersToList(roleResponse!.permissions!);

    super.initState();
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
          '${roleResponse?.name}',
          style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: defaultFontSize),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (BuildContext context, bool value, Widget? child) {
              return value
                  ? const Center(
                      child: Row(
                      children: [
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kAppBlue),
                              strokeWidth: 1,
                            )),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ))
                  : TextButton(
                      onPressed: () {
                        communityAdminCubit.updateCommunityRoles(
                            permissionIds: permissionIds,
                            roleId: roleResponse!.id!,
                            communityId: widget.communitiesResponse!.id!);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: kAppBlue,
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ));
            },
          ),
        ],
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(2), child: CustomBorderWidget()),
      ),
      body: BlocListener<CommunityAdminCubit, CommunityAdminState>(
        bloc: communityAdminCubit,
        listener: (context, state) {
          if (state is UpdateRolesLoading) {
            _isLoading.value = true;
          }
          if (state is UpdateRolesSuccess) {
            _isLoading.value = false;
            context.showSnackBar('Role Permission Updated Successfully');
            communityAdminCubit.fetchCommunityRoles(communityId: widget.communitiesResponse!.id!);
          }
          if (state is UpdateRolesError) {
            _isLoading.value = false;
          }

          if (state is DeleteRoleLoading) {
            isDeletingAccount.value = true;
          }
          if (state is DeleteRoleSuccess) {
            isDeletingAccount.value = false;
            communityAdminCubit.fetchCommunityRoles(
                communityId: widget.communitiesResponse!.id!);
            context.showSnackBar('Role Deleted Successfully');
            Navigator.pop(context);
            Navigator.pop(context);
          }
          if (state is DeleteRoleError) {
            isDeletingAccount.value = false;
          }
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'General',
                style: TextStyle(
                  color: theme.colorScheme.onBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const CustomBorderWidget(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditCommunityRoleName(
                              communityId: widget.communitiesResponse?.id,
                              communityRoleResponse: roleResponse,
                            ))).then((value) {
                  if (value != null) {
                    _roleName.value = value;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text('Role Name',
                          style: TextStyle(
                              color: theme.colorScheme.onBackground,
                              fontSize: defaultFontSize,
                              fontWeight: FontWeight.w700)),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: _roleName,
                              builder: (BuildContext context, String value, Widget? child) {
                                return Text(
                                  value,
                                  style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                ) ;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 10, color: theme.colorScheme.onPrimary),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const CustomBorderWidget(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Permission',
                style: TextStyle(
                  color: theme.colorScheme.onBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            //  const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Toggle the permissions that you want this role to have.',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Text(
                'THREAD PERMISSIONS',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Create Threads',
                          style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _createThreads,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Switch.adaptive(
                            activeColor: kAppBlue,
                            value: value,
                            onChanged: (bool newValue) {
                              if (permissionIds.contains(1)) {
                                permissionIds.remove(1);
                                _createThreads.value = false;
                              } else {
                                permissionIds.add(1);
                                _createThreads.value = true;
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Text(
                    'Allows members to create Thread.',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Manage Threads',
                          style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: manageThreads,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Switch.adaptive(
                            activeColor: kAppBlue,
                            value: value,
                            onChanged: (bool newValue) {
                              if (permissionIds.contains(2)) {
                                permissionIds.remove(2);
                                manageThreads.value = false;
                              } else {
                                permissionIds.add(2);
                                manageThreads.value = true;
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Text(
                    'Allows members to delete messages by other members or pin any Thread.',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            const CustomBorderWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Text(
                'MEMBERSHIP PERMISSIONS',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Invite New Members',
                          style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _inviteMembers,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Switch.adaptive(
                            activeColor: kAppBlue,
                            value: value,
                            onChanged: (bool newValue) {
                              if (permissionIds.contains(3)) {
                                permissionIds.remove(3);
                                _inviteMembers.value = false;
                              } else {
                                permissionIds.add(3);
                                _inviteMembers.value = true;
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Text(
                    'Allows members to invite new members to this community.',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Remove Members',
                          style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _removeMembers,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Switch.adaptive(
                            activeColor: kAppBlue,
                            value: value,
                            onChanged: (bool newValue) {
                              if (permissionIds.contains(4)) {
                                permissionIds.remove(4);
                                _removeMembers.value = false;
                              } else {
                                permissionIds.add(4);
                                _removeMembers.value = true;
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Text(
                    'Allows members to remove other members from this community. If the removed user gets another invite, they will still be able to rejoin',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            const CustomBorderWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Text(
                'COMMUNITY PERMISSIONS',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Manage Community',
                          style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _manageCommunity,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Switch.adaptive(
                            activeColor: kAppBlue,
                            value: value,
                            onChanged: (bool newValue) {
                              if (permissionIds.contains(5)) {
                                permissionIds.remove(5);
                                _manageCommunity.value = false;
                              } else {
                                permissionIds.add(5);
                                _manageCommunity.value = true;
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Text(
                    'Allows members to change this community’s name, description, image, and about information.',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Manage Roles',
                          style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _roleManage,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Switch.adaptive(
                            activeColor: kAppBlue,
                            value: value,
                            onChanged: (bool newValue) {
                              if (permissionIds.contains(6)) {
                                permissionIds.remove(6);
                                _roleManage.value = false;
                              } else {
                                permissionIds.add(6);
                                _roleManage.value = true;
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Text(
                    'Allows members to update and assign Roles.',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            const CustomBorderWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Text(
                'SUPER PERMISSIONS',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Administrator',
                          style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _administrator,
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Switch.adaptive(
                            activeColor: kAppBlue,
                            value: value,
                            onChanged: (bool newValue) {
                              if (permissionIds.contains(7)) {
                                permissionIds.remove(7);
                                _administrator.value = false;
                              } else {
                                permissionIds.add(7);
                                _administrator.value = true;
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Text(
                    'Members with this permission will have every permission except ownership of the community. Be careful when giving out this permission.',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomBorderWidget(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _deleteRoleUI(context);
                  // communityAdminCubit.deleteCommunityRole(roleId: roleResponse?.id, communityId: widget.communitiesResponse?.id!);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delete Role',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w700)),
                    Icon(Icons.arrow_forward_ios,
                        size: 10, color: theme.colorScheme.onPrimary),
                  ],
                ),
              ),
            ),
            const CustomBorderWidget(),
          ],
        ),
      ),
    );
  }

  void _deleteRoleUI(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme(context).colorScheme.primary,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: CloseButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const CustomBorderWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Delete Role',
                    style: theme(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Are you sure you want to delete this role?',
                    style: theme(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFieldWidget(
                    label:
                        "Please type “DELETE ${roleResponse?.name?.toUpperCase()}” below",
                    placeHolder: "",
                    onChange: (value) {
                      if (value!.toUpperCase() ==
                          "DELETE ${roleResponse?.name?.toUpperCase()}") {
                        activateDeleteAccountButton.value = true;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return ValueListenableBuilder(
                        valueListenable: isDeletingAccount,
                        builder: (ctx, bool value, _) {
                          return value
                              ? const Center(
                                  child: Row(
                                  children: [
                                    SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  kAppBlue),
                                          strokeWidth: 1,
                                        )),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ))
                              : ValueListenableBuilder<bool>(
                                  valueListenable: activateDeleteAccountButton,
                                  builder: (ctx, bool activate, _) {
                                    return CustomButtonWidget(
                                        text: "Delete role",
                                        appearance: activate
                                            ? Appearance.error
                                            : Appearance.secondary,
                                        onPressed: activate
                                            ? () {
                                                communityAdminCubit
                                                    .deleteCommunityRole(
                                                        roleId:
                                                            roleResponse?.id,
                                                        communityId: widget
                                                            .communitiesResponse
                                                            ?.id!);
                                              }
                                            : null);
                                  },
                                );
                        });
                  }),
                  const SizedBox(
                    height: kToolbarHeight,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void addNumbersToList(List<String> stringList) {
    for (String item in stringList) {
      if (targetStrings.keys.contains(item)) {
        int index = targetStrings.keys.toList().indexOf(item);
        int incrementedNumber = targetStrings.values.toList()[index];
        permissionIds.add(incrementedNumber);
        print(permissionIds);
      }
    }
  }
}
