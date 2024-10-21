import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_admin_role.dart';
import 'package:showwcase_v3/features/communities/data/models/community_model.dart';
import 'package:showwcase_v3/features/communities/presentation/pages/commmunity_settings/community_role_settings.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_app_shimmer.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_no_connection_widget.dart';

class ManageCommunityRole extends StatefulWidget {
  final CommunityModel? communityModel;

  const ManageCommunityRole({super.key, this.communityModel});

  @override
  State<ManageCommunityRole> createState() => _ManageCommunityRoleState();
}

class _ManageCommunityRoleState extends State<ManageCommunityRole> {
  late CommunityAdminCubit communityAdminCubit;
  late ValueNotifier<List<CommunityAdminRoleModel>> rolesResponse;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    communityAdminCubit = context.read<CommunityAdminCubit>();
    rolesResponse = ValueNotifier([]);
    communityAdminCubit.fetchCommunityRoles(
        communityId: widget.communityModel!.id!);
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
          'Roles',
          style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontSize: defaultFontSize),
        ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(2), child: CustomBorderWidget()),
      ),
      body: BlocConsumer<CommunityAdminCubit, CommunityAdminState>(
        bloc: communityAdminCubit,
        buildWhen: (previousState, currentState) {
          return currentState is CommunityRolesLoading ||
              currentState is CommunityRolesError ||
              currentState is CommunityRolesSuccess;
        },
        listener: (context, state) {
          if (state is AddRolesLoading) {
            _isLoading.value = true;
          }
          if (state is AddRolesSuccess) {
            _isLoading.value = false;
            rolesResponse.value.add(state.rolesResponse);
            context.showSnackBar(
              'Role added successfully',
            );
          }
          if (state is AddRolesError) {
            _isLoading.value = false;
          }
          if (state is CommunityRolesSuccess) {
            rolesResponse.value.clear();
            rolesResponse.value.addAll(state.rolesResponse);
          }
        },
        builder: (context, state) {
          if (state is CommunityRolesLoading) {
            return const CustomAppShimmer(
              repeat: 20,
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
            );
          }
          if (state is CommunityRolesSuccess) {
            return ValueListenableBuilder(
              valueListenable: rolesResponse,
              builder: (BuildContext context, List<CommunityAdminRoleModel> value,
                  Widget? child) {
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommunityRoleSettings(
                                          communitiesResponse:
                                              widget.communityModel,
                                          roleResponse: value[index],
                                        )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: Color(int.parse(
                                            '0xff${value[index].color?.substring(1)}')),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    '${value[index].name}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: theme.colorScheme.onBackground,
                                  size: 15),
                            ],
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: value.length,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: _isLoading,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return value
                            ? const Center(
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator.adaptive(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          kAppBlue),
                                      strokeWidth: 1,
                                    )))
                            : CustomButtonWidget(
                                backgroundColor: theme.colorScheme.surface,
                                text: 'Add Role',
                                textColor: theme.colorScheme.onBackground,
                                onPressed: () {
                                  communityAdminCubit.addCommunityRole(
                                      communityId:
                                          widget.communityModel!.id!,
                                      roleName: 'New Role');
                                },
                                icon: Icon(Icons.add,
                                    color: theme.colorScheme.onBackground),
                              );
                      },
                    )
                  ],
                );
              },
            );
          }
          if (state is CommunityRolesError) {
            return Center(
              child: CustomNoConnectionWidget(
                title: "Restore connection and swipe to refresh ...",
                showRetryButton: true,
                onRetry: () {
                  communityAdminCubit.fetchCommunityRoles(
                      communityId: widget.communityModel!.id!);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
