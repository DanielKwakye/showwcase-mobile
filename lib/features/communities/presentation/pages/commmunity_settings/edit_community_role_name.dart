import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/communities/data/bloc/community_admin_cubit.dart';
import 'package:showwcase_v3/features/communities/data/models/community_admin_role.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_text_field_widget.dart';

class EditCommunityRoleName extends StatefulWidget {
  final int? communityId;

  final CommunityAdminRoleModel? communityRoleResponse;

  const EditCommunityRoleName(
      {super.key,
      required this.communityId,
      required this.communityRoleResponse});

  @override
  State<EditCommunityRoleName> createState() => _EditCommunityRoleNameState();
}

class _EditCommunityRoleNameState extends State<EditCommunityRoleName> {
  late final TextEditingController _roleName;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  late CommunityAdminCubit communityAdminCubit;

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    communityAdminCubit = context.read<CommunityAdminCubit>();
    _roleName = TextEditingController(text: widget.communityRoleResponse?.name ?? '');
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
          'Edit Role',
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
                        var isValidated = _formKey.currentState!.validate();
                        if (isValidated) {
                          communityAdminCubit.updateCommunityRoleName(
                              name: _roleName.text,
                              communityId: widget.communityId,
                              roleId: widget.communityRoleResponse?.id);
                        }
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
        listener: (context, state) {
         if(state is UpdateRoleNameLoading){
           _isLoading.value = true;
         }
         if(state is UpdateRoleNameSuccess){
            _isLoading.value = false;
            communityAdminCubit.fetchCommunityRoles(communityId: widget.communityId!);
            context.showSnackBar('Role name updated successfully');
            Navigator.pop(context, _roleName.text);
         }
         if(state is UpdateRoleNameError){
            _isLoading.value = false;
            context.showSnackBar(state.apiError.errorDescription.toString(),appearance: Appearance.error);
         }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CustomTextFieldWidget(
                label: 'Role Name',
                controller: _roleName,
                placeHolder: '',
                validator: (String? value) {
                  if (value == null || value == '') {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
