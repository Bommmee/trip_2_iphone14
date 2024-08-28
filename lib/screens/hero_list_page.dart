import 'package:flutter/material.dart';
import 'package:tripsage/screens/second_page.dart';

class HeroListPage extends StatelessWidget {
  final Map<String, String> tourPlanData; // OnboardingPage에서 전달받은 데이터

  const HeroListPage({Key? key, required this.tourPlanData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView.builder(
            itemCount: _titles.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SecondPage(
                            heroTag: index,
                            likedPlaces: [],
                            tourPlanData: tourPlanData, // 전달받은 데이터를 그대로 전달
                          )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Hero(
                        tag: index,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _images[index],
                            width: 200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _titles[index],
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

final List<String> _titles = [
  'Seoul',
  'Busan',
  'Jeju Island',
  'California',
  'New York'
];

final List<String> _images = [
  'https://images.pexels.com/photos/26173418/pexels-photo-26173418.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://img.freepik.com/free-photo/gwangan-bridge-haeundae-busan-korea_335224-401.jpg?t=st=1724849243~exp=1724852843~hmac=df01a5e16ff96265ecf2a73177f2c4564cee628a3e912cacbc4b31b85cc09916&w=2000',
  'https://cdn.pixabay.com/photo/2022/06/24/05/35/ocean-7281047_1280.jpg',
  'https://images.pexels.com/photos/1591373/pexels-photo-1591373.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/462024/pexels-photo-462024.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
];
