import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:showwcase_v3/core/mix/form_mixin.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/refferals/data/bloc/invite_cubit.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_button_widget.dart';
import 'package:textfield_tags/textfield_tags.dart';

class Referrals extends StatefulWidget {
  const Referrals({Key? key}) : super(key: key);

  @override
  State<Referrals> createState() => _ReferralsState();
}

class _ReferralsState extends State<Referrals> with FormMixin {
  late TextfieldTagsController _controller;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  late InvitesCubit _referralCubit;

  @override
  void initState() {
    super.initState();
    _referralCubit = context.read<InvitesCubit>();
    _controller = TextfieldTagsController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: theme.colorScheme.onBackground,
          ),
          elevation: 0.0,
          title: Text(
            'Invite a Friend to Showwcase',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: defaultFontSize,
                fontWeight: FontWeight.w600),
          ),
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(2), child: CustomBorderWidget()),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          children: [
            RichText(
              text: TextSpan(
                  text: 'Send Email Invitation  ',
                  children: [
                    TextSpan(
                        text: '(tap space to enter email)',
                        style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400))

                  ],
                  style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldTags(
              textfieldTagsController: _controller,
              textSeparators: const [' ', ','],
              letterCase: LetterCase.normal,
              validator: (String tag) {
                String? validateEmail = isValidEmailAddress(tag);
                if (validateEmail != null) {
                  return validateEmail;
                }
                if (_controller.getTags!.contains(tag)) {
                  return 'you already entered that';
                }
                return null;
              },
              inputfieldBuilder:
                  (context, tec, fn, error, onChanged, onSubmitted) {
                return ((context, sc, tags, onTagDelete) {
                  return TextField(
                    controller: tec,
                    focusNode: fn,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.colorScheme.outline, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.colorScheme.outline, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.colorScheme.outline, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: _controller.hasTags ? '' : "Enter Email",
                      errorText: error,
                      prefixIconConstraints:
                          BoxConstraints(maxWidth: width(context)),
                      prefixIcon: tags.isNotEmpty
                          ? SingleChildScrollView(
                              controller: sc,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: tags.map((String tag) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    color: kAppBlue,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tag,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(width: 4.0),
                                      InkWell(
                                        child: const Icon(
                                          Icons.cancel,
                                          size: 14.0,
                                          color: Color.fromARGB(
                                              255, 233, 233, 233),
                                        ),
                                        onTap: () {
                                          onTagDelete(tag);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }).toList()),
                            )
                          : null,
                    ),
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                  );
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<InvitesCubit, InvitesState>(
              bloc: _referralCubit,
              listener: (context, state) {
                if (state is ReferralSuccess) {
                  _controller.clearTags();
                  if (state.invitesResponse.failed != null &&
                      state.invitesResponse.failed!.isNotEmpty) {
                    context.showSnackBar(
                      concatenateFailedMap(state.invitesResponse.failed!),
                    );
                  }
                  if (state.invitesResponse.invited!.isNotEmpty) {
                    context.showSnackBar('Invite was sent successfully');
                  }
                }
                if (state is ReferralError) {
                  context.showSnackBar(state.error, background: Colors.red);
                }
              },
              builder: (context, state) {
                if (state is ReferralLoading) {
                  return Align(
                    alignment: Alignment.topRight,
                    child: CustomButtonWidget(
                      text: '',
                      loading: true,
                      //layoutWidth: LayoutWidth.expand,
                      backgroundColor: kAppBlue,
                      appearance: Appearance.clean,
                      textColor: kAppWhite,
                      onPressed: () {},
                    ),
                  );
                }
                return Align(
                  alignment: Alignment.topRight,
                  child: ValueListenableBuilder(
                    valueListenable: ValueNotifier((_controller.getTags ?? []).isEmpty),
                    builder: (BuildContext context, bool value, Widget? child) {
                      return  CustomButtonWidget(
                        text: 'Send invite',
                        backgroundColor: !value ? kAppBlue : theme.colorScheme.onPrimary,
                        appearance: Appearance.clean,
                        textColor: !value ? kAppWhite : theme.colorScheme.surface,
                        onPressed: () {
                          if ((_controller.getTags ?? []).isEmpty) {
                            context.showSnackBar('Please enter an email address');
                            return;
                          }
                          _referralCubit.sendInvites(
                              emails: _controller.getTags ?? []);
                        },
                      ) ;
                    },
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomBorderWidget(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: CustomButtonWidget(
                    text: 'Share Link',
                    // make sure its 20 character long so it aligns
                    icon: Icon(
                      Icons.share,
                      color: theme.colorScheme.onBackground,
                    ),
                    backgroundColor: theme.brightness == Brightness.dark
                        ? const Color(0xff202021)
                        : const Color(0xffF7F7F7),
                    outlineColor: Colors.transparent,
                    appearance: Appearance.clean,
                    onPressed: () {
                      flutterShareMe.shareToSystem(
                          msg:
                              'Hey everyone! Check out my developer profile https://www.showwcase.com/${AppStorage.currentUserSession!.username}?referralToken=${AppStorage.currentUserSession!.referralToken} on @ShowwcaseHQ. It’s a professional network built for coders to connect, build community, and find new opportunities. ');
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: CustomButtonWidget(
                    text: 'Share on Twitter',
                    // make sure its 20 character long so it aligns
                    icon: SvgPicture.asset(
                      'assets/svg/twitter.svg',
                      color: kAppBlue,
                    ),
                    backgroundColor: theme.brightness == Brightness.dark
                        ? const Color(0xff202021)
                        : const Color(0xffF7F7F7),
                    outlineColor: Colors.transparent,
                    appearance: Appearance.clean,
                    onPressed: () {
                      flutterShareMe.shareToTwitter(
                          msg:
                              'Hey everyone! Check out my developer profile https://www.showwcase.com/${AppStorage.currentUserSession!.username}?referralToken=${AppStorage.currentUserSession!.referralToken} on @ShowwcaseHQ. It’s a professional network built for coders to connect, build community, and find new opportunities. ');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomBorderWidget(),
            const SizedBox(
              height: 20,
            ),
            Container(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 16),
                color: theme.brightness == Brightness.dark
                    ? const Color(0xff202021)
                    : const Color(0xffF7F7F7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share an Invite Link',
                      style: TextStyle(
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 3,
                              child: Text(
                                'https://www.showwcase.com?referralToken=${AppStorage.currentUserSession!.referralToken}',
                                style: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                    fontWeight: FontWeight.w400),
                              )),
                          CustomButtonWidget(
                            text: 'Copy',
                            backgroundColor: kAppBlue,
                            textColor: Colors.white,
                            onPressed: () {
                              copyTextToClipBoard(context,
                                  'https://www.showwcase.com?referralToken=${AppStorage.currentUserSession!.referralToken}');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: QrImageView(
                        data:
                            'https://www.showwcase.com?referralToken=${AppStorage.currentUserSession!.referralToken}',
                        version: QrVersions.auto,
                        size: 320,
                        eyeStyle: QrEyeStyle(
                            color: theme.colorScheme.onBackground,
                            eyeShape: QrEyeShape.square),
                        dataModuleStyle: QrDataModuleStyle(
                          color: theme.colorScheme.onBackground,
                          dataModuleShape: QrDataModuleShape.circle,
                        ),
                        gapless: false,
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  String concatenateFailedMap(Map<String, dynamic> failedMap) {
    StringBuffer result = StringBuffer();
    failedMap.forEach((key, value) {
      result.writeln('$key: $value');
    });
    return result.toString();
  }
}
