import 'package:flutter/material.dart';
import 'package:first_video/features/home/domain/model/responce_msg.dart';
import 'package:flutter/services.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key, required this.rmessages, required this.index});

  final List<ResponceMsg> rmessages;
  final int index;

  @override
  Widget build(BuildContext context) {
    final message = rmessages[index];

    return GestureDetector(
      onLongPress: () {
        // например: показать меню (копировать, удалить)
        _showOptions(context, message.message);
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blueAccent, // фон сообщения
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message.message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy'),
            onTap: () {
              Navigator.pop(context);
              Clipboard.setData(ClipboardData(text: text));
            },
          ),
        ],
      ),
    );
  }
}
