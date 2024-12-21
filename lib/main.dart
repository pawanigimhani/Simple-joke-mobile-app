import 'package:flutter/material.dart';
import 'joke_service.dart';
import 'joke_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joke App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50), // Material Green
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE8F5E9), width: 1),
          ),
        ),
      ),
      home: const MyHomePage(title: 'Fresh Jokes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final JokeService _jokeService = JokeService();
  List<Joke> _jokes = [];
  bool _isLoading = false;
  String _lastUpdate = '';
  late AnimationController _refreshIconController;

  @override
  void initState() {
    super.initState();
    _refreshIconController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _loadJokes();
  }

  @override
  void dispose() {
    _refreshIconController.dispose();
    super.dispose();
  }

  Future<void> _loadJokes() async {
    setState(() {
      _isLoading = true;
    });

    _refreshIconController.repeat();

    try {
      final jokes = await _jokeService.fetchJokes();
      final lastCacheDate = await _jokeService.getLastCacheDate();

      setState(() {
        _jokes = jokes;
        _lastUpdate = lastCacheDate != null
            ? 'Updated: ${DateTime.parse(lastCacheDate).toLocal().toString().split('.')[0]}'
            : '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      _refreshIconController.stop();
      _refreshIconController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Light green background
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32), // Dark green text
          ),
        ),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_lastUpdate.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8F5E9)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.update,
                      size: 14,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _lastUpdate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Finding fresh jokes...',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
                  : _jokes.isEmpty
                  ? Center(
                child: Text(
                  'No jokes available',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              )
                  : RefreshIndicator(
                color: Colors.green.shade600,
                onRefresh: _loadJokes,
                child: ListView.builder(
                  itemCount: _jokes.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: 'joke_${_jokes[index].id}',
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () => _showJokeDialog(_jokes[index]),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.emoji_emotions,
                                        size: 20,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Joke #${index + 1}',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _jokes[index].text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadJokes,
        tooltip: 'Refresh Jokes',
        backgroundColor: Colors.green.shade600,
        icon: RotationTransition(
          turns: _refreshIconController,
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
        label: const Text(
          'New Jokes',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showJokeDialog(Joke joke) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.sentiment_very_satisfied,
                  size: 40,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                joke.text,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.green.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green.shade600,
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}