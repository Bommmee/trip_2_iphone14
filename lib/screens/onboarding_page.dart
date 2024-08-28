import 'package:flutter/material.dart';
import 'package:tripsage/screens/hero_list_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  String _selectedRelationship = '혼자';
  String _selectedLanguage = '한국어';
  List<String> _selectedInterests = [];
  int _peopleCount = 1; // 초기 인원 수
  String _selectedStartTime = '9:00 AM';
  String _selectedEndTime = '10:00 AM';
  String _selectedBudget = '5만원 이하';

  final List<String> _relationshipOptions = [
    '혼자',
    '친구랑',
    '연인이랑',
    '부모님과',
    '아이와'
  ];

  final List<String> _languageOptions = ['English', '한국어'];

  final List<String> _interestOptions = ['역사', '문화', '예술', '식당', '쇼핑', '체험'];

  final List<String> _timeOptions = [
    '8:00 AM',
    '8:30 AM',
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
    '9:30 PM',
    '10:00 PM',
    '10:30 PM',
    '11:00 PM',
  ];

  final List<String> _budgetOptions = [
    '5만원 이하',
    '5만~10만원 이하',
    '10만원~20만원 이하',
    '20만원~30만원 이하',
    '30만원~50만원 이하',
    '50만원~70만원 이하',
    '70만원~100만원 이하',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onboarding"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              items: _languageOptions.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: '언어',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRelationship,
              items: _relationshipOptions.map((String relationship) {
                return DropdownMenuItem<String>(
                  value: relationship,
                  child: Text(relationship),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRelationship = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: '관계',
              ),
            ),
            const SizedBox(height: 16),
            const Text('관심사 (다중 선택 가능)'),
            Wrap(
              children: _interestOptions.map((String interest) {
                return FilterChip(
                  label: Text(interest),
                  selected: _selectedInterests.contains(interest),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedInterests.add(interest);
                      } else {
                        _selectedInterests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('인원 수'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_peopleCount > 1) _peopleCount--;
                        });
                      },
                    ),
                    Text('$_peopleCount 명'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _peopleCount++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('여행 시간 선택'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStartTime,
                    items: _timeOptions.map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStartTime = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: '여행 시작시간',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedEndTime,
                    items: _timeOptions.map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEndTime = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: '여행 종료시간',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBudget,
              items: _budgetOptions.map((String budget) {
                return DropdownMenuItem<String>(
                  value: budget,
                  child: Text(budget),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBudget = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: '예산',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // 입력된 데이터를 처리하고 다음 페이지로 이동
                final tourPlanData = {
                  'relationship': _selectedRelationship,
                  'language': _selectedLanguage,
                  'peopleCount': _peopleCount.toString(),
                  'startTime': _selectedStartTime,
                  'endTime': _selectedEndTime,
                  'budget': _selectedBudget,
                  'interests': _selectedInterests.join(', '),
                };

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        HeroListPage(tourPlanData: tourPlanData),
                  ),
                );
              },
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
