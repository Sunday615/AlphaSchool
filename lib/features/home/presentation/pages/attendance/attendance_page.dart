import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // ✅ Students (Name + ID)
  final List<_StudentInfo> _students = const [
    _StudentInfo(id: "S001", name: "Khampheng S."),
    _StudentInfo(id: "S002", name: "Noy P."),
  ];

  // ✅ Selected student by ID (no dropdown now -> default first)
  late final String _selectedStudentId = _students.first.id;

  late final Map<String, List<_AttendanceRow>> _data = {
    "S001": _demoRowsA(),
    "S002": _demoRowsB(),
  };

  // ✅ NEW: filter when tap stat cards
  _AttendStatus? _filter; // null = all

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, mode, _) {
        final locale = Localizations.localeOf(context);
        final base = (mode == ThemeMode.dark)
            ? AppTheme.darkTheme(locale)
            : AppTheme.lightTheme(locale);

        return AnimatedTheme(
          data: base,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Builder(
            builder: (context) {
              final t = Theme.of(context);
              final isDark = t.brightness == Brightness.dark;
              final cs = t.colorScheme;

              final student = _students.firstWhere(
                (s) => s.id == _selectedStudentId,
                orElse: () => _students.first,
              );

              final allRows =
                  _data[_selectedStudentId] ?? const <_AttendanceRow>[];

              // ✅ apply filter
              final rows = _filter == null
                  ? allRows
                  : allRows.where((e) => e.status == _filter).toList();

              final textPrimary = isDark ? Colors.white : AppColors.blue500;
              final textMuted = isDark
                  ? Colors.white.withOpacity(.72)
                  : AppColors.blue500.withOpacity(.62);

              final cardBg = isDark ? AppTheme.darkBluePremium : cs.surface;
              final border = isDark
                  ? Colors.white.withOpacity(.10)
                  : AppColors.slate.withOpacity(.12);

              final shadow = Colors.black.withOpacity(isDark ? .25 : .08);

              final gradient = isDark
                  ? AppTheme.premiumDarkGradient
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.blue500.withOpacity(.12),
                        Colors.white,
                        AppColors.blue400.withOpacity(.06),
                      ],
                    );
              // counts always from ALL rows (not filtered)
              final comeCount = allRows
                  .where((e) => e.status == _AttendStatus.comeIn)
                  .length;
              final absentCount = allRows
                  .where((e) => e.status == _AttendStatus.notCome)
                  .length;

              return Scaffold(
                backgroundColor: t.scaffoldBackgroundColor,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: isDark ? Colors.white : AppColors.blue500,
                  title: const Text("Attendance"),
                  centerTitle: true,
                ),
                body: Container(
                  decoration: BoxDecoration(gradient: gradient),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      child: Column(
                        children: [
                          // ===== Header / Summary =====
                          Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: cardBg.withOpacity(isDark ? .88 : 1),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(color: border),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 18,
                                      offset: const Offset(0, 10),
                                      color: shadow,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Track student attendance",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Student: ${student.name}  •  ID: ${student.id}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12.5,
                                        color: textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // ✅ Two full-width cards (tap to filter)
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              _StatCard(
                                                    isDark: isDark,
                                                    title: "Come in",
                                                    value: comeCount,
                                                    icon: Icons
                                                        .check_circle_rounded,
                                                    color: const Color(
                                                      0xFF22C55E,
                                                    ),
                                                    selected:
                                                        _filter ==
                                                        _AttendStatus.comeIn,
                                                    onTap: () => _toggleFilter(
                                                      _AttendStatus.comeIn,
                                                    ),
                                                  )
                                                  .animate()
                                                  .fadeIn(duration: 220.ms)
                                                  .slideY(
                                                    begin: .06,
                                                    end: 0,
                                                    duration: 220.ms,
                                                    curve: Curves.easeOut,
                                                  ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child:
                                              _StatCard(
                                                    isDark: isDark,
                                                    title: "Not come",
                                                    value: absentCount,
                                                    icon: Icons.cancel_rounded,
                                                    color: const Color(
                                                      0xFFEF4444,
                                                    ),
                                                    selected:
                                                        _filter ==
                                                        _AttendStatus.notCome,
                                                    onTap: () => _toggleFilter(
                                                      _AttendStatus.notCome,
                                                    ),
                                                  )
                                                  .animate()
                                                  .fadeIn(duration: 220.ms)
                                                  .slideY(
                                                    begin: .06,
                                                    end: 0,
                                                    duration: 220.ms,
                                                    curve: Curves.easeOut,
                                                  ),
                                        ),
                                      ],
                                    ),

                                    // ✅ show filter hint + clear
                                    if (_filter != null) ...[
                                      const SizedBox(height: 10),
                                      Row(
                                            children: [
                                              Icon(
                                                Icons.filter_alt_rounded,
                                                size: 16,
                                                color: textMuted,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  "Filter: ${_filter == _AttendStatus.comeIn ? "Come in" : "Not come"}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12,
                                                    color: textMuted,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () => setState(
                                                  () => _filter = null,
                                                ),
                                                style: TextButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6,
                                                      ),
                                                  minimumSize: Size.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: Text(
                                                  "Clear",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: textPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                          .animate()
                                          .fadeIn(duration: 160.ms)
                                          .slideY(
                                            begin: .06,
                                            end: 0,
                                            duration: 160.ms,
                                          ),
                                    ],
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 220.ms)
                              .slideY(begin: .08, end: 0, duration: 220.ms),

                          const SizedBox(height: 12),

                          // ===== Table Card =====
                          Expanded(
                            child:
                                Container(
                                      decoration: BoxDecoration(
                                        color: cardBg.withOpacity(
                                          isDark ? .86 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(color: border),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 18,
                                            offset: const Offset(0, 10),
                                            color: shadow,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(22),
                                        child: Column(
                                          children: [
                                            _TableHeader(
                                              isDark: isDark,
                                              border: border,
                                              textMuted: isDark
                                                  ? Colors.white.withOpacity(
                                                      .70,
                                                    )
                                                  : AppColors.slate.withOpacity(
                                                      .85,
                                                    ),
                                            ),
                                            Expanded(
                                              child: AnimatedSwitcher(
                                                duration: 220.ms,
                                                switchInCurve: Curves.easeOut,
                                                switchOutCurve: Curves.easeOut,
                                                transitionBuilder:
                                                    (child, anim) {
                                                      final fade =
                                                          CurvedAnimation(
                                                            parent: anim,
                                                            curve:
                                                                Curves.easeOut,
                                                          );
                                                      final slide =
                                                          Tween<Offset>(
                                                            begin: const Offset(
                                                              0,
                                                              .02,
                                                            ),
                                                            end: Offset.zero,
                                                          ).animate(fade);
                                                      return FadeTransition(
                                                        opacity: fade,
                                                        child: SlideTransition(
                                                          position: slide,
                                                          child: child,
                                                        ),
                                                      );
                                                    },
                                                child: rows.isEmpty
                                                    ? _EmptyState(
                                                        key: ValueKey(
                                                          "empty_${_filter}",
                                                        ),
                                                        isDark: isDark,
                                                      )
                                                    : ListView.separated(
                                                        key: ValueKey(
                                                          "list_${_filter}_${rows.length}",
                                                        ),
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                              10,
                                                              10,
                                                              10,
                                                              12,
                                                            ),
                                                        itemCount: rows.length,
                                                        separatorBuilder:
                                                            (_, __) =>
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                        itemBuilder: (context, i) {
                                                          return _AttendanceRowTile(
                                                                isDark: isDark,
                                                                border: border,
                                                                row: rows[i],
                                                              )
                                                              .animate()
                                                              .fadeIn(
                                                                duration:
                                                                    180.ms,
                                                                delay:
                                                                    (35 * i).ms,
                                                              )
                                                              .slideY(
                                                                begin: .06,
                                                                end: 0,
                                                                duration:
                                                                    180.ms,
                                                                curve: Curves
                                                                    .easeOut,
                                                              );
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 220.ms, delay: 80.ms)
                                    .slideY(
                                      begin: .08,
                                      end: 0,
                                      duration: 220.ms,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _toggleFilter(_AttendStatus s) {
    setState(() {
      _filter = (_filter == s) ? null : s;
    });
  }

  // ===== Demo data =====
  List<_AttendanceRow> _demoRowsA() {
    final base = DateTime.now();
    return [
      _AttendanceRow(
        date: base,
        status: _AttendStatus.comeIn,
        reason: "Normal",
        note: null,
        checkIn: const TimeOfDay(hour: 7, minute: 55),
      ),
      _AttendanceRow(
        date: base.subtract(const Duration(days: 1)),
        status: _AttendStatus.notCome,
        reason: "Sick",
        note: "Parent called",
        checkIn: null,
      ),
      _AttendanceRow(
        date: base.subtract(const Duration(days: 2)),
        status: _AttendStatus.comeIn,
        reason: "Late",
        note: null,
        checkIn: const TimeOfDay(hour: 8, minute: 20),
      ),
      _AttendanceRow(
        date: base.subtract(const Duration(days: 3)),
        status: _AttendStatus.comeIn,
        reason: "Normal",
        note: null,
        checkIn: const TimeOfDay(hour: 7, minute: 58),
      ),
      _AttendanceRow(
        date: base.subtract(const Duration(days: 4)),
        status: _AttendStatus.notCome,
        reason: "Personal",
        note: "Travel",
        checkIn: null,
      ),
    ];
  }

  List<_AttendanceRow> _demoRowsB() {
    final base = DateTime.now();
    return [
      _AttendanceRow(
        date: base,
        status: _AttendStatus.comeIn,
        reason: "Normal",
        note: null,
        checkIn: const TimeOfDay(hour: 7, minute: 50),
      ),
      _AttendanceRow(
        date: base.subtract(const Duration(days: 1)),
        status: _AttendStatus.comeIn,
        reason: "Normal",
        note: null,
        checkIn: const TimeOfDay(hour: 7, minute: 53),
      ),
      _AttendanceRow(
        date: base.subtract(const Duration(days: 2)),
        status: _AttendStatus.notCome,
        reason: "Sick",
        note: "Fever",
        checkIn: null,
      ),
    ];
  }
}

// =====================
// Students model
// =====================
class _StudentInfo {
  final String id;
  final String name;

  const _StudentInfo({required this.id, required this.name});
}

// =====================
// Attendance Models
// =====================
enum _AttendStatus { comeIn, notCome }

class _AttendanceRow {
  final DateTime date;
  final _AttendStatus status;
  final String reason;
  final String? note;
  final TimeOfDay? checkIn;

  const _AttendanceRow({
    required this.date,
    required this.status,
    required this.reason,
    required this.note,
    required this.checkIn,
  });

  String get dateText => DateFormat("yyyy/MM/dd").format(date);

  String get checkInText {
    final t = checkIn;
    if (t == null) return "";
    final hh = t.hour.toString().padLeft(2, "0");
    final mm = t.minute.toString().padLeft(2, "0");
    return "$hh:$mm";
  }
}

// =====================
// UI pieces
// =====================
class _StatCard extends StatefulWidget {
  final bool isDark;
  final String title;
  final int value;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _StatCard({
    required this.isDark,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final titleColor = widget.isDark
        ? Colors.white.withOpacity(.86)
        : AppColors.blue500;
    final valueColor = widget.isDark ? Colors.white : AppColors.blue500;

    final baseBg = widget.color.withOpacity(widget.isDark ? .14 : .10);
    final selectedBg = widget.color.withOpacity(widget.isDark ? .24 : .18);

    final baseBorder = widget.color.withOpacity(.45);
    final selectedBorder = widget.color.withOpacity(.85);

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: 120.ms,
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: 200.ms,
            curve: Curves.easeOut,
            height: 66,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: widget.selected ? selectedBg : baseBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: widget.selected ? selectedBorder : baseBorder,
                width: widget.selected ? 1.4 : 1.0,
              ),
              boxShadow: widget.selected
                  ? [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                        color: widget.color.withOpacity(
                          widget.isDark ? .18 : .14,
                        ),
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(widget.isDark ? .22 : .14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, size: 20, color: widget.color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: titleColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${widget.value}",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;

  const _EmptyState({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(.06) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(.10)
                : AppColors.slate.withOpacity(.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: isDark
                  ? Colors.white.withOpacity(.70)
                  : AppColors.blue500.withOpacity(.70),
            ),
            const SizedBox(width: 10),
            Text(
              "No records found",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: isDark
                    ? Colors.white.withOpacity(.82)
                    : AppColors.blue500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final bool isDark;
  final Color border;
  final Color textMuted;

  const _TableHeader({
    required this.isDark,
    required this.border,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.06)
            : AppColors.slate.withOpacity(.05),
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          _HeadCell("Date", flex: 12, color: textMuted),
          _HeadCell("Reason", flex: 14, color: textMuted),
          _HeadCell("Note", flex: 16, color: textMuted),
          _HeadCell("Status", flex: 12, color: textMuted, alignRight: true),
        ],
      ),
    );
  }
}

class _HeadCell extends StatelessWidget {
  final String text;
  final int flex;
  final Color color;
  final bool alignRight;

  const _HeadCell(
    this.text, {
    required this.flex,
    required this.color,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: .2,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _AttendanceRowTile extends StatelessWidget {
  final bool isDark;
  final Color border;
  final _AttendanceRow row;

  const _AttendanceRowTile({
    required this.isDark,
    required this.border,
    required this.row,
  });

  @override
  Widget build(BuildContext context) {
    final isCome = row.status == _AttendStatus.comeIn;

    const green = Color(0xFF22C55E);
    const red = Color(0xFFEF4444);

    final chipColor = isCome ? green : red;
    final chipBg = chipColor.withOpacity(isDark ? .18 : .12);

    final noteText = isCome ? "" : (row.note ?? "");

    final isLate = row.reason.trim().toLowerCase() == "late";
    final reasonColorOverride = isLate ? red : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _BodyCell(row.dateText, flex: 12, isDark: isDark),
          _BodyCell(
            row.reason,
            flex: 14,
            isDark: isDark,
            colorOverride: reasonColorOverride,
          ),
          _BodyCell(noteText, flex: 16, isDark: isDark, mutedIfEmpty: true),
          Expanded(
            flex: 12,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: chipColor.withOpacity(.55)),
                    ),
                    child: Text(
                      isCome ? "Come in" : "Not come",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12.3,
                        color: chipColor,
                      ),
                    ),
                  ),
                  if (isCome && row.checkIn != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      "Check-in ${row.checkInText}",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5,
                        color: isDark
                            ? Colors.white.withOpacity(.78)
                            : AppColors.slate.withOpacity(.80),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool isDark;
  final bool mutedIfEmpty;
  final Color? colorOverride;

  const _BodyCell(
    this.text, {
    required this.flex,
    required this.isDark,
    this.mutedIfEmpty = false,
    this.colorOverride,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = text.trim().isEmpty;

    Color baseColor;
    if (colorOverride != null) {
      baseColor = colorOverride!;
    } else if (isEmpty && mutedIfEmpty) {
      baseColor = isDark
          ? Colors.white.withOpacity(.25)
          : AppColors.slate.withOpacity(.28);
    } else {
      baseColor = isDark ? Colors.white : AppColors.blue500;
    }

    return Expanded(
      flex: flex,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 12.5,
          height: 1.15,
          color: baseColor,
        ),
      ),
    );
  }
}
