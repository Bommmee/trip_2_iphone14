import 'package:flutter/material.dart';
import 'package:tripsage/screens/gemini_response_page.dart';

class LikePage extends StatefulWidget {
  final List<String> likedPlaces;
  final Map<String, String> tourPlanData;

  const LikePage({
    Key? key,
    required this.likedPlaces,
    required this.tourPlanData,
  }) : super(key: key);

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late List<String> _likedPlaces;

  @override
  void initState() {
    super.initState();
    _likedPlaces = widget.likedPlaces;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Places'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _likedPlaces.isEmpty
                  ? const Center(child: Text('No liked places yet.'))
                  : ListView.builder(
                      itemCount: _likedPlaces.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_likedPlaces[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _likedPlaces.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _likedPlaces.isEmpty
                  ? null
                  : () => _goToGeminiResponsePage(context),
              child: const Text('Create Trip Plan'),
            ),
          ],
        ),
      ),
    );
  }

  void _goToGeminiResponsePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GeminiResponsePage(
          likedPlaces: _likedPlaces,
          tourPlanData: widget.tourPlanData,
        ),
      ),
    );
  }
}
