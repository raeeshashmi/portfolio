import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(RaeesPortfolioApp());

class RaeesPortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raees Hashmi - Flutter Developer',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  final tabs = ['Home', 'Skills', 'Education', 'Experience', 'About'];

  late AnimationController _bgController;

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
                  onTap: (i) {
                    setState(() => currentIndex = i);
                    _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubicEmphasized,
                    );
                  },
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => currentIndex = index);
                    },
                    children: const [
                      HomeTab(),
                      SkillsTab(),
                      EducationTab(),
                      ExperienceTab(),
                      AboutTab(),
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

// ================= TOP NAV ===================

class TopNavBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final Function(int) onTap;

  const TopNavBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 22,
      ).copyWith(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => onTap(0),
            child: Row(
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
          ),
          Row(
            children: tabs.asMap().entries.map((entry) {
              final active = entry.key == currentIndex;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onTap(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
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
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: active ? Colors.white : Colors.white70,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 14,
                        letterSpacing: 0.7,
                      ),
                      child: Text(entry.value),
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
  const NeonBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
        ),
        borderRadius: BorderRadius.circular(14),
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

// ================= BACKGROUND ===================

class AnimatedGradientBackground extends StatelessWidget {
  final AnimationController controller;
  const AnimatedGradientBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
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
  const GlowCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 3),
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

// ================= HOME TAB ===================

class HomeTab extends StatelessWidget {
  const HomeTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(seconds: 1),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '👋 Hello, I’m',
                style: TextStyle(fontSize: 24, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                ).createShader(bounds),
                child: const Text(
                  'Raees Hashmi',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Flutter Developer @ i9Experts',
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              const SizedBox(height: 30),
              const FrostedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.rocket_launch,
                          color: Color(0xFF00E5FF),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Currently Working On',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'SmartVan — revolutionizing smart transportation using Flutter. Building performant, maintainable, and user-friendly apps.',
                      style: TextStyle(height: 1.5, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 12,
                children: const [
                  SocialButton(
                    icon: Icons.email,
                    label: 'Email',
                    url: 'mailto:raees@example.com',
                  ),
                  SocialButton(
                    icon: Icons.code,
                    label: 'GitHub',
                    url: 'https://github.com/yourusername',
                  ),
                  SocialButton(
                    icon: Icons.work,
                    label: 'LinkedIn',
                    url: 'https://linkedin.com/in/yourprofile',
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

// ================= REUSABLE WIDGETS ===================

class FrostedCard extends StatelessWidget {
  final Widget child;
  const FrostedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async => await launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()
            ..scale(_hovered ? 1.05 : 1.0)
            ..translate(0, _hovered ? -2.0 : 0),
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
              Icon(widget.icon, color: const Color(0xFF00E5FF), size: 16),
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

// ================= OTHER TABS ===================

class SkillsTab extends StatelessWidget {
  const SkillsTab();

  @override
  Widget build(BuildContext context) {
    final skills = [
      'Flutter & Dart',
      'GetX / Provider / Bloc',
      'Firebase / Supabase',
      'REST API Integration',
      'Git & GitHub',
      'UI/UX Design',
      'Node.js Basics',
      'OOP / DSA',
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 18,
          runSpacing: 18,
          alignment: WrapAlignment.center,
          children: skills
              .map(
                (skill) => FrostedCard(
                  child: Text(
                    skill,
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
  const EducationTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            FrostedCard(
              child: ListTile(
                title: Text(
                  'Bachelor of Science (BSc), Computer Science',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text('University of Karachi (UBIT) • 2021 – 2025'),
              ),
            ),
            SizedBox(height: 20),
            FrostedCard(
              child: ListTile(
                title: Text(
                  'Flutter Internship',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text('NexinIt • Jan 2024 – Jun 2024'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExperienceTab extends StatelessWidget {
  const ExperienceTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            FrostedCard(
              child: ListTile(
                title: Text(
                  'Flutter Developer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text('i9Experts • SmartVan Project'),
              ),
            ),
            SizedBox(height: 20),
            FrostedCard(
              child: ListTile(
                title: Text(
                  'Flutter Instructor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text('Aptech IIC • 2025'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutTab extends StatelessWidget {
  const AboutTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: FrostedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'About Me',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00E5FF),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'I’m M. Raees Hashmi — a passionate Flutter Developer crafting intuitive and performant apps. '
                'My focus is writing clean code, designing fluid UIs, and delivering delightful digital experiences with Flutter, Firebase, and APIs.',
                style: TextStyle(height: 1.6, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
