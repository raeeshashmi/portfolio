import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(const RaeesPortfolioApp());

class RaeesPortfolioApp extends StatelessWidget {
  const RaeesPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raees Hashmi - Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
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
  int currentIndex = 0;
  final PageController _pageController = PageController();
  final List<String> tabs = ['Home', 'Experience', 'Skills', 'Education'];
  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      body: Stack(
        children: [
          AnimatedGradientBackground(controller: _bgController),
          SafeArea(
            child: Column(
              children: [
                TopNavBar(
                  tabs: tabs,
                  currentIndex: currentIndex,
                  isMobile: isMobile,
                  onTap: (i) {
                    setState(() => currentIndex = i);
                    _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubicEmphasized,
                    );
                  },
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => currentIndex = index),
                    children: const [
                      HomeAboutTab(),
                      ExperienceTab(),
                      SkillsTab(),
                      EducationTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopNavBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final bool isMobile;
  final Function(int) onTap;

  const TopNavBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 12 : 20,
      ),
      child: isMobile
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: tabs.asMap().entries.map((entry) {
                  final active = entry.key == currentIndex;
                  return GestureDetector(
                    onTap: () => onTap(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: active
                            ? const LinearGradient(
                                colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                              )
                            : null,
                        border: Border.all(
                          color: active
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: active ? Colors.white : Colors.white70,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: tabs.asMap().entries.map((entry) {
                final active = entry.key == currentIndex;
                return GestureDetector(
                  onTap: () => onTap(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: active
                          ? const LinearGradient(
                              colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                            )
                          : null,
                      border: Border.all(
                        color: active
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: active ? Colors.white : Colors.white70,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class AnimatedGradientBackground extends StatelessWidget {
  final AnimationController controller;
  const AnimatedGradientBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFF0F0C29),
                  const Color(0xFF1B1464),
                  controller.value,
                )!,
                Color.lerp(
                  const Color(0xFF302B63),
                  const Color(0xFF2C5364),
                  controller.value,
                )!,
                Color.lerp(
                  const Color(0xFF24243E),
                  const Color(0xFF000428),
                  controller.value,
                )!,
              ],
            ),
          ),
          child: Stack(
            children: const [
              Positioned(
                top: -150,
                left: -100,
                child: GlowCircle(color: Color(0xFF7C4DFF)),
              ),
              Positioned(
                bottom: -150,
                right: -100,
                child: GlowCircle(color: Color(0xFF00E5FF)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GlowCircle extends StatelessWidget {
  final Color color;
  const GlowCircle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 200,
            spreadRadius: 100,
          ),
        ],
      ),
    );
  }
}

// =================== CONTENT TABS ===================
class HomeAboutTab extends StatelessWidget {
  const HomeAboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00E5FF).withOpacity(0.5),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withOpacity(0.4),
                      blurRadius: 25,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const Text(
                'Hello, I’m',
                style: TextStyle(fontSize: 22, color: Colors.white70),
              ),
              const SizedBox(height: 8),

              // Name
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                ).createShader(bounds),
                child: const Text(
                  'Raees Hashmi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Role subtitle
              const Text(
                'Flutter Developer @ i9Experts',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.white70),
              ),
              const SizedBox(height: 30),

              // Description
              const FrostedCard(
                child: Text(
                  'A creative Flutter developer with a passion for crafting smooth, modern, and high-performance mobile apps.',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.6, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 30),

              // Social buttons
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: const [
                  SocialButton(
                    icon: FontAwesomeIcons.envelope,
                    label: 'Email',
                    url: 'mailto:raeeshashmi987@gmail.com',
                  ),
                  SocialButton(
                    icon: FontAwesomeIcons.github,
                    label: 'GitHub',
                    url: 'https://github.com/raeeshashmi',
                  ),
                  SocialButton(
                    icon: FontAwesomeIcons.linkedin,
                    label: 'LinkedIn',
                    url: 'https://linkedin.com/in/raeeshashmi',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FrostedCard extends StatelessWidget {
  final Widget child;
  const FrostedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 25),
        ],
      ),
      child: child,
    );
  }
}

class SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(widget.url))) {
            await launchUrl(
              Uri.parse(widget.url),
              mode: LaunchMode.externalApplication,
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()
            ..scale(_hovered && !isMobile ? 1.05 : 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: _hovered
                  ? [
                      const Color(0xFF7C4DFF).withOpacity(0.2),
                      const Color(0xFF00E5FF).withOpacity(0.2),
                    ]
                  : [Colors.white10, Colors.white12],
            ),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF00E5FF)
                  : Colors.white.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(widget.icon, color: const Color(0xFF00E5FF), size: 16),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(fontSize: 13, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========= SKILLS / EDUCATION / EXPERIENCE =========

class SkillsTab extends StatelessWidget {
  const SkillsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final skills = [
      'Flutter & Dart',
      'GetX / Provider / Bloc',
      'Firebase / Supabase',
      'REST API Integration',
      'App Deployment',
      'Git & GitHub',
      'UI/UX Design',
    ];
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Wrap(
            spacing: 18,
            runSpacing: 18,
            alignment: WrapAlignment.center,
            children: skills
                .map(
                  (s) => FrostedCard(
                    child: Text(
                      s,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class EducationTab extends StatelessWidget {
  const EducationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: const [
              InfoCard(
                imagePath: 'assets/images/uni_logo.png',
                title: 'University of Karachi',
                subtitle: 'Bachelor of Science in Computer Science',
                duration: 'Jan 2021 – Dec 2024',
              ),
              InfoCard(
                imagePath: 'assets/images/college_logo.jpeg',
                title: 'Bahria College Karsaz Karachi',
                subtitle: 'Intermediate in Pre-Engineering',
                duration: 'Aug 2018 – May 2020',
              ),
              InfoCard(
                imagePath: 'assets/images/school_logo.jpeg',
                title: 'White House English Secondary School',
                subtitle: 'Matriculation in Science',
                duration: 'Apr 2016 – Mar 2018',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExperienceTab extends StatelessWidget {
  const ExperienceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================== Company Section ==================
              const InfoCard(
                imagePath: 'assets/images/i9_logo.jpeg',
                title: 'i9Experts',
                subtitle: 'Flutter Developer',
                duration: 'Jan 2025 – Present',
              ),
              const SizedBox(height: 24),

              // ================== Project Section ==================
              Text(
                'Project',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 0)),
                ),
              ),
              const SizedBox(height: 16),

              FrostedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =============== Project Image ===============
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/van_logo.png',
                            fit: BoxFit.cover,
                            height: 80,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Project Title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                              ).createShader(bounds),
                              child: const Text(
                                'SmartVan',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SocialButton(
                                icon: FontAwesomeIcons.link,
                                label: 'View Project',
                                url: 'https://example.com/smartvan',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Project Description
                    const Text(
                      'SmartVan is the flagship mobile application developed for i9Experts. '
                      'It helps optimize fleet management through real-time GPS tracking, route optimization, and driver analytics. '
                      'Developed with Flutter and Firebase, it ensures smooth performance and an intuitive cross-platform user experience.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tech Stack
                    const Text(
                      'Tech Stack: Flutter • Firebase • REST APIs • Provider • Google Maps API',
                      style: TextStyle(fontSize: 14, color: Colors.white54),
                    ),

                    const SizedBox(height: 14),

                    // View Project Button
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String duration;

  const InfoCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 25),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 15, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  duration,
                  style: const TextStyle(fontSize: 14, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
