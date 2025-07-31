import 'package:flutter/material.dart';
import '../models/meditation_session.dart';
import '../services/mental_health_service.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  List<MeditationSession> _meditations = [];
  List<MeditationSession> _filteredMeditations = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  int _selectedDifficulty = 0; // 0 = All

  final List<String> _categories = ['All', 'Mindfulness', 'Breathing', 'Relaxation', 'Compassion', 'Focus'];

  @override
  void initState() {
    super.initState();
    _loadMeditations();
  }

  Future<void> _loadMeditations() async {
    try {
      final meditations = await MentalHealthService.getMeditations();
      setState(() {
        _meditations = meditations.map((m) => MeditationSession(
          id: m.id,
          title: m.title,
          description: m.description,
          durationMinutes: m.durationMinutes,
          category: m.category,
          audioUrl: m.audioUrl,
          imageUrl: m.imageUrl,
          difficulty: 1,
          benefits: m.benefits,
        )).toList();
        _filteredMeditations = _meditations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterMeditations() {
    setState(() {
      _filteredMeditations = _meditations.where((meditation) {
        bool categoryMatch = _selectedCategory == 'All' || meditation.category == _selectedCategory;
        bool difficultyMatch = _selectedDifficulty == 0 || meditation.difficulty == _selectedDifficulty;
        return categoryMatch && difficultyMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Hero section with illustration
            _buildHeroSection(),
            
            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Current session card
                    _buildCurrentSessionCard(),
                    
                    const SizedBox(height: 20),
                    
                    // Meditation list
                    Expanded(
                      child: _buildMeditationList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.menu,
              color: Colors.grey[700],
              size: 20,
            ),
          ),
          const Text(
            'Meditation',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue[400],
            backgroundImage: const NetworkImage('https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0F8FF),
            Color(0xFFE6F3FF),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background mountains and landscape
          Positioned.fill(
            child: CustomPaint(
              painter: LandscapePainter(),
            ),
          ),
          
          // Meditation figure
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSessionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calming nature sounds',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage: const NetworkImage('https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sonree Ander Dresents decopnise wind ptear',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'Hietich',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationList() {
    final meditationItems = [
      {
        'title': 'Guided meditation',
        'items': [
          {
            'name': 'Essan proulty',
            'subtitle': 'Dheare provided editonard.',
            'hasClose': true,
          },
          {
            'name': 'Kelay slbolt',
            'subtitle': 'Dallung\'s rmeakternuse vantors',
            'duration': '10 min',
          },
          {
            'name': 'Green Daulkrulles',
            'subtitle': '',
            'duration': '15 min',
          },
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: meditationItems.length,
      itemBuilder: (context, sectionIndex) {
        final section = meditationItems[sectionIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['title'] as String,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Column(
              children: (section['items'] as List<Map<String, dynamic>>).map((item) =>
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: const NetworkImage('https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg'),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            if (item['subtitle'] != null && (item['subtitle'] as String).isNotEmpty)
                              Text(
                                item['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (item['hasClose'] == true)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                        )
                      else if (item['duration'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            item['duration'] as String,
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ).toList(),
            ),
          ],
        );
      },
    );
  }

  void _startMeditation(MeditationSession meditation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeditationPlayerScreen(meditation: meditation),
      ),
    );
  }
}

class LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Draw mountains
    paint.color = const Color(0xFFB8E6B8);
    final mountainPath = Path();
    mountainPath.moveTo(0, size.height * 0.6);
    mountainPath.lineTo(size.width * 0.3, size.height * 0.3);
    mountainPath.lineTo(size.width * 0.6, size.height * 0.5);
    mountainPath.lineTo(size.width, size.height * 0.4);
    mountainPath.lineTo(size.width, size.height);
    mountainPath.lineTo(0, size.height);
    mountainPath.close();
    canvas.drawPath(mountainPath, paint);
    
    // Draw water
    paint.color = const Color(0xFFADD8E6);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      paint,
    );
    
    // Draw clouds
    paint.color = Colors.white.withOpacity(0.8);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 20, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.15), 25, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MeditationPlayerScreen extends StatefulWidget {
  final MeditationSession meditation;

  const MeditationPlayerScreen({super.key, required this.meditation});

  @override
  _MeditationPlayerScreenState createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen> {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.meditation.durationMinutes * 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text(widget.meditation.title),
        backgroundColor: Colors.purple[400],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            
            // Meditation Visual
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.purple[300]!, Colors.purple[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.self_improvement,
                size: 80,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 40),
            
            Text(
              widget.meditation.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              widget.meditation.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Progress
            Text(
              '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')} / ${(_totalSeconds ~/ 60).toString().padLeft(2, '0')}:${(_totalSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 20),
            
            LinearProgressIndicator(
              value: _totalSeconds > 0 ? _currentSeconds / _totalSeconds : 0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
            ),
            
            const SizedBox(height: 40),
            
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentSeconds = 0;
                    });
                  },
                  icon: const Icon(Icons.replay, size: 32),
                  color: Colors.grey[600],
                ),
                
                const SizedBox(width: 20),
                
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple[400],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                      
                      if (_isPlaying) {
                        _startTimer();
                      }
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                IconButton(
                  onPressed: () {
                    _completeMeditation();
                  },
                  icon: const Icon(Icons.stop, size: 32),
                  color: Colors.grey[600],
                ),
              ],
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    if (_isPlaying && _currentSeconds < _totalSeconds) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isPlaying && mounted) {
          setState(() {
            _currentSeconds++;
          });
          
          if (_currentSeconds < _totalSeconds) {
            _startTimer();
          } else {
            _completeMeditation();
          }
        }
      });
    }
  }

  void _completeMeditation() {
    final completion = CompletedMeditation(
      sessionId: widget.meditation.id,
      completedAt: DateTime.now(),
      actualDuration: _currentSeconds ~/ 60,
      rating: 5, // Default rating
    );
    
    MentalHealthService.completeMeditation(completion);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Meditation Complete!'),
        content: const Text('Great job! You\'ve completed your meditation session.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}