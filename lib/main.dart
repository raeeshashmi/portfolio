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
      title: 'M. Raees Hashmi - Flutter Developer',
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
  final List<String> tabs = [
    'Home & About',
    'Skills',
    'Education',
    'Experience',
  ];
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
                      SkillsTab(),
                      EducationTab(),
                      ExperienceTab(),
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
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const NeonBadge(),
                    const SizedBox(width: 10),
                    Text(
                      'Raees Hashmi',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
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
                                    colors: [
                                      Color(0xFF7C4DFF),
                                      Color(0xFF00E5FF),
                                    ],
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
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const NeonBadge(),
                    const SizedBox(width: 12),
                    Text(
                      'Raees Hashmi',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                Row(
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
                                  colors: [
                                    Color(0xFF7C4DFF),
                                    Color(0xFF00E5FF),
                                  ],
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
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}

class NeonBadge extends StatelessWidget {
  const NeonBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 3,
          ),
        ],
      ),
      child: const Text(
        'R',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
    final isMobile = MediaQuery.of(context).size.width < 700;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            // ===== Profile Image =====
            Center(
              child: Container(
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
                    'images/profile.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const Text(
              'Hello, I’m',
              style: TextStyle(fontSize: 22, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
              ).createShader(bounds),
              child: const Text(
                'Raees Hashmi',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Flutter Developer @ i9Experts',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            const FrostedCard(
              child: Text(
                'I’m a passionate Flutter Developer focused on creating smooth, scalable, and responsive apps using Flutter, Firebase, and REST APIs.',
                style: TextStyle(height: 1.6, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 30),
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
      'Git & GitHub',
      'UI/UX Design',
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Wrap(
          spacing: 18,
          runSpacing: 18,
          alignment: WrapAlignment.center,
          children: skills
              .map(
                (s) => FrostedCard(
                  child: Text(
                    s,
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
    );
  }
}

class EducationTab extends StatelessWidget {
  const EducationTab({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          FrostedCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white24,
                backgroundImage: AssetImage(
                  'images/uni_logo.png',
                ),
              ),
              title: Text(
                'BSc Computer Science',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('University of Karachi • Jan 2021 - Dec 2024'),
            ),
          ),
          FrostedCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white24,
                backgroundImage: AssetImage('images/college_logo.jpeg'),
              ),
              title: Text(
                'FSc Pre-Engineering',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('Bahria College Karsaz Karachi • 2018 - 2020'),
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceTab extends StatelessWidget {
  const ExperienceTab({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: const [
          FrostedCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white24,
                backgroundImage: AssetImage('images/i9_logo.jpeg'),
              ),
              title: Text(
                'Flutter Developer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('i9Experts • Jan 2025 – Present'),
            ),
          ),
        ],
      ),
    );
  }
}
