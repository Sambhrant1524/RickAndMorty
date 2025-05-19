import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../blocs/character_bloc.dart';
import '../blocs/character_state.dart';
import '../blocs/character_event.dart';
import '../models/character.dart';

class ExploreFeedScreen extends StatefulWidget {
  const ExploreFeedScreen({super.key});

  @override
  State<ExploreFeedScreen> createState() => _ExploreFeedScreenState();
}

class _ExploreFeedScreenState extends State<ExploreFeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharacterBloc>().add(CharacterFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger fetch when user scrolls to 80% of the list
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Explorer'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CharacterBloc>().add(CharacterRefreshed());
        },
        child: BlocBuilder<CharacterBloc, CharacterState>(
          buildWhen: (previous, current) => 
            previous.status != current.status || 
            previous.characters.length != current.characters.length,
          builder: (context, state) {
            if (state.status == CharacterStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == CharacterStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CharacterBloc>().add(CharacterRefreshed());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                CharacterGridView(characters: state.characters),
                if (state.status == CharacterStatus.loading && state.characters.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (state.hasReachedMax)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'You have reached the end!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CharacterGridView extends StatelessWidget {
  final List<Character> characters;

  const CharacterGridView({
    super.key,
    required this.characters,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return CharacterTile(character: characters[index]);
        },
        // Use Equatable for proper equality checks to prevent unnecessary rebuilds
        childCount: characters.length,
      ),
    );
  }
}

class CharacterTile extends StatelessWidget {
  final Character character;

  const CharacterTile({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    // Using const constructor for child widgets where possible
    return GestureDetector(
      onTap: () {
        // Show character details in a modal
        showModalBottomSheet(
          context: context,
          builder: (_) => CharacterDetails(character: character),
        );
      },
      child: Hero(
        tag: 'character_${character.id}',
        child: CachedNetworkImage(
          imageUrl: character.image,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}

class CharacterDetails extends StatelessWidget {
  final Character character;

  const CharacterDetails({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Hero(
                    tag: 'character_${character.id}',
                    child: CachedNetworkImage(
                      imageUrl: character.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Status: ${character.status}'),
                    Text('Species: ${character.species}'),
                    Text('Gender: ${character.gender}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}