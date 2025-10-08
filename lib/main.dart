import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const RaeesPortfolioApp());

class RaeesPortfolioApp extends StatelessWidget {
  const RaeesPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M. Raees Hashmi - Flutter Developer',
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

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
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => currentIndex = i),
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

// ================= NAVBAR =================

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
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 16 : 20,
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
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tabs.asMap().entries.map((entry) {
                      final active = entry.key == currentIndex;
                      return GestureDetector(
                        onTap: () => onTap(entry.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                        ),
                      ),
                    ],
                  ),
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
            color: const Color(0xFF00E5FF).withOpacity(0.5),
            blurRadius: 18,
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

// ================= BACKGROUND =================

class AnimatedGradientBackground extends StatelessWidget {
  final AnimationController controller;
  const AnimatedGradientBackground({super.key, required this.controller});

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

// ================= HOME =================

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final textAlign = isMobile ? TextAlign.center : TextAlign.start;
    final crossAlign = isMobile
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 40,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: crossAlign,
          children: [
            Text(
              '👋 Hello, I’m',
              textAlign: textAlign,
              style: TextStyle(
                fontSize: isMobile ? 18 : 22,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
              ).createShader(bounds),
              child: Text(
                'Raees Hashmi',
                textAlign: textAlign,
                style: TextStyle(
                  fontSize: isMobile ? 36 : 54,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Flutter Developer @ i9Experts',
              textAlign: textAlign,
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.white70,
              ),
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
                    'SmartVan — revolutionizing smart transportation using Flutter.',
                    style: TextStyle(height: 1.5, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
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
    );
  }
}

// ================= COMPONENTS =================

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
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 25),
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
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return MouseRegion(
      onEnter: (_) => !isMobile ? setState(() => hovered = true) : null,
      onExit: (_) => !isMobile ? setState(() => hovered = false) : null,
      child: GestureDetector(
        onTap: () async => await launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()
            ..scale(hovered && !isMobile ? 1.05 : 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: hovered
                  ? [
                      const Color(0xFF7C4DFF).withOpacity(0.2),
                      const Color(0xFF00E5FF).withOpacity(0.2),
                    ]
                  : [Colors.white10, Colors.white12],
            ),
            border: Border.all(
              color: hovered
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

// ================= OTHER TABS =================

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
      'Node.js Basics',
      'OOP / DSA',
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
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
    );
  }
}

class EducationTab extends StatelessWidget {
  const EducationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      shrinkWrap: true,
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
    );
  }
}

class ExperienceTab extends StatelessWidget {
  const ExperienceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      shrinkWrap: true,
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
    );
  }
}

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: const [
        FrostedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                'I focus on clean code, fluid UIs, and delightful digital experiences with Flutter, Firebase, and APIs.',
                style: TextStyle(height: 1.6, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
