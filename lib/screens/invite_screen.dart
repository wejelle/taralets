import 'dart:ui'; // 1. Import para sa ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../widgets/search_bar_widget.dart';
import '../models/group_member.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  static const String _roomCode = 'TR8X4Z';
  bool _copied = false;
  String _query = '';
  bool _sent = false;

  final List<Map<String, dynamic>> _suggestedUsers = [
    {
      'name': 'pau.reyes',
      'initials': 'PR',
      'color': const Color(0xFF8B5CF6),
      'mutual': 3
    },
    {
      'name': 'ynez_mnl',
      'initials': 'YM',
      'color': const Color(0xFFEC4899),
      'mutual': 7
    },
    {
      'name': 'juancodm',
      'initials': 'JC',
      'color': const Color(0xFF0D9488),
      'mutual': 2
    },
    {
      'name': 'bry.dev',
      'initials': 'BD',
      'color': const Color(0xFFF59E0B),
      'mutual': 5
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return _suggestedUsers;
    return _suggestedUsers
        .where((u) => (u['name'] as String).contains(_query.toLowerCase()))
        .toList();
  }

  void _copyCode() async {
    await Clipboard.setData(const ClipboardData(text: _roomCode));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Ginamitan ulit natin ng Stack at Gradient Background
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0C3FC),
                  Color(0xFF8EC5FC),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text('Invite Friends',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  const Text('Search by username or share your room code.',
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 22),

                  // Search bar (Kung hindi transparent 'to, baka gusto mo rin i-update ang SearchBarWidget mo eventually)
                  SearchBarWidget(
                    hintText: 'Search username…',
                    onChanged: (v) => setState(() {
                      _query = v;
                      _sent = false;
                    }),
                    onClear: () => setState(() {
                      _query = '';
                      _sent = false;
                    }),
                  ),

                  // Search result / send button
                  if (_query.isNotEmpty && _filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: _EmptySearchState(query: _query),
                    ),

                  if (_query.isNotEmpty && _filtered.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: _filtered
                            .map((u) => _UserResultTile(
                                  user: u,
                                  sent: _sent,
                                  onSend: () => setState(() => _sent = true),
                                ))
                            .toList(),
                      ),
                    ),

                  const SizedBox(height: 28),

                  // Room code card
                  _RoomCodeCard(
                      code: _roomCode, copied: _copied, onCopy: _copyCode),

                  const SizedBox(height: 28),

                  // Suggested section
                  const Text('People You May Know',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ..._suggestedUsers.map((u) => _SuggestedTile(user: u)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable Hoverable Glass Card ─────────────────────────────────────────────
// Ginawa ko itong hiwalay na widget para madaling i-wrap kahit sa anong tile!
class HoverGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;

  const HoverGlassCard({
    super.key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(12),
    this.color,
    this.borderColor,
  });

  @override
  State<HoverGlassCard> createState() => _HoverGlassCardState();
}

class _HoverGlassCardState extends State<HoverGlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered
            ? 1.02
            : 1.0, // Dito nangyayari ang slight pop/hover effect
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: widget.margin,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.color ??
                      Colors.white.withOpacity(_isHovered
                          ? 0.45
                          : 0.3), // Lilitaw nang kaunti kapag hovered
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: widget.borderColor ??
                        Colors.white.withOpacity(_isHovered ? 0.6 : 0.4),
                    width: 1.5,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _RoomCodeCard extends StatelessWidget {
  final String code;
  final bool copied;
  final VoidCallback onCopy;

  const _RoomCodeCard(
      {required this.code, required this.copied, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    // Ginamitan natin ng HoverGlassCard pero may "Dark Glass" config
    return HoverGlassCard(
      padding: const EdgeInsets.all(22),
      color: Colors.black.withOpacity(0.4), // Dark tinted glass
      borderColor: Colors.white.withOpacity(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.meeting_room_outlined,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Your Room Code',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 10,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              GestureDetector(
                onTap: onCopy,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: copied
                        ? AppColors.teal.withOpacity(0.8)
                        : Colors.white.withOpacity(0.2), // Glass button
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(copied ? Icons.check_rounded : Icons.copy_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(copied ? 'Copied!' : 'Copy',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.12),
          ),
          const SizedBox(height: 14),
          Text(
            'Share this code with friends so they can join your Taralets group.',
            style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _UserResultTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool sent;
  final VoidCallback onSend;

  const _UserResultTile(
      {required this.user, required this.sent, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return HoverGlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: user['color'] as Color,
              radius: 20,
              child: Text(user['initials'] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${user['name']}',
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                Text('${user['mutual']} mutual friends',
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: sent ? null : onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: sent
                    ? AppColors.teal.withOpacity(0.8)
                    : AppColors.primary.withOpacity(0.8), // Glassy button
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                sent ? 'Invited!' : 'Invite',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestedTile extends StatefulWidget {
  final Map<String, dynamic> user;
  const _SuggestedTile({required this.user});
  @override
  State<_SuggestedTile> createState() => _SuggestedTileState();
}

class _SuggestedTileState extends State<_SuggestedTile> {
  bool _invited = false;

  @override
  Widget build(BuildContext context) {
    return HoverGlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: widget.user['color'] as Color,
            radius: 20,
            child: Text(widget.user['initials'] as String,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${widget.user['name']}',
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text('${widget.user['mutual']} mutual friends',
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _invited = !_invited),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                // Inadjust natin to handle glass effect
                color: _invited
                    ? AppColors.teal.withOpacity(0.15)
                    : AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _invited ? 'Invited ✓' : '+ Invite',
                style: TextStyle(
                  color: _invited ? AppColors.teal : AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final String query;
  const _EmptySearchState({required this.query});

  @override
  Widget build(BuildContext context) {
    // Pinalitan din ng HoverGlassCard kahit empty state
    return HoverGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.person_search_outlined,
              color: Colors.black54, size: 36),
          const SizedBox(height: 10),
          Text('No results for "$query"',
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text('Try a different username.',
              style: TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }
}
