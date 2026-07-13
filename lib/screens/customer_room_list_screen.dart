import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/room_service.dart';
import '../services/booking_service.dart';
import '../services/token_storage.dart';
import 'login_screen.dart';

class CustomerRoomListScreen extends StatefulWidget {
  const CustomerRoomListScreen({super.key});

  @override
  State<CustomerRoomListScreen> createState() => _CustomerRoomListScreenState();
}

class _CustomerRoomListScreenState extends State<CustomerRoomListScreen> {
  late Future<List<Room>> _roomsFuture;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() {
    setState(() {
      _roomsFuture = RoomService.getRooms();
    });
  }

  Future<void> _handleBook(int roomId) async {
    setState(() {
      _isBooking = true;
    });

    final result = await BookingService.bookRoom(roomId);

    setState(() {
      _isBooking = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );

    if (result['success'] == true) {
      _loadRooms();
    }
  }

  Future<void> _handleLogout() async {
    await TokenStorage.clearSession();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Rooms')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Room>>(
              future: _roomsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final rooms = snapshot.data ?? [];

                if (rooms.isEmpty) {
                  return const Center(child: Text('No rooms available yet.'));
                }

                return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    final isAvailable = room.status == 'available';

                    return ListTile(
                      title: Text(room.name),
                      subtitle: Text(
                        '\$${room.price.toStringAsFixed(2)} — ${room.status}',
                        style: TextStyle(
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: (isAvailable && !_isBooking)
                            ? () => _handleBook(room.id)
                            : null,
                        child: Text(isAvailable ? 'Book' : 'Occupied'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}