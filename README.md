# Rick and Morty Explorer

A Flutter application that implements an Instagram-like Explore Feed with efficient pagination, rebuild management, and memory optimization. This app fetches character data from the Rick and Morty API and displays it in a responsive grid layout.

![App Screenshot](https://rickandmortyapi.com/api/character/avatar/1.jpeg)

## Features

- **Infinite Scroll Pagination**: Dynamically loads new images as the user scrolls down
- **Efficient Widget Rebuilds**: Optimized to prevent unnecessary rebuilds
- **Memory & Performance Management**: Handles large datasets without performance degradation
- **Clean Architecture**: Implements Bloc pattern with clear separation of concerns
- **Error Handling**: Graceful error handling with user-friendly messages and retry options
- **Pull-to-Refresh**: Easy data refreshing with pull gesture

## Architecture

This application follows the Bloc architectural pattern with three main layers:

### Presentation Layer
- UI components built with Flutter widgets
- Uses BlocBuilder with optimized rebuild conditions
- Implements SliverGrid for efficient rendering

### Business Logic Layer
- Bloc components handle state management and business logic
- Events represent user interactions and system events
- States represent the current UI state, including loading, success, and error states

### Data Layer
- Repository pattern for data fetching and manipulation
- Models for data representation and parsing

## Performance Optimizations

### Efficient Widget Rebuilds
- **BlocBuilder with buildWhen**: Prevents unnecessary rebuilds by setting specific conditions
- **Equatable**: Provides efficient equality comparisons for models and states
- **Const Constructors**: Used wherever possible to leverage Flutter's widget caching
- **Widget Breakdown**: UI split into smaller, focused widgets to limit rebuild scope

### Memory Management
- **CachedNetworkImage**: Efficiently loads and caches images
- **Controller Disposal**: Proper disposal of controllers to prevent memory leaks
- **SliverGrid**: Only renders visible items, reducing memory usage
- **Pagination**: Limits the amount of data held in memory at once

### Pagination Implementation
- **Preemptive Loading**: Triggers data fetch at 80% scroll position
- **Loading Indicators**: Shows loading state only when necessary
- **End of List Indication**: Clear feedback when all items are loaded

## Technical Implementation

### Key Libraries
- `flutter_bloc`: State management using the Bloc pattern
- `equatable`: Efficient equality comparisons
- `http`: API communications
- `cached_network_image`: Efficient image loading and caching

### Project Structure
```
lib/
├── main.dart                  # App entry point
├── models/                    # Data models
│   ├── character.dart         # Character model
│   └── pagination_info.dart   # Pagination metadata model
├── repositories/              # Data layer
│   └── character_repository.dart  # Handles API communication
├── blocs/                     # Business logic
│   ├── character_bloc.dart    # Character Bloc implementation
│   ├── character_event.dart   # Events for Character Bloc
│   └── character_state.dart   # States for Character Bloc
└── screens/                   # UI layer
    └── explore_feed_screen.dart  # Main screen implementation
```

## Getting Started

### Prerequisites
- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)

### Installation
1. Clone the repository:
```bash
git clone https://github.com/yourusername/rick_and_morty_explorer.git
```

2. Navigate to the project directory:
```bash
cd rick_and_morty_explorer
```

3. Get dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## API Reference

This application uses the [Rick and Morty API](https://rickandmortyapi.com/), a free RESTful API providing data about characters, locations, and episodes from the show.

```
GET https://rickandmortyapi.com/api/character
```

Response structure:
```json
{
  "info": {
    "count": 826,
    "pages": 42,
    "next": "https://rickandmortyapi.com/api/character/?page=2",
    "prev": null
  },
  "results": [
    {
      "id": 1,
      "name": "Rick Sanchez",
      "status": "Alive",
      "species": "Human",
      "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
      // ... other fields
    },
    // ... other characters
  ]
}
```

## Potential Improvements

- Add comprehensive unit and widget tests
- Implement persistent caching for offline access
- Add search, filter, and sort functionality
- Enhance UI with animations and transitions
- Implement more advanced error recovery strategies
- Add user preferences and customization options

## License

[MIT License](LICENSE)

## Acknowledgements

- [Rick and Morty API](https://rickandmortyapi.com/) for providing the data
- [Flutter Bloc](https://bloclibrary.dev/) for the state management solution
