import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/core/utils/enums.dart';
import 'package:showwcase_v3/core/utils/extensions.dart';
import 'package:showwcase_v3/core/utils/functions.dart';
import 'package:showwcase_v3/core/utils/theme.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_cubit.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_state.dart';
import 'package:showwcase_v3/features/chat/data/bloc/chat_status.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_connection_model.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_cubit.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_enums.dart';
import 'package:showwcase_v3/features/file_manager/data/bloc/file_manager_state.dart';
import 'package:showwcase_v3/features/shared/presentation/widgets/custom_border_widget.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

class SendMessage extends StatefulWidget {
  final UserModel networkResponse;
  final ChatConnectionModel connection;

  const SendMessage(
      {Key? key, required this.networkResponse, required this.connection})
      : super(key: key);

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  late ChatCubit _chatCubit;
  late FileManagerCubit _fileManagerCubit;

  final TextEditingController _messageController = TextEditingController();
  final ValueNotifier<String> _messageNotifier = ValueNotifier<String>('');
  final ValueNotifier<bool> _isMessageSending = ValueNotifier<bool>(false);
  final ValueNotifier<File?> _localFile = ValueNotifier(null);
  final String fileUploadGroupId = "chatPage";

  @override
  void initState() {
    _fileManagerCubit = context.read<FileManagerCubit>();
    _chatCubit = context.read<ChatCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state.status == ChatStatus.sendMessageToRecipientSuccessful) {
              _isMessageSending.value = false;
            }
            if (state.status == ChatStatus.sendMessageToRecipientInProgress) {
              _isMessageSending.value = true;
            }

            if (state.status == ChatStatus.sendMessageToRecipientFailed) {
              _isMessageSending.value = false;
            }
          },
        ),
        BlocListener<FileManagerCubit, FileManagerState>(
          listener: (context, state) {
            if (state.status == FileManagerStatus.uploadImageInProgress) {}
            if (state.status == FileManagerStatus.uploadImageSuccessful) {

            }
            if (state.status ==  FileManagerStatus.uploadImageFailed) {}
          },
          child: const SizedBox.shrink(),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<FileManagerCubit, FileManagerState>(
            bloc: _fileManagerCubit,
            builder: (context, state) {
              if (state.status == FileManagerStatus.uploadImageInProgress) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                      border: Border(
                          bottom: BorderSide(color: theme.colorScheme.outline),
                          top: BorderSide(color: theme.colorScheme.outline))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          color: theme.colorScheme.surface,
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(_localFile.value!, fit: BoxFit.cover),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Uploading your image...',
                            style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onPrimary),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          LinearProgressIndicator(
                            color: kAppBlue,
                            backgroundColor: theme.colorScheme.surface,
                            minHeight: 1,
                          )
                        ],
                      ))
                    ],
                  ),
                );
              }
              if (state.status ==  FileManagerStatus.uploadImageFailed) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                      border: Border(
                          bottom: BorderSide(color: theme.colorScheme.outline),
                          top: BorderSide(color: theme.colorScheme.outline))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          color: theme.colorScheme.surface,
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(_localFile.value!, fit: BoxFit.cover),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            state.message,
                            style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onPrimary),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              _fileManagerCubit.uploadImage(file: _localFile.value!, bucketName: profilePictureBucket, fileTag: 0, groupId: fileUploadGroupId);
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'Retry',
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(Icons.refresh, size: 18),
                              ],
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const CustomBorderWidget(),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<FileManagerCubit, FileManagerState>(
                bloc: _fileManagerCubit,
                builder: (context, state) {
                  if (state.status == FileManagerStatus.uploadImageInProgress) {
                    return const SizedBox.shrink();
                  }
                  return ValueListenableBuilder(
                    valueListenable: _localFile,
                    builder:
                        (BuildContext context, File? value, Widget? child) {
                      return value == null
                          ? GestureDetector(
                              onTap: () {
                                _openGallery();
                              },
                              child: Icon(
                                Icons.add_circle,
                                color: theme.colorScheme.onPrimary,
                                size: 23,
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  );
                },
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical:10),
                  margin: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _localFile,
                        builder: (BuildContext context, File? value, Widget? child) {
                          return value != null ? SizedBox(
                                  height: 150,
                                  width: 165,
                                  child: Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.file(value,
                                                  height: 150,
                                                  width: 150,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _localFile.value = null;

                                            },
                                            child: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _messageController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              minLines: 1,
                              // maxLines: 4,
                              decoration: InputDecoration.collapsed(
                                  hintStyle: const TextStyle(fontSize: 14),
                                  hintText:
                                      'Message @${widget.networkResponse.username}'),
                              onChanged: (String value) {
                                _messageNotifier.value = value;
                              },
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: _messageNotifier,
                            builder: (BuildContext context, String value,
                                Widget? child) {
                              return GestureDetector(
                                onTap: () async {
                                  if (_messageController.text.isNotEmpty && _localFile.value == null) {
                                    _chatCubit.sendMessage(connection: widget.connection, text: value,);
                                    _messageController.clear();
                                    _messageNotifier.value = '';
                                    _localFile.value = null;
                                  } else if (_localFile.value != null) {
                                    if (_localFile.value == null) {
                                      return;
                                    }

                                  final response = await   _fileManagerCubit.uploadImage(file: _localFile.value!, bucketName: profilePictureBucket,fileTag: 1, groupId: fileUploadGroupId);
                                    if(response.isLeft()){
                                      if(mounted){
                                        context.showSnackBar('File Upload failed',appearance: Appearance.error);
                                      }
                                      return;
                                    }
                                    final fileItem = response.asRight();
                                    final preSignedUrl = fileItem.preSignedUrl;

                                    _chatCubit.sendMessage(connection: widget.connection, text: _messageController.text, attachment: Uri.encodeFull('${ApiConfig.profileUrl}/${preSignedUrl?.preSignedUrlFields?.key}'));

                                    // tempText = _messageController.text;
                                    _messageController.clear();
                                    _messageNotifier.value = '';
                                    _localFile.value = null;
                                  }
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: _isMessageSending,
                                  builder: (BuildContext context,
                                      bool loadingValue, Widget? child) {
                                    return  value.isNotEmpty || _localFile.value != null ? Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:  kAppBlue,
                                      ),
                                      child: loadingValue
                                          ? const Center(
                                              child: CupertinoActivityIndicator(
                                                  color: Colors.white),
                                            )
                                          : SvgPicture.asset(
                                              kSendIconSvg,
                                              color: kAppWhite,
                                              width: 15,
                                              // height: 22,
                                            ),
                                    ) : const SizedBox.shrink();
                                  },
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// pick an image/video
  _openGallery() async {
    final files = await pickFilesFromGallery(context);
    if (files == null || files.isEmpty) {
      return; // type determination is not expected to be null
    }
      // single file
      File? fileReturned = files[0];
      _localFile.value = fileReturned;
      // tempFile = fileReturned;
      // _messageNotifier.notifyListeners();

  }
}
