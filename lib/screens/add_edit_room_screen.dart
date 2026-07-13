import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/room_service.dart';

class AddEditRoomScreen extends StatefulWidget {
  final Room? room; // null = adding a new room, not null = editing an existing one

  const AddEditRoomScreen({super.key, this.room});

  @override
  State<AddEditRoomScreen> createState() => _AddEditRoomScreenState();
}

class _AddEditRoomScreenState extends State<AddEditRoomScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late String _status;

  bool _isLoading = false;
  String? _errorMessage;

  bool get _isEditing => widget.room != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room?.name ?? '');
    _priceController = TextEditingController(text: widget.room?.price.toString() ?? '');
    _status = widget.room?.status ?? 'available';
  }

  Future<void> _handleSave() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (name.isEmpty || price == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter a valid name and price.';
      });
      return;
    }

    Map<String, dynamic> result;

    if (_isEditing) {
      result = await RoomService.updateRoom(widget.room!.id, name, price, _status);
    } else {
      result = await RoomService.addRoom(name, price, _status);
    }

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      if (!mounted) return;
      Navigator.pop(context); // go back to the room list
    } else {
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Room' : 'Add Room')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Room Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'available', child: Text('Available')),
                DropdownMenuItem(value: 'occupied', child: Text('Occupied')),
              ],
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _handleSave,
                    child: Text(_isEditing ? 'Save Changes' : 'Add Room'),
                  ),
          ],
        ),
      ),
    );
  }
}