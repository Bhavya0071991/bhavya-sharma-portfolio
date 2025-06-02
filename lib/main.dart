import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        fontFamily: 'Poppins', // Default font for the app
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'PlayfairDisplay',
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            color: Colors.amber,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.5,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _currentPage = _pageController.page?.round() ?? 0;
    });
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.orange.withOpacity(0.3),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/banner.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Main content
          Column(
            children: [
              // Navigation bar
              Padding(
                padding: const EdgeInsets.only(
                  top: 50.0,
                  bottom: 50.0,
                  left: 110.0,
                  right: 110.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _animationController.value,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Open to work',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final url = Uri.parse('https://docs.google.com/document/d/1CvnDnWMCKYow0qwH0aG6RJY7XsvEs5wR/edit?usp=sharing&ouid=114414961108850837228&rtpof=true&sd=true');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      child: const Text(
                        'Download CV',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'AlbertSans',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // PageView for scrollable sections
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return _buildHomePage(context);
                      case 1:
                        return _buildSummaryPage();
                      case 2:
                        return _buildExperiencePage();
                      case 3:
                        return _buildSkillsPage();
                      case 4:
                        return _buildLinksPage();
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              // Bottom navigation
              Container(
                height: 50,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavButton(
                      Icons.person_outline,
                      'Home',
                      _currentPage == 0,
                      0,
                    ),
                    _buildNavButton(
                      Icons.description_outlined,
                      'Summary',
                      _currentPage == 1,
                      1,
                    ),
                    _buildNavButton(
                      Icons.work_outline,
                      'Experience',
                      _currentPage == 2,
                      2,
                    ),
                    _buildNavButton(
                      Icons.psychology_outlined,
                      'Skills',
                      _currentPage == 3,
                      3,
                    ),
                    _buildNavButton(Icons.link, 'Hobbies', _currentPage == 4, 4),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    IconData icon,
    String label,
    bool isSelected,
    int page,
  ) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        height: 60,
        child: TextButton.icon(
          onPressed: () => _navigateToPage(page),
          icon: Icon(
            icon,
            color: isSelected ? Colors.black : Colors.white54,
            size: 20,
          ),
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white54,
              fontSize: 14,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: isSelected ? Colors.white : null,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return Stack(
      children: [
        // Background Image with Fade Effect
        Positioned.fill(
          child: Image.asset(
            'assets/banner3.png',
            fit: BoxFit.cover,
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.only(
            left: 100.0,
            right: 32.0,
            top: 15.0,
            bottom: 32.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MOBILE APP DEVELOPER',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  fontFamily: 'AlbertSans',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Bhavya Sharma',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'AlbertSans',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 550,
                child: Text(
                  '4+ years of experience in Mobile App Development\nSpecializing in Android Native (Kotlin) and Flutter (Dart). Skilled in working with cross-functional teams, ensuring seamless collaboration to deliver high-quality and scalable applications within deadlines. ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),
              const ContactInfo(
                email: 'bhavya.007@hotmail.com',
                phone: '7307101259',
                linkedin: 'linkedin.com/in/bhavya-sharma-96411542/',
                location: 'Chandigarh',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryPage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 100.0,
        right: 100.0,
        top: 15.0,
        bottom: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: const Text(
              'I am an experienced and detail-oriented Mobile App Developer dedicated to '
              'creating intuitive and impactful digital experiences. Over the years, I have '
              'honed my skills in Android Native and Flutter development, always striving to '
              'balance user needs with business objectives. My passion lies in understanding '
              'how people interact with mobile applications and crafting solutions that are '
              'both functional and aesthetically pleasing.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: const Text(
              'I have collaborated with diverse teams, including developers, marketers, and '
              'product managers, to bring concepts to life, ensuring seamless integration of '
              'design and functionality. My development philosophy centers on clean code and '
              'innovation—placing the user at the heart of every decision while leveraging '
              'the latest tools and trends to stay ahead in the field.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.amber, width: 4)),
            ),
            child: Text(
              'Driven by a curiosity to learn and improve, I continuously explore new '
              'tools and methodologies to enhance my work. Whether working on Android '
              'applications, Flutter interfaces, or cross-platform solutions, I am '
              'committed to delivering high-quality results that exceed expectations.',
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperiencePage() {
    return SingleChildScrollView(
      physics: CarouselScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 100.0,
          right: 100.0,
          top: 15.0,
          bottom: 2.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Work Experience',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 32),
            // Experience Item
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Mobile App Developer',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      '2022 - Present',
                      style: TextStyle(color: Colors.amber, fontSize: 16),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    'Snakescript LLP',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    'At Snake-script LLP, I lead developed efforts on a range of high-profile projects, '
                    'Developed Android (Kotlin) and Flutter applications for both Android and iOS.'
                    'Implemented one-on-one video and voice calling using Agora SDK.'
                    'Integrated speech-to-text features and background notifications with Firebase.'
                    'Developed real-time chat functionalities using sockets and API calls with Dio.'
                    'Currently started working on Cursor AI IDE which reduces development time as well',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Selected Projects Section
            const Text(
              'Projects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 24),
            // Project Grid
            Row(
              children: [
                Expanded(
                  child: _buildProjectCard(
                    'Breath & Heart',
                    'This app is developer in native android. This app is to meditate and to improve your health',
                    'assets/breathnheart.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProjectCard(
                    'HHA 365',
                    'This app is developed in flutter, uses to manage caregivers and patients',
                    'assets/hha.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProjectCard(
                    'NP 168',
                    'NP168 is designed to empower network providers in the home health care industry.',
                    'assets/np168.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProjectCard(
                    'Prodriver & Prodrive',
                    'This app is developer in flutter and uses to manage drivers and vehicles.',
                    'assets/prodriver.png',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildProjectCard(
                    'Whel App',
                    'This app is developed in flutter and uses to manage to connect patients with doctors',
                    'assets/whelapp.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProjectCard(
                    'Clock-In',
                    'This app is developed in flutter and this app is used to clock in and out of drivers.',
                    'assets/clockin.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProjectCard(
                    'Shopnet',
                    'This app is developed in flutter and it provide domain suggestions for your business',
                    'assets/shopnet.png',
                  ),
                ),
              ],
            ),
            // Add the education section here
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Android Developer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Nov 2022 - June 2023',
                  style: TextStyle(color: Colors.amber, fontSize: 16),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24),
              child: Text(
                'Glocify Technologies',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(left: 24),
              child: Text(
                'At Glocify, I had developed a mobile app for a client which he used in his business, app was not published on play store but it was used in his business. Irs called "Tracebaility", I was working on Temple Bliss app which was a terocard reader app which used to work using video and audio calls using Twillio. Here i started learning flutter. ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Selected Projects Section
            const Text(
              'Projects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 24),
            // Project Grid
            Row(
              children: [
                Expanded(
                  child: _buildProjectCard(
                    'Temple Bliss',
                    'This app is developed in Android Native (Kotlin) and This app gives the most accurate psychic readings from real psychics LIVE on TempleBliss',
                    'assets/templebliss.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProjectCard(
                    'Traceability',
                    'This app is developed in in Android Native (Kotlin), This app is a Data management app for tracking and storing harvest product information.',
                    'assets/traceability.png',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Jr. Android Developer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Dec 2020 - Oct 2022',
                  style: TextStyle(color: Colors.amber, fontSize: 16),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24),
              child: Text(
                'Deftsoft',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(left: 24),
              child: Text(
                'At Deftsoft, Developed robust Android applications in collaboration with cross-functional teams. Integrated third-party libraries and APIs for enhanced app functionalities. Gained experience in performance optimization and troubleshooting application issues. ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Selected Projects Section
            const Text(
              'Projects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 24),
            // Project Grid
            Row(
              children: [
                Expanded(
                  child: _buildProjectCard(
                    'Charmed Visions',
                    'Share your best memories and experience the new style of vision boards. Get your photos out of your phone and on your wrist in minutes not hours with the charmed visions app.',
                    'assets/charemdvisions.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProjectCard(
                    'Builder App  ',
                    'Android app built with MVVM architecture, Room Database, and Recycler View',
                    'assets/builder.png',
                  ),
                ),
              ],
            ),
            _buildEducationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, String imagePath) {
    return Padding(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8.0, bottom: 16.0),
      child: Container(
        width: 245,
        height: 260,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1, // Limit to 1 line
                          overflow:
                              TextOverflow
                                  .ellipsis, // Show ... if text overflows
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white.withOpacity(0.8),
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          // Add share functionality here
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 50,
                    child: Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity, // Make container take full width
                color: Colors.black45,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 100.0,
          right: 32.0,
          top: 15.0,
          bottom: 32.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills & Tools',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 48),
            // Skills Section
            Wrap(
              spacing: 48,
              runSpacing: 20,
              children: [
                _buildSkillItem('Kotlin'),
                _buildSkillItem('Java'),
                _buildSkillItem('Flutter'),
                _buildSkillItem('Firebase'),
                _buildSkillItem('Dart'),
                _buildSkillItem('MVVM (Model-View-View Model)'),
                _buildSkillItem('Jetpack Components'),
                _buildSkillItem('Dependency Injection'),
                _buildSkillItem('Navigation Component'),
                _buildSkillItem('Room Database'),
                _buildSkillItem('Retrofit'),
                _buildSkillItem('Coroutines'),
                _buildSkillItem('async/await'),
                _buildSkillItem('GetX'),
                _buildSkillItem('Third-party SDKs'),
                     
              ],
            ),
            const SizedBox(height: 64),
            // Tools Section
            Wrap(
              spacing: 32,
              runSpacing: 32,
              children: [
                _buildToolItem('Flutter', 'assets/flutter_logo.png'),
                _buildToolItem('Android Studio', 'assets/android_studio.png'),
                _buildToolItem('Firebase', 'assets/firebase_logo.png'),
                _buildToolItem('Cursor AI', 'assets/cursor_logo.png'),
                _buildToolItem('Figma', 'assets/figma_logo.webp'),
                _buildToolItem('Agora SDK', 'assets/agora_logo.webp'),
                _buildToolItem('Git', 'assets/github_logo.webp'),
                _buildToolItem('Jira', 'assets/jira_logo.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(String skill) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          skill,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildToolItem(String name, String imagePath) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildLinksPage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 100.0,
        right: 32.0,
        top: 15.0,
        bottom: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interests & Hobbies',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 48),
          // Social Media Links
          // Wrap(
          //   spacing: 16,
          //   children: [
          //     _buildSocialButton('LinkedIn', Icons.contact_page, Colors.blue),
          //     _buildSocialButton(
          //       'Dribbble',
          //       Icons.sports_basketball,
          //       const Color(0xFFEA4C89),
          //     ),
          //     _buildSocialButton('Twitter', Icons.flutter_dash, Colors.black),
          //     _buildSocialButton('Instagram', Icons.camera_alt, Colors.purple),
          //     _buildSocialButton('Behance', Icons.brush, Colors.black),
          //   ],
          // ),
         
          //const SizedBox(height: 48),
          // Interests & Hobbies Section
          // const Text(
          //   'Interests & Hobbies',
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.w600,
          //     color: Colors.amber,
          //   ),
          // ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildInterestChip('Hiking & V-logging'),
              _buildInterestChip('Video Editing'),
              _buildInterestChip('Singing & Playing Guitar'),
              _buildInterestChip('Coding in Pressure-Free Environments'),
              _buildInterestChip('Bike Riding'),
            ],
          ),
 const SizedBox(height: 60),
          Row(
            children: [
              _buildContactLink(
                Icons.email,
                'bhavya.007@hotmail.com',
                Colors.amber,
              ),
              const SizedBox(width: 32),
              _buildContactLink(Icons.phone, '7307101259', Colors.amber),
            ],
          ),
          // Contact Information
          const Spacer(),
          // Footer
          const Text(
            '© 2025 Portfolio by Bhavya Sharma',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String name, IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 28,
        onPressed: () {
          // Add your social media link handling here
        },
      ),
    );
  }

  Widget _buildContactLink(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildInterestChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        const Text(
          'Education',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 24),
        // Education items
        _buildEducationItem(
          degree: 'Bachelor of Technology in Information Technology',
          institution: 'Loveley Professional University, Jalandhar',
          duration: '2008 - 2014',
          description:
              'Graduated with honors, focusing on mobile application development and software engineering principles.',
        ),
        const SizedBox(height: 24),
        _buildEducationItem(
          degree: 'Higher Secondary Education',
          institution: 'DAV Sr Sec School, Mandi (H.P)',
          duration: '2006 - 2008',
          description: 'Completed with Computer Science and Mathematics.',
        ),
      ],
    );
  }

  Widget _buildEducationItem({
    required String degree,
    required String institution,
    required String duration,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  degree,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              duration,
              style: const TextStyle(color: Colors.amber, fontSize: 16),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                institution,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ContactInfo extends StatelessWidget {
  final String email;
  final String phone;
  final String linkedin;
  final String location;

  const ContactInfo({
    super.key,
    required this.email,
    required this.phone,
    required this.linkedin,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildContactRow(Icons.email, email),
            const SizedBox(width: 150),
            _buildContactRow(Icons.phone, phone),
          ],
        ),

        const SizedBox(height: 25),
        Row(
          children: [
            _buildContactRow(Icons.contact_page, linkedin),
            const SizedBox(width: 40),
            _buildContactRow(Icons.location_on, location),
          ],
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
