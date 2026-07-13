# Room Booking App — Frontend

A Flutter mobile app for booking hotel/hostel rooms, built for a Mobile Application Development practical project. Connects to a Node.js/Express backend with JWT authentication.

## Tech Stack

- Flutter
- `http` package for API calls
- `shared_preferences` for storing the login token

## Features

- Login and Register screens, connected to the backend API
- Role-based navigation: Admins and Customers see different screens after logging in
- **Admin:** view all rooms, add a new room, edit an existing room's name/price/status
- **Customer:** view all rooms with Available/Occupied status, book any available room
- Logout button to end the session and return to the Login screen

## Setup

1. Make sure the backend server (`room-booking-backend`) is running first, at `http://localhost:3000`.

2. Install dependencies:
3. Run the app:
(Select Chrome, or an Android emulator, when prompted.)

## Notes

- The API base URL is set in `lib/services/auth_service.dart`, `room_service.dart`, and `booking_service.dart`. It currently points to `http://localhost:3000` for testing in Chrome. If running on an Android emulator instead, this should be changed to `http://10.0.2.2:3000`.
- Tested end-to-end, including the double-booking scenario with two separate customer accounts.