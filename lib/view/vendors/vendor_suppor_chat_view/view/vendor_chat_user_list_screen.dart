import 'package:discount_me_app/res/app_const/import_list.dart';
import 'package:discount_me_app/res/common_widget/RoundTextField.dart';
import 'package:discount_me_app/res/common_widget/custom_app_bar.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:discount_me_app/view/users/chat_view/controller/chat_controller.dart';
import 'package:discount_me_app/view/users/model/chat_model.dart';
import 'package:discount_me_app/view/vendors/vendor_suppor_chat_view/view/vendor_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorChatUserListScreen extends StatefulWidget { 
  const VendorChatUserListScreen({super.key}); 

  @override
  State<VendorChatUserListScreen> createState() =>
      _VendorChatUserListScreenState();
}

class _VendorChatUserListScreenState extends State<VendorChatUserListScreen> {
  late final ChatController chatController;

  @override
  void initState() {
    super.initState();
    chatController = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.fetchConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  appBarName: "Message",
                  leadingColor: Colors.black,
                  titleColor: Colors.black,
                  onTap: () => Get.back(),
                ),
                20.heightBox,
                RoundTextField(
                  borderColor: ColorUtils.black107,
                  fillColor: Colors.white,
                  hint: "Search conversation",
                  borderRadius: 20,
                  focusColor: Colors.transparent,
                  prefixIcon: Icon(Icons.search_outlined),
                  filled: true,
                  onChanged: (value) {  
                    chatController.searchTerm.value = value;
                    chatController.fetchConversations(search: value);
                  },
                ),
                20.heightBox, 
                Expanded(
                  child: Obx(() {
                    if (chatController.isConversationLoading.value &&
                        chatController.conversations.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (chatController.errorMessage.value.isNotEmpty &&
                        chatController.conversations.isEmpty) {
                      return Center(
                        child: CustomText(
                          title: chatController.errorMessage.value,
                          fontSize: 16.sp(context),
                          color: Colors.black,
                        ),
                      );
                    }

                    final visibleConversations = chatController.conversations
                        .where((conversation) {
                          final title = chatController
                              .conversationTitle(conversation)
                              .trim();
                          final lastMessage =
                              conversation.lastMessage?.toString().trim() ?? '';

                          return title.isNotEmpty &&
                              title.toLowerCase() != 'chat' &&
                              lastMessage.isNotEmpty;
                        })
                        .toList();

                    if (visibleConversations.isEmpty) {
                      return Center(
                        child: CustomText(
                          title: "No conversation found",
                          fontSize: 16.sp(context),
                          color: Colors.black,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => chatController.fetchConversations(),
                      child: ListView.builder(
                        itemCount: visibleConversations.length,
                        itemBuilder: (context, index) {
                          final conversation = visibleConversations[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: _userWidget(
                              context: context,
                              conversation: conversation,
                              onTap: () async {
                                await chatController
                                    .openConversation(conversation);
                                Get.to(
                                  () => VendorChatScreen(
                                    conversation: conversation,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userWidget({
    required BuildContext context,
    required ChatItemModel conversation,
    required VoidCallback onTap,
  }) {
    final image = chatController.conversationImage(conversation);
    final lastMessage = conversation.lastMessage?.toString() ?? '';
    final time = conversation.lastMessageAt is String
        ? chatController.formatTime(
            DateTime.tryParse(conversation.lastMessageAt.toString()),
          )
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  _avatar(image),
                  10.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: chatController.conversationTitle(conversation),
                          fontSize: 18.sp(context),
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        Text(
                          lastMessage.isEmpty
                              ? "Tap to start chat"
                              : lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp(context),
                            color: ColorUtils.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  title: time,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black,
                ),
                if ((conversation.unreadCount ?? 0) > 0) ...[
                  6.heightBox,
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: ColorUtils.secondaryColor,
                    child: Text(
                      conversation.unreadCount.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(String image) {
    final hasNetworkImage = image.startsWith('http');
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: hasNetworkImage
          ? Image.network(
              image,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _assetAvatar(),
            )
          : _assetAvatar(),
    );
  }

  Widget _assetAvatar() {
    return Image.asset(
      ImageUtils.profileImage,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
    );
  }
}
