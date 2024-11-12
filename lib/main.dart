import 'package:flutter/material.dart';
import 'joke_service.dart'; // Import the service file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Joke App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final JokeService _jokeService = JokeService();
  List<String> _jokes = [];
  bool _isLoading = false;

  Future<void> _fetchJokes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final jokes = await _jokeService.fetchJokesRaw();
      setState(() {
        _jokes = jokes;
      });
    } catch (e) {
      setState(() {
        _jokes = ['Failed to load jokes!'];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _jokes.isNotEmpty
            ? ListView.builder(
          itemCount: _jokes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _jokes[index],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          },
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Press the button to get jokes!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchJokes,
        tooltip: 'Fetch Jokes',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
