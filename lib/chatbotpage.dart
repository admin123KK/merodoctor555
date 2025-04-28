import 'package:flutter/material.dart';
import 'package:merodoctor/profilepage.dart';

class Chatbotpage extends StatefulWidget {
  const Chatbotpage({super.key});

  @override
  State<Chatbotpage> createState() => _ChatbotpageState();
}

class _ChatbotpageState extends State<Chatbotpage> {
  final List<_Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    String text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text: text, isUser: true));
    });
    _controller.clear();
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 530), () {
      _addBotReply(text);
    });
  }

  void _addBotReply(String userMessage) {
    String botReply;

    if (userMessage.toLowerCase().contains('chor')) {
      botReply = 'Hi there! K help garna sakchu ma?';
    } else if (userMessage.toLowerCase().contains('help')) {
      botReply = 'Sure! Tell me what you need help with ma chu ta.';
    } else {
      botReply = 'tme  baula ho ';
    }
    setState(() {
      _messages.add(_Message(text: botReply, isUser: false));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), // 🛠️ Fixed here
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message.....',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1CA4AC)),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(
              Icons.send_outlined,
              color: Color(0xFF1CA4AC),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Profilepage()),
                    );
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 30,
                  ),
                ),
                const Text(
                  'MeroDoctor Sathi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Icon(Icons.more_vert_outlined),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;

  _Message({required this.text, required this.isUser});
}

class _MessageBubble extends StatelessWidget {
  final _Message message;

  const _MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = message.isUser ? Color(0xFF1CA4AC) : Colors.black;
    final textColor = Colors.white;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
    );
  }
}
