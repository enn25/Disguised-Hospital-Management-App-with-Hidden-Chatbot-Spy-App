

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class ChatView extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.receiverName),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index].data() as Map<String, dynamic>;
                  final isMe = message['senderId'] == controller.authService.currentUser.value!.uid;
                  final timestamp = message['timestamp'] as Timestamp?;
                  final time = timestamp != null 
                      ? '${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}'
                      : '';

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isMe) ...[
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(message['senderPhoto'] ?? ''),
                          ),
                          SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: message['type'] == 'text' 
                                ? EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                                : EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                if (message['type'] == 'text') ...[
                                  Text(
                                    message['text'] ?? '',
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ] else if (message['type'] == 'image') ...[
                                  GestureDetector(
                                    onTap: () => _showFullScreenImage(context, message['url']),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        imageUrl: message['url'],
                                        placeholder: (context, url) => Container(
                                          width: 200,
                                          height: 200,
                                          child: Center(child: CircularProgressIndicator()),
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ] else if (message['type'] == 'video') ...[
                                  VideoThumbnail(
                                    videoUrl: message['url'],
                                    isMe: isMe,
                                  ),
                                ],
                                SizedBox(height: 2),
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: isMe ? Colors.white70 : Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isMe) ...[
                          SizedBox(width: 8),
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              controller.authService.currentUser.value?.photoURL ?? '',
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Obx(() {
            if (!controller.isUploading.value) return SizedBox.shrink();
            return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  LinearProgressIndicator(value: controller.uploadProgress.value),
                  SizedBox(height: 4),
                  Text(
                    'Uploading: ${(controller.uploadProgress.value * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () => _showMediaOptions(context),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    onChanged: (value) => controller.messageText.value = value,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () => controller.sendMessage(controller.messageText.value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take Photo'),
            onTap: () {
              Navigator.pop(context);
              controller.pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              controller.pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: Icon(Icons.videocam),
            title: Text('Upload Video'),
            onTap: () {
              Navigator.pop(context);
              controller.pickVideo();
            },
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}

class VideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final bool isMe;

  const VideoThumbnail({
    Key? key,
    required this.videoUrl,
    required this.isMe,
  }) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreenVideo(context),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
                child: Stack(
          alignment: Alignment.center,
          children: [
            if (_initialized)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              Center(
                child: CircularProgressIndicator(),
              ),
            Icon(
              Icons.play_circle_fill,
              size: 50,
              color: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenVideo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      _controller.pause();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}

