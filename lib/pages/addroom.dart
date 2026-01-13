import 'package:flutter/material.dart';
import '../components/layout.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoom> {
  final TextEditingController _roomNameController = TextEditingController();

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  void _saveRoom() {
    final roomName = _roomNameController.text.trim();

    if (roomName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room name cannot be empty")),
      );
      return;
    }
    Navigator.pop(context, roomName);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              const Text(
                "Add Room",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Enter Room Name",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _roomNameController,
            decoration: InputDecoration(
              hintText: "Room name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),

      buttonText: "Save",
      onButtonPressed: _saveRoom,
    );
  }
}
