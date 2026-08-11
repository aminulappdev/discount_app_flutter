import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/users/chat_view/controller/chat_controller.dart';
import 'package:discount_me_app/view/users/model/chat_model.dart';
import 'package:discount_me_app/view/users/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorChatScreen extends StatefulWidget { 
  const VendorChatScreen({super.key, this.conversation});
 
  final ChatItemModel? conversation;

  @override
  State<VendorChatScreen> createState() => _VendorChatScreenState();
}

class _VendorChatScreenState extends State<VendorChatScreen> {
  late final ChatController chatController;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatController = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());
    Future.microtask(() async {
      if (widget.conversation != null) {
        await chatController.openConversation(widget.conversation!);
      }
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final conversation =
        widget.conversation ?? chatController.selectedConversation.value;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(ImageUtils.homeBg),
          alignment: Alignment.topRight,
          opacity: 0.5,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    20.widthBox,
                    Expanded(
                      child: Row(
                        children: [
                          _avatar(
                            conversation == null
                                ? ''
                                : chatController.conversationImage(
                                    conversation,
                                  ),
                            40.w(context),
                          ),
                          10.widthBox,
                          Expanded(
                            child: CustomText(
                              title: conversation == null
                                  ? "Chat"
                                  : chatController.conversationTitle(
                                      conversation,
                                    ),
                              fontSize: 18.sp(context),
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              20.heightBox,
              Expanded(
                child: Obx(() {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  if (chatController.isMessageLoading.value &&
                      chatController.messages.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (chatController.messages.isEmpty) {
                    return Center(
                      child: CustomText(
                        title: "No messages yet",
                        fontSize: 16.sp(context),
                        color: Colors.black,
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: chatController.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatController.messages[index];
                      return _messageBubble(
                        context: context,
                        message: message,
                        width: width,
                      );
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 50.w(context),
                      height: 55.h(context),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(8.r(context)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          PickerDialog().showImagePickerDialog(context);
                        },
                        icon: Image.asset(
                          ImageUtils.fileAttachmentIcon,
                          scale: 4,
                        ),
                      ),
                    ),
                    10.widthBox,
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Message',
                          suffixIcon: IconButton(
                            onPressed: _sendMessage,
                            icon: Image.asset(
                              ImageUtils.msgSendIcon,
                              scale: 3.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r(context)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r(context)),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: ColorUtils.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageBubble({
    required BuildContext context,
    required MessageItemModel message,
    required double width,
  }) {
    final isSentByMe = chatController.isSentByMe(message);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(10.0),
          width: width * 0.70,
          decoration: BoxDecoration(
            color: isSentByMe
                ? ColorUtils.secondaryColor
                : ColorUtils.greenLightHover,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight:
                  isSentByMe ? Radius.circular(0) : Radius.circular(10),
              topLeft: isSentByMe ? Radius.circular(10) : Radius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text ?? '',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp(context),
                  color: isSentByMe ? Colors.white : Color(0xff1D242D),
                ),
              ),
              6.heightBox,
              Align(
                alignment:
                    isSentByMe ? Alignment.bottomRight : Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSentByMe)
                      Image.asset(
                        ImageUtils.sendIcon,
                        scale: 4,
                      ),
                    if (isSentByMe) 6.widthBox,
                    Text(
                      chatController.formatTime(message.createdAt),
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp(context),
                        fontWeight: FontWeight.w500,
                        color:
                            isSentByMe ? Colors.white : ColorUtils.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar(String image, double size) {
    final hasNetworkImage = image.startsWith('http');
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.r(context)),
      child: hasNetworkImage
          ? Image.network(
              image,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _assetAvatar(size),
            )
          : _assetAvatar(size),
    );
  }

  Widget _assetAvatar(double size) {
    return Image.asset(
      ImageUtils.profileImage,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    chatController.sendMessage(text);
    messageController.clear();
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}
