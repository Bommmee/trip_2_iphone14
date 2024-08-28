import 'package:flutter/material.dart';

class VisitedPage extends StatefulWidget {
  final List<String> visitedPlaces;

  const VisitedPage({Key? key, required this.visitedPlaces}) : super(key: key);

  @override
  _VisitedPageState createState() => _VisitedPageState();
}

class _VisitedPageState extends State<VisitedPage> {
  late List<String> _visitedPlaces;

  @override
  void initState() {
    super.initState();
    _visitedPlaces = widget.visitedPlaces;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visited Places'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _visitedPlaces.isEmpty
            ? const Center(child: Text('No visited places yet.'))
            : ListView.builder(
                itemCount: _visitedPlaces.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_visitedPlaces[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _visitedPlaces.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
