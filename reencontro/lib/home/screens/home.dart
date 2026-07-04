import 'dart:io';

import 'package:apple_maps_flutter/apple_maps_flutter.dart' as mapkit;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as osm;

import '../../models/app_models.dart';
import '../../services/auth_service.dart';

class ReencontroHomeScreen extends StatefulWidget {
  const ReencontroHomeScreen({super.key});

  @override
  State<ReencontroHomeScreen> createState() => _ReencontroHomeScreenState();
}

class _ReencontroHomeScreenState extends State<ReencontroHomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages = const [
    _FeedHomeScreen(),
    _MissingRegistryScreen(),
    _FoundRegistryScreen(),
    _MapOverviewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentIndex,
        onChanged: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _FeedHomeScreen extends StatelessWidget {
  const _FeedHomeScreen();

  Stream<List<MissingPersonCase>> _missingPeopleStream() {
    return FirebaseFirestore.instance
        .collection('missing_people')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MissingPersonCase.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  Stream<List<SupportCenter>> _centersStream() {
    return FirebaseFirestore.instance
        .collection('support_centers')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SupportCenter.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  Stream<List<UpdateItem>> _updatesStream() {
    return FirebaseFirestore.instance.collection('updates').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => UpdateItem.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VolunteerProfile?>(
      stream: AuthService.instance.currentProfile(),
      builder: (context, profileSnapshot) {
        final profile = profileSnapshot.data;
        return ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            _TopHeader(profile: profile),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _SupportMarquee(
                messages: const [
                  'Centros de apoio com kits de higiene disponíveis em Beira.',
                  'Equipa médica móvel a caminho de Dondo.',
                  'Último sincronismo concluído com sucesso.',
                ],
              ),
            ),
            StreamBuilder<List<MissingPersonCase>>(
              stream: _missingPeopleStream(),
              builder: (context, snapshot) {
                final people = snapshot.data ?? const <MissingPersonCase>[];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: _LostPeopleCarousel(people: people),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _CriticalAlertCard(),
                  const SizedBox(height: 24),
                  const _ActionSectionHeader(
                    title: 'Fluxos principais',
                    subtitle: 'Ações rápidas para resposta imediata',
                  ),
                  const SizedBox(height: 14),
                  _HeroActionCard(
                    title: 'Procurar Pessoa',
                    description:
                        'Registe um familiar ou amigo desaparecido para ajuda imediata.',
                    icon: Icons.person_search,
                    color: const Color(0xFFFE6B00),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const _MissingRegistryScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _HeroActionCard(
                    title: 'Encontrei Alguém',
                    description:
                        'Registe uma pessoa encontrada para reunir famílias.',
                    icon: Icons.how_to_reg,
                    color: const Color(0xFF006722),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const _FoundRegistryScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const _ActionSectionHeader(
                    title: 'Impacto em Tempo Real',
                    subtitle: 'Indicadores operacionais',
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<List<MissingPersonCase>>(
                    stream: _missingPeopleStream(),
                    builder: (context, missingSnapshot) {
                      final missing =
                          missingSnapshot.data ?? const <MissingPersonCase>[];
                      return StreamBuilder<List<UpdateItem>>(
                        stream: _updatesStream(),
                        builder: (context, updatesSnapshot) {
                          final updates =
                              updatesSnapshot.data ?? const <UpdateItem>[];
                          return Row(
                            children: [
                              Expanded(
                                child: _ImpactCard(
                                  value: '${missing.length}',
                                  label: 'Desaparecidos',
                                  tone: const Color(0xFF003F87),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _ImpactCard(
                                  value:
                                      '${updates.where((item) => item.status == 'Encontrada').length}',
                                  label: 'Reencontros',
                                  tone: const Color(0xFF006722),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const _ActionSectionHeader(
                    title: 'Centros de Apoio',
                    subtitle: 'Abrigos e apoio mais próximos',
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<List<SupportCenter>>(
                    stream: _centersStream(),
                    builder: (context, centersSnapshot) {
                      final centers =
                          centersSnapshot.data ?? const <SupportCenter>[];
                      final preview = centers.take(3).toList();
                      return _SupportCentersPreview(centers: preview);
                    },
                  ),
                  const SizedBox(height: 24),
                  const _ActionSectionHeader(
                    title: 'Últimas Actualizações',
                    subtitle: 'Registos recentes com detalhe',
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<List<UpdateItem>>(
                    stream: _updatesStream(),
                    builder: (context, updatesSnapshot) {
                      final updates =
                          updatesSnapshot.data ?? const <UpdateItem>[];
                      return _RecentUpdatesList(updates: updates);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.profile});

  final VolunteerProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFC2C6D4))),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Reencontro MZ',
              style: TextStyle(
                color: Color(0xFF003F87),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => Navigator.pushNamed(context, '/settings'),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: profile?.photoUrl != null
                  ? NetworkImage(profile!.photoUrl!)
                  : null,
              child: profile?.photoUrl == null
                  ? const Icon(Icons.person, size: 18)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportMarquee extends StatelessWidget {
  const _SupportMarquee({required this.messages});

  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAE7E7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: messages
              .expand(
                (message) => [
                  const Icon(Icons.campaign_outlined, color: Color(0xFF003F87)),
                  const SizedBox(width: 8),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Color(0xFF1C1B1B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              )
              .toList(),
        ),
      ),
    );
  }
}

class _LostPeopleCarousel extends StatefulWidget {
  const _LostPeopleCarousel({required this.people});

  final List<MissingPersonCase> people;

  @override
  State<_LostPeopleCarousel> createState() => _LostPeopleCarouselState();
}

class _LostPeopleCarouselState extends State<_LostPeopleCarousel> {
  final _controller = PageController(viewportFraction: 0.88);
  int _activeIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.people.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pessoas perdidas em destaque',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text(
          'Deslize para ver casos recentes e ajudar na identificação.',
          style: TextStyle(
            color: Color(0xFF424752),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.people.length,
            onPageChanged: (index) => setState(() => _activeIndex = index),
            itemBuilder: (context, index) {
              final person = widget.people[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => MissingPeopleDetailScreen(
                          people: widget.people,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: _MissingHeroCard(person: person),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.people.length, (index) {
            final active = index == _activeIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: active ? 22 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF003F87)
                    : const Color(0xFFC2C6D4),
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _MissingHeroCard extends StatelessWidget {
  const _MissingHeroCard({required this.person});

  final MissingPersonCase person;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(person.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.1),
              Colors.black.withValues(alpha: 0.72),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  person.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${person.name}, ${person.age}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                person.location,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                person.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MissingPeopleDetailScreen extends StatefulWidget {
  const MissingPeopleDetailScreen({
    super.key,
    required this.people,
    required this.initialIndex,
  });

  final List<MissingPersonCase> people;
  final int initialIndex;

  @override
  State<MissingPeopleDetailScreen> createState() =>
      _MissingPeopleDetailScreenState();
}

class _MissingPeopleDetailScreenState extends State<MissingPeopleDetailScreen> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.people.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final person = widget.people[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(person.imageUrl, fit: BoxFit.cover),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.24),
                            Colors.black.withValues(alpha: 0.82),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 88, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              person.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            person.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${person.age} • ${person.location}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            person.lastSeen,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            person.description,
                            style: const TextStyle(
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF003F87),
                                  ),
                                  onPressed: () {},
                                  child: const Text('Partilhar caso'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFE6B00),
                                  ),
                                  onPressed: () {},
                                  child: const Text('Marcar pista'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              left: 16,
              top: 16,
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 24,
              child: Text(
                '${_currentIndex + 1}/${widget.people.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroActionCard extends StatelessWidget {
  const _HeroActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 140),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -6,
              top: -10,
              child: Icon(
                icon,
                size: 86,
                color: Colors.white.withValues(alpha: 0.22),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white, height: 1.4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({
    required this.value,
    required this.label,
    required this.tone,
  });

  final String value;
  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2C6D4)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: tone,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF424752),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportCentersPreview extends StatelessWidget {
  const _SupportCentersPreview({required this.centers});

  final List<SupportCenter> centers;

  @override
  Widget build(BuildContext context) {
    if (centers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const _MapOverviewScreen(),
              ),
            );
          },
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC2C6D4)),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBvZgoeltsFfCTG1m--4i5IeLWkhRdUx6Q7WeKQFjPz3N1r82_NeEC4tszmPoYuE4D6miKvj543pwyRAHEi7OgUmYCaS4H2Sp2puW6m0IZqNTQULP0VYWelIPlNAGSCEcZ8OV3L70AdImZWTZgY4tKZU8kFA4tN2PNU9P_I9QhObD4wRSXcPzT7smcrHDvuWzQeaFPGurcmOsHJPiuqGN--tKMDzJG4FjRDMjSc6gF96QCzsa9IaO8aayCwKTZHHTGRjdCtqPVUQZvn',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF003F87)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            centers.first.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${centers.first.category} • ${centers.first.distanceLabel}',
                            style: const TextStyle(
                              color: Color(0xFF424752),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...centers.map(
          (center) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SupportCenterCard(center: center),
          ),
        ),
      ],
    );
  }
}

class _SupportCenterCard extends StatelessWidget {
  const _SupportCenterCard({required this.center});

  final SupportCenter center;

  @override
  Widget build(BuildContext context) {
    final occupancyRate = center.capacity == 0
        ? 0.0
        : center.occupancy / center.capacity;
    final statusTone = center.status == 'Lotado'
        ? const Color(0xFFBA1A1A)
        : center.status == 'Quase Cheio'
        ? const Color(0xFFA04100)
        : const Color(0xFF006722);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SupportCenterDetailScreen(center: center),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFC2C6D4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        center.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        center.distanceLabel,
                        style: const TextStyle(color: Color(0xFF424752)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusTone.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    center.status,
                    style: TextStyle(
                      color: statusTone,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MetricInfo(
                    label: 'Pessoas',
                    value: '${center.occupancy}',
                  ),
                ),
                Expanded(
                  child: _MetricInfo(
                    label: 'Capacidade',
                    value: '${center.capacity}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: occupancyRate.clamp(0, 1),
                minHeight: 8,
                backgroundColor: const Color(0xFFE5E2E1),
                valueColor: AlwaysStoppedAnimation<Color>(statusTone),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricInfo extends StatelessWidget {
  const _MetricInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF424752),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _RecentUpdatesList extends StatelessWidget {
  const _RecentUpdatesList({required this.updates});

  final List<UpdateItem> updates;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...updates.map(
          (update) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => UpdateDetailScreen(update: update),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC2C6D4)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        update.imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  update.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              _StatusChip(status: update.status),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            update.location,
                            style: const TextStyle(
                              color: Color(0xFF424752),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            update.timeAgo,
                            style: const TextStyle(
                              color: Color(0xFF424752),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            if (updates.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UpdateDetailScreen(update: updates.first),
                ),
              );
            }
          },
          child: const Text('Ver Todos os Registos'),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isFound = status == 'Encontrada';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFound ? const Color(0xFF83FC8E) : const Color(0xFFFFDAD6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isFound ? const Color(0xFF00531A) : const Color(0xFF93000A),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class UpdateDetailScreen extends StatelessWidget {
  const UpdateDetailScreen({super.key, required this.update});

  final UpdateItem update;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(update.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              update.imageUrl,
              height: 280,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatusChip(status: update.status),
              const SizedBox(width: 12),
              Text(
                update.timeAgo,
                style: const TextStyle(color: Color(0xFF424752)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            update.location,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            update.details,
            style: const TextStyle(color: Color(0xFF424752), height: 1.45),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

class _MissingRegistryScreen extends StatelessWidget {
  const _MissingRegistryScreen();

  @override
  Widget build(BuildContext context) {
    return const _RegistryScaffold(
      title: 'Registrar pessoa desaparecida',
      subtitle:
          'Formulário leve para familiares submeterem dados essenciais e acelerar o matching.',
      fields: [
        _FieldSpec('Nome completo', Icons.badge_outlined),
        _FieldSpec('Idade aproximada', Icons.cake_outlined),
        _FieldSpec('Último local conhecido', Icons.place_outlined),
        _FieldSpec('Nome do responsável', Icons.family_restroom_outlined),
        _FieldSpec('Telefone alternativo', Icons.phone_outlined),
      ],
      notesLabel: 'Descrição física, roupa e observações',
      primaryAction: 'Guardar desaparecido',
      secondaryAction: 'Anexar foto opcional',
    );
  }
}

class _FoundRegistryScreen extends StatelessWidget {
  const _FoundRegistryScreen();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFC2C6D4))),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Reencontro MZ',
                  style: TextStyle(
                    color: Color(0xFF003F87),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => Navigator.pushNamed(context, '/settings'),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1633332755192-727a05c4013d?auto=format&fit=crop&w=400&q=80',
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registrar Pessoa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Preencha os dados básicos para ajudar na identificação e localização.',
                style: TextStyle(color: Color(0xFF424752), height: 1.45),
              ),
              const SizedBox(height: 24),
              const _UploadPhotoCard(),
              const SizedBox(height: 18),
              const _LabeledField(
                label: 'Nome Completo',
                hint: 'Ex: João Manuel',
              ),
              const SizedBox(height: 16),
              const _LabeledField(
                label: 'Idade Aproximada',
                hint: 'Ex: 24',
                keyboardType: TextInputType.number,
                helper: 'Se não souber, use uma estimativa.',
              ),
              const SizedBox(height: 16),
              const _LabeledField(
                label: 'Último Local Conhecido',
                hint: 'Cidade, Bairro ou Ponto de referência',
                leadingIcon: Icons.location_on,
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE7E7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC2C6D4)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF003F87)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Suas informações serão compartilhadas com equipes de resgate e parceiros locais para facilitar a busca.',
                        style: TextStyle(
                          color: Color(0xFF424752),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE6B00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.how_to_reg),
                label: const Text(
                  'Publicar Registro',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UploadPhotoCard extends StatelessWidget {
  const _UploadPhotoCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto da Pessoa (Opcional)',
          style: TextStyle(
            color: Color(0xFF424752),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 192,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F3F2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: CustomPaint(
            painter: _DashedBorderPainter(),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, size: 48, color: Color(0xFF003F87)),
                SizedBox(height: 8),
                Text(
                  'Carregar Foto',
                  style: TextStyle(
                    color: Color(0xFF003F87),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    this.leadingIcon,
    this.helper,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final IconData? leadingIcon;
  final String? helper;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF424752),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: leadingIcon != null ? Icon(leadingIcon) : null,
            fillColor: const Color(0xFFFCF9F8),
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 6),
          Text(
            helper!,
            style: const TextStyle(
              color: Color(0xFF424752),
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}

class _MapOverviewScreen extends StatefulWidget {
  const _MapOverviewScreen();

  @override
  State<_MapOverviewScreen> createState() => _MapOverviewScreenState();
}

class _MapOverviewScreenState extends State<_MapOverviewScreen> {
  Position? _currentPosition;
  bool _loadingLocation = true;
  String _filter = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loadingLocation = false);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _loadingLocation = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _loadingLocation = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingLocation = false);
      }
    }
  }

  Stream<List<SupportCenter>> _centersStream() {
    return FirebaseFirestore.instance
        .collection('support_centers')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SupportCenter.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SupportCenter>>(
      stream: _centersStream(),
      builder: (context, snapshot) {
        final centers = snapshot.data ?? const <SupportCenter>[];
        final filteredCenters = centers.where((center) {
          if (_filter == 'Todos') return true;
          if (_filter == 'Com Vagas') return center.occupancy < center.capacity;
          return center.category == _filter;
        }).toList();

        SupportCenter? nearest;
        if (_currentPosition != null && filteredCenters.isNotEmpty) {
          nearest = filteredCenters.reduce((a, b) {
            final aDistance = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              a.latitude,
              a.longitude,
            );
            final bDistance = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              b.latitude,
              b.longitude,
            );
            return aDistance < bDistance ? a : b;
          });
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Procurar abrigo ou bairro...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['Todos', 'Com Vagas', 'Cruz Vermelha', 'Centro Gov']
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(item),
                          selected: _filter == item,
                          onSelected: (_) => setState(() => _filter = item),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: _PlatformMap(
                centers: filteredCenters,
                currentPosition: _currentPosition,
              ),
            ),
            const SizedBox(height: 14),
            if (_loadingLocation)
              const Text('A obter a sua localização...')
            else if (nearest != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC2C6D4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF003F87)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ponto de ajuda mais próximo',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            nearest.name,
                            style: const TextStyle(color: Color(0xFF424752)),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                SupportCenterDetailScreen(center: nearest!),
                          ),
                        );
                      },
                      child: const Text('Abrir'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            const Text(
              'Abrigos Próximos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...filteredCenters.map(
              (center) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SupportCenterCard(center: center),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlatformMap extends StatelessWidget {
  const _PlatformMap({required this.centers, required this.currentPosition});

  final List<SupportCenter> centers;
  final Position? currentPosition;

  @override
  Widget build(BuildContext context) {
    final centerLatitude = currentPosition?.latitude ?? -19.8335;
    final centerLongitude = currentPosition?.longitude ?? 34.8422;

    if (!kIsWeb && Platform.isIOS) {
      final annotations = <mapkit.Annotation>{
        ...centers.map(
          (center) => mapkit.Annotation(
            annotationId: mapkit.AnnotationId(center.id),
            position: mapkit.LatLng(center.latitude, center.longitude),
            infoWindow: mapkit.InfoWindow(
              title: center.name,
              snippet: center.status,
            ),
          ),
        ),
      };

      if (currentPosition != null) {
        annotations.add(
          mapkit.Annotation(
            annotationId: mapkit.AnnotationId('me'),
            position: mapkit.LatLng(
              currentPosition!.latitude,
              currentPosition!.longitude,
            ),
            infoWindow: const mapkit.InfoWindow(title: 'Minha localização'),
          ),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: mapkit.AppleMap(
          myLocationEnabled: true,
          initialCameraPosition: mapkit.CameraPosition(
            target: mapkit.LatLng(centerLatitude, centerLongitude),
            zoom: 10,
          ),
          annotations: annotations,
        ),
      );
    }

    final markers = <Marker>[
      ...centers.map(
        (center) => Marker(
          point: osm.LatLng(center.latitude, center.longitude),
          width: 44,
          height: 44,
          child: const Icon(
            Icons.location_on,
            color: Color(0xFF003F87),
            size: 34,
          ),
        ),
      ),
      if (currentPosition != null)
        Marker(
          point: osm.LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          ),
          width: 44,
          height: 44,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF003F87), width: 2),
            ),
            child: const Icon(
              Icons.my_location,
              color: Color(0xFF003F87),
              size: 22,
            ),
          ),
        ),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: osm.LatLng(centerLatitude, centerLongitude),
          initialZoom: 9.5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.reencontro',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}

class SupportCenterDetailScreen extends StatelessWidget {
  const SupportCenterDetailScreen({super.key, required this.center});

  final SupportCenter center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(center.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFC2C6D4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  center.category,
                  style: const TextStyle(
                    color: Color(0xFF003F87),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  center.address,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  center.description,
                  style: const TextStyle(
                    color: Color(0xFF424752),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _MetricInfo(
                        label: 'Pessoas',
                        value: '${center.occupancy}',
                      ),
                    ),
                    Expanded(
                      child: _MetricInfo(
                        label: 'Capacidade',
                        value: '${center.capacity}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ver direções'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CriticalAlertCard extends StatelessWidget {
  const _CriticalAlertCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFBA1A1A).withValues(alpha: 0.2),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFF93000A)),
              SizedBox(width: 8),
              Text(
                'Estado de Alerta',
                style: TextStyle(
                  color: Color(0xFF93000A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Ciclone IDAI: Inundações activas em Beira e Sofala.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF93000A),
              height: 1.2,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Actualizado há 5 min.',
            style: TextStyle(color: Color(0xFF93000A), height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ActionSectionHeader extends StatelessWidget {
  const _ActionSectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF424752),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RegistryScaffold extends StatelessWidget {
  const _RegistryScaffold({
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.notesLabel,
    required this.primaryAction,
    required this.secondaryAction,
  });

  final String title;
  final String subtitle;
  final List<_FieldSpec> fields;
  final String notesLabel;
  final String primaryAction;
  final String secondaryAction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF424752), height: 1.45),
        ),
        const SizedBox(height: 18),
        _SurfaceCard(
          child: Column(
            children: [
              for (final field in fields) ...[
                TextField(
                  decoration: InputDecoration(
                    labelText: field.label,
                    prefixIcon: Icon(field.icon),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: notesLabel,
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 64),
                    child: Icon(Icons.notes_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_a_photo_outlined),
                label: Text(secondaryAction),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () {}, child: Text(primaryAction)),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onChanged});

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      (icon: Icons.home, label: 'Início'),
      (icon: Icons.person_search, label: 'Procurar'),
      (icon: Icons.how_to_reg, label: 'Encontrei'),
      (icon: Icons.map, label: 'Mapa'),
    ];

    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Color(0xFFFCF9F8),
        border: Border(top: BorderSide(color: Color(0xFFC2C6D4))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = index == currentIndex;

            return Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF003F87)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        size: 22,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF424752),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? const Color(0xFF003F87)
                            : const Color(0xFF424752),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2C6D4)),
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final paint = Paint()
      ..color = const Color(0xFFC2C6D4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(16),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FieldSpec {
  const _FieldSpec(this.label, this.icon);

  final String label;
  final IconData icon;
}
