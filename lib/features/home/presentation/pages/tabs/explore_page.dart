import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';

import '../calendar/calendar_page.dart';
import '../saving/saving_page.dart';
import '../contact/contact_page.dart';
import '../attendance/attendance_page.dart';
import '../news/news_page.dart';
import '../participant/participant_page.dart';
import '../gallery/gallery_page.dart';
import '../appointment/appointment_page.dart';
import '../homework/homework_page.dart';
import '../task/task_page.dart';
import '../report/report_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;
    final cs = t.colorScheme;
    final text = t.textTheme;

    final titleColor = isDark ? Colors.white : AppColors.blue500;
    final muted = isDark
        ? AppColors.grayUltraLight.withOpacity(.78)
        : AppColors.blue500.withOpacity(.62);

    final border = isDark
        ? Colors.white.withOpacity(.10)
        : AppColors.slate.withOpacity(.12);

    final cardBg = isDark ? AppColors.blue500.withOpacity(.10) : cs.surface;
    final shadow = Colors.black.withOpacity(isDark ? .20 : .06);

    // ========= Saving demo data (5 rows) =========
    final savingRows = _SavingDemo.build();

    // ========= Attendance preview (latest check-in) =========
    final attendancePreview = _AttendancePreview.fromRows(
      _AttendanceDemo.build(),
    );

    // ========= Contact quick preview (Phone / WhatsApp) =========
    final qc = _QuickContactPreview(
      phone: SchoolContactInfo.demo.phone,
      whatsapp: SchoolContactInfo.demo.whatsapp,
    );

    // 4 cards (order MUST match UI)
    final projects = <_ProjectCard>[
      _ProjectCard(
        id: 'calendar',
        title: 'Calendar',
        icon: Icons.calendar_month_rounded,
        progress: 0.56,
        primary: true,
      ),
      _ProjectCard(
        id: 'saving',
        title: 'Saving',
        icon: Icons.savings_rounded,
        progress: 0.87,
        savingRows: savingRows,
      ),
      _ProjectCard(
        id: 'attendance',
        title: 'Attendance',
        icon: Icons.fact_check_rounded,
        progress: 0.24,
        attendancePreview: attendancePreview,
      ),
      _ProjectCard(
        id: 'contact',
        title: 'Contact',
        icon: FontAwesomeIcons.addressBook,
        progress: 0.46,
        quickContact: qc, // ✅ show quick contact (2 fields)
      ),
    ];

    // mini menus
    final mini = <_MiniItem>[
      _MiniItem(id: 'news', title: 'News', icon: Icons.campaign_rounded),
      _MiniItem(
        id: 'participant',
        title: 'Participant',
        icon: Icons.groups_rounded,
      ),
      _MiniItem(
        id: 'gallery',
        title: 'Gallery',
        icon: Icons.photo_library_rounded,
      ),
      _MiniItem(
        id: 'appointment',
        title: 'Appointment',
        icon: Icons.event_available_rounded,
      ),
      _MiniItem(
        id: 'homework',
        title: 'Homework',
        icon: Icons.menu_book_rounded,
      ),
      _MiniItem(id: 'task', title: 'Task', icon: Icons.task_alt_rounded),
      _MiniItem(
        id: 'report',
        title: 'Report',
        icon: Icons.insert_chart_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final h = c.maxHeight;
        final tiny = h < 620;
        final compact = h < 720;

        final topPad = tiny ? 6.0 : 10.0;
        final gapA = tiny ? 8.0 : 12.0;
        final gapB = tiny ? 6.0 : 10.0;

        final miniH = tiny ? 76.0 : (compact ? 90.0 : 104.0);
        final miniFont = tiny ? 9.0 : (compact ? 10.0 : 11.0);

        return Padding(
          key: const ValueKey("ExplorePage"),
          padding: EdgeInsets.fromLTRB(16, topPad, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ongoing Projects",
                        style: (compact ? text.titleMedium : text.titleLarge)
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: titleColor,
                            ),
                      ),
                      Text(
                        "View all",
                        style: text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: muted,
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(duration: 220.ms)
                  .slideY(
                    begin: .10,
                    end: 0,
                    duration: 220.ms,
                    curve: Curves.easeOut,
                  ),

              SizedBox(height: gapA),

              // =====================
              // Cards area
              // =====================
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 11,
                      child: Row(
                        children: [
                          Expanded(
                            child:
                                _ProjectTile(
                                      compact: compact,
                                      smallRow: false,
                                      isDark: isDark,
                                      baseBg: cardBg,
                                      border: border,
                                      shadow: shadow,
                                      item: projects[0],
                                      onTap: () => Navigator.of(context).push(
                                        _smoothRoute(const CalendarPage()),
                                      ),
                                    )
                                    .animate(delay: 80.ms)
                                    .fadeIn(duration: 240.ms)
                                    .slideY(
                                      begin: .08,
                                      end: 0,
                                      duration: 240.ms,
                                    ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child:
                                _ProjectTile(
                                      compact: compact,
                                      smallRow: false,
                                      isDark: isDark,
                                      baseBg: cardBg,
                                      border: border,
                                      shadow: shadow,
                                      item: projects[1],
                                      onTap: () => Navigator.of(
                                        context,
                                      ).push(_smoothRoute(const SavingPage())),
                                    )
                                    .animate(delay: 140.ms)
                                    .fadeIn(duration: 240.ms)
                                    .slideY(
                                      begin: .08,
                                      end: 0,
                                      duration: 240.ms,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: tiny ? 8 : 12),
                    Expanded(
                      flex: 9,
                      child: Row(
                        children: [
                          Expanded(
                            child:
                                _ProjectTile(
                                      compact: compact,
                                      smallRow: true,
                                      isDark: isDark,
                                      baseBg: cardBg,
                                      border: border,
                                      shadow: shadow,
                                      item: projects[2], // Attendance
                                      onTap: () => Navigator.of(context).push(
                                        _smoothRoute(const AttendancePage()),
                                      ),
                                    )
                                    .animate(delay: 200.ms)
                                    .fadeIn(duration: 240.ms)
                                    .slideY(
                                      begin: .08,
                                      end: 0,
                                      duration: 240.ms,
                                    ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child:
                                _ProjectTile(
                                      compact: compact,
                                      smallRow: true,
                                      isDark: isDark,
                                      baseBg: cardBg,
                                      border: border,
                                      shadow: shadow,
                                      item: projects[3], // Contact
                                      onTap: () => Navigator.of(
                                        context,
                                      ).push(_smoothRoute(const ContactPage())),
                                    )
                                    .animate(delay: 260.ms)
                                    .fadeIn(duration: 240.ms)
                                    .slideY(
                                      begin: .08,
                                      end: 0,
                                      duration: 240.ms,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: gapB),

              // =====================
              // Mini icons
              // =====================
              SizedBox(
                height: miniH,
                child:
                    _MiniRows(
                          compact: compact,
                          tiny: tiny,
                          fontSize: miniFont,
                          isDark: isDark,
                          border: border,
                          bg: cardBg,
                          shadow: shadow,
                          items: mini,
                          onTap: (m) {
                            switch (m.id) {
                              case 'news':
                                Navigator.of(
                                  context,
                                ).push(_smoothRoute(const NewsPage()));
                                break;
                              case 'participant':
                                Navigator.of(
                                  context,
                                ).push(_smoothRoute(const ParticipantPage()));
                                break;
                              case 'gallery':
                                Navigator.of(
                                  context,
                                ).push(_smoothRoute(const GalleryPage()));
                                break;
                              case 'appointment':
                                Navigator.of(
                                  context,
                                ).push(_smoothRoute(const AppointmentPage()));
                                break;
                              case 'homework':
                                Navigator.of(
                                  context,
                                ).push(_smoothRoute(const HomeworkPage()));
                                break;
                              case 'task':
                                Navigator.of(
                                  context,
                                ).push(_smoothRoute(const TaskPage()));
                                break;
                              case 'report':
                                Navigator.of(
                                  context,
                                ).push(_smoothRoute(const ReportPage()));
                                break;
                              default:
                                break;
                            }
                          },
                        )
                        .animate()
                        .fadeIn(duration: 220.ms, delay: 120.ms)
                        .slideY(begin: .08, end: 0, duration: 220.ms),
              ),
            ],
          ),
        );
      },
    );
  }

  static Route _smoothRoute(Widget page) {
    return PageRouteBuilder(
      opaque: true,
      transitionDuration: 260.ms,
      reverseTransitionDuration: 220.ms,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final fade = CurvedAnimation(parent: anim, curve: Curves.easeOut);
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(fade);
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}

// =====================
// Project cards
// =====================
class _ProjectCard {
  final String id;
  final String title;
  final IconData icon;
  final double progress;
  final bool primary;

  final List<_SavingRow>? savingRows;
  final _AttendancePreview? attendancePreview;
  final _QuickContactPreview? quickContact;

  const _ProjectCard({
    required this.id,
    required this.title,
    required this.icon,
    required this.progress,
    this.primary = false,
    this.savingRows,
    this.attendancePreview,
    this.quickContact,
  });
}

class _ProjectTile extends StatefulWidget {
  final bool compact;
  final bool smallRow;
  final bool isDark;
  final Color baseBg;
  final Color border;
  final Color shadow;
  final _ProjectCard item;
  final VoidCallback onTap;

  const _ProjectTile({
    required this.compact,
    required this.smallRow,
    required this.isDark,
    required this.baseBg,
    required this.border,
    required this.shadow,
    required this.item,
    required this.onTap,
  });

  @override
  State<_ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<_ProjectTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final primary = widget.item.primary;

    final isCalendar = widget.item.id == "calendar";
    final isSaving =
        widget.item.id == "saving" &&
        (widget.item.savingRows?.isNotEmpty ?? false);
    final isAttendance =
        widget.item.id == "attendance" && widget.item.attendancePreview != null;
    final isContact =
        widget.item.id == "contact" && widget.item.quickContact != null;

    final pad = widget.compact
        ? (widget.smallRow ? 10.0 : 12.0)
        : (widget.smallRow ? 12.0 : 14.0);

    final titleSize = widget.compact
        ? (widget.smallRow ? 14.0 : 14.8)
        : (widget.smallRow ? 14.8 : 15.5);

    final iconSize = widget.compact
        ? (widget.smallRow ? 20.0 : 22.0)
        : (widget.smallRow ? 22.0 : 24.0);

    final premiumGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF071A3A), Color(0xFF0B2A6F), Color(0xFF1246A8)],
    );

    final defaultGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.blue500, AppColors.blue400, AppColors.blue300],
    );

    final bg = primary ? null : widget.baseBg;

    final titleColor = primary
        ? Colors.white
        : (widget.isDark ? Colors.white : AppColors.blue500);
    final iconColor = primary
        ? Colors.white
        : (widget.isDark ? Colors.white : AppColors.blue500);

    final smallColor = primary
        ? Colors.white.withOpacity(.78)
        : (widget.isDark
              ? AppColors.grayUltraLight.withOpacity(.65)
              : AppColors.slate.withOpacity(.60));

    // Calendar surface
    final calSurface = primary
        ? Colors.white.withOpacity(.10)
        : (widget.isDark
              ? Colors.white.withOpacity(.06)
              : AppColors.slate.withOpacity(.06));

    final calBorder = primary
        ? Colors.white.withOpacity(.16)
        : (widget.isDark
              ? Colors.white.withOpacity(.10)
              : AppColors.slate.withOpacity(.14));

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: 120.ms,
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          child: Container(
            padding: EdgeInsets.all(pad),
            decoration: BoxDecoration(
              color: bg,
              gradient: primary
                  ? (isCalendar ? premiumGradient : defaultGradient)
                  : null,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: primary ? Colors.white.withOpacity(.10) : widget.border,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: widget.shadow,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top row
                Row(
                  children: [
                    const Spacer(),
                    Icon(Icons.more_vert_rounded, size: 18, color: smallColor),
                  ],
                ),

                SizedBox(height: widget.compact ? 6 : 8),

                // title row
                Row(
                  children: [
                    Icon(widget.item.icon, color: iconColor, size: iconSize),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: titleSize,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ],
                ),

                // BODY
                if (isCalendar) ...[
                  SizedBox(height: widget.compact ? 8 : 10),
                  Expanded(
                    child: _PremiumMonthCalendar(
                      compact: widget.compact,
                      surface: calSurface,
                      border: calBorder,
                      titleColor: titleColor,
                      subColor: smallColor,
                      primary: primary,
                    ),
                  ),
                ] else if (isSaving) ...[
                  const SizedBox(height: 10),
                  Expanded(
                    child: _SavingMiniTable(
                      compact: widget.compact,
                      isDark: widget.isDark,
                      rows: widget.item.savingRows!,
                    ),
                  ),
                ] else if (isAttendance) ...[
                  const SizedBox(height: 10),
                  Expanded(
                    child:
                        _AttendancePreviewCard(
                              compact: widget.compact,
                              isDark: widget.isDark,
                              primary: primary,
                              preview: widget.item.attendancePreview!,
                            )
                            .animate()
                            .fadeIn(duration: 180.ms)
                            .slideY(begin: .06, end: 0, duration: 180.ms),
                  ),
                ] else if (isContact) ...[
                  const SizedBox(height: 10),
                  Expanded(
                    child:
                        _QuickContactCard(
                              compact: widget.compact,
                              isDark: widget.isDark,
                              primary: primary,
                              data: widget.item.quickContact!,
                            )
                            .animate()
                            .fadeIn(duration: 180.ms)
                            .slideY(begin: .06, end: 0, duration: 180.ms),
                  ),
                ] else ...[
                  const Spacer(),
                  Text(
                    "Progress",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: widget.compact ? 11.0 : 12,
                      color: smallColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _ProgressBar(
                          bg: primary
                              ? Colors.white.withOpacity(.18)
                              : AppColors.slate.withOpacity(.10),
                          fill: primary
                              ? Colors.white.withOpacity(.92)
                              : (widget.isDark
                                    ? Colors.white.withOpacity(.85)
                                    : AppColors.blue500),
                          value: widget.item.progress,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${(widget.item.progress * 100).round()}%",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: widget.compact ? 12.0 : 12.5,
                          color: smallColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================
// Quick contact preview (Phone / WhatsApp only)
// =====================
class _QuickContactPreview {
  final String phone;
  final String whatsapp;

  const _QuickContactPreview({required this.phone, required this.whatsapp});
}

class _QuickContactCard extends StatelessWidget {
  final bool compact;
  final bool isDark;
  final bool primary;
  final _QuickContactPreview data;

  const _QuickContactCard({
    required this.compact,
    required this.isDark,
    required this.primary,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF22C55E);

    final surface = primary
        ? Colors.white.withOpacity(.10)
        : (isDark
              ? Colors.white.withOpacity(.06)
              : AppColors.slate.withOpacity(.06));

    final border = primary
        ? Colors.white.withOpacity(.16)
        : (isDark
              ? Colors.white.withOpacity(.10)
              : AppColors.slate.withOpacity(.14));

    final divider = primary
        ? Colors.white.withOpacity(.12)
        : (isDark
              ? Colors.white.withOpacity(.10)
              : AppColors.slate.withOpacity(.12));

    final pad = compact ? 12.0 : 14.0;

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QCRowModern(
            compact: compact,
            primary: primary,
            isDark: isDark,
            label: "Phone",
            value: data.phone,
            icon: Icons.phone_rounded,
            accent: green,
          ),
          Padding(
            padding: EdgeInsets.only(left: compact ? 44 : 48),
            child: Divider(height: 14, thickness: 1, color: divider),
          ),
          _QCRowModern(
            compact: compact,
            primary: primary,
            isDark: isDark,
            label: "WhatsApp",
            value: data.whatsapp,
            icon: FontAwesomeIcons.whatsapp,
            accent: green,
          ),
        ],
      ),
    );
  }
}

class _QCRowModern extends StatelessWidget {
  final bool compact;
  final bool isDark;
  final bool primary;

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const _QCRowModern({
    required this.compact,
    required this.isDark,
    required this.primary,
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;

    final labelC = primary
        ? Colors.white.withOpacity(.80)
        : (isDark
              ? Colors.white.withOpacity(.72)
              : AppColors.blue500.withOpacity(.62));

    final valueC = primary
        ? Colors.white
        : (isDark ? Colors.white : AppColors.blue500);

    final iconC = primary ? Colors.white : accent;

    final bubbleBg = primary
        ? Colors.white.withOpacity(.16)
        : (isDark ? Colors.white.withOpacity(.08) : accent.withOpacity(.12));

    final bubbleBorder = primary
        ? Colors.white.withOpacity(.22)
        : (isDark ? Colors.white.withOpacity(.12) : accent.withOpacity(.22));

    final iconSize = compact ? 16.0 : 18.0;
    final bubble = compact ? 34.0 : 38.0;

    final labelFs = compact ? 11.0 : 11.8;
    final valueFs = compact ? 12.6 : 13.4;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: bubble,
          height: bubble,
          decoration: BoxDecoration(
            color: bubbleBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: bubbleBorder),
          ),
          child: Icon(icon, color: iconC, size: iconSize),
        ),
        const SizedBox(width: 10),

        // ✅ Flexible กัน overflow
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: labelFs,
                  letterSpacing: .2,
                  color: labelC,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                hasValue ? value : "-",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: valueFs,
                  color: hasValue ? valueC : labelC.withOpacity(.75),
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================
// Attendance preview widget
// =====================
class _AttendancePreviewCard extends StatelessWidget {
  final bool compact;
  final bool isDark;
  final bool primary;
  final _AttendancePreview preview;

  const _AttendancePreviewCard({
    required this.compact,
    required this.isDark,
    required this.primary,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF22C55E);
    const red = Color(0xFFEF4444);

    final surface = primary
        ? Colors.white.withOpacity(.10)
        : (isDark
              ? Colors.white.withOpacity(.06)
              : AppColors.slate.withOpacity(.06));

    final border = primary
        ? Colors.white.withOpacity(.16)
        : (isDark
              ? Colors.white.withOpacity(.10)
              : AppColors.slate.withOpacity(.14));

    final label = primary
        ? Colors.white.withOpacity(.78)
        : (isDark
              ? Colors.white.withOpacity(.70)
              : AppColors.slate.withOpacity(.75));

    final value = primary
        ? Colors.white
        : (isDark ? Colors.white : AppColors.blue500);

    final sub = primary
        ? Colors.white.withOpacity(.84)
        : (isDark
              ? Colors.white.withOpacity(.82)
              : AppColors.blue500.withOpacity(.70));

    final fsLabel = compact ? 11.0 : 12.0;
    final fsValue = compact ? 13.5 : 14.5;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: preview.hasCheckIn
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.history_rounded, size: 16, color: label),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Latest check-in",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: fsLabel,
                          color: label,
                        ),
                      ),
                    ),
                    if (preview.isLate)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: red.withOpacity(isDark ? .18 : .12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: red.withOpacity(.55)),
                        ),
                        child: const Text(
                          "Late",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 11.5,
                            color: red,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_available_rounded,
                            size: 16,
                            color: sub,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            preview.dateText,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: fsValue,
                              color: value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 16, color: sub),
                        const SizedBox(width: 6),
                        Text(
                          preview.timeText,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: fsValue,
                            color: value,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Check-in ${preview.timeText}",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: compact ? 12.2 : 13.0,
                    color: green,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 18, color: label),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "No check-in record yet",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: fsLabel,
                      color: label,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// =====================
// Attendance preview models (demo)
// =====================
class _AttRow {
  final DateTime date;
  final TimeOfDay? checkIn;
  final String reason;
  final bool come;

  const _AttRow({
    required this.date,
    required this.checkIn,
    required this.reason,
    required this.come,
  });

  bool get isLate {
    if (reason.trim().toLowerCase() == "late") return true;
    final t = checkIn;
    if (t == null) return false;
    return (t.hour > 8) || (t.hour == 8 && t.minute > 0);
  }
}

class _AttendancePreview {
  final bool hasCheckIn;
  final String dateText;
  final String timeText;
  final bool isLate;

  const _AttendancePreview({
    required this.hasCheckIn,
    required this.dateText,
    required this.timeText,
    required this.isLate,
  });

  static _AttendancePreview fromRows(List<_AttRow> rows) {
    final withCheck = rows.where((e) => e.come && e.checkIn != null).toList();
    if (withCheck.isEmpty) {
      return const _AttendancePreview(
        hasCheckIn: false,
        dateText: "",
        timeText: "",
        isLate: false,
      );
    }

    withCheck.sort((a, b) => b.date.compareTo(a.date));
    final latest = withCheck.first;

    final dateText = DateFormat("yyyy/MM/dd").format(latest.date);
    final t = latest.checkIn!;
    final hh = t.hour.toString().padLeft(2, "0");
    final mm = t.minute.toString().padLeft(2, "0");

    return _AttendancePreview(
      hasCheckIn: true,
      dateText: dateText,
      timeText: "$hh:$mm",
      isLate: latest.isLate,
    );
  }
}

class _AttendanceDemo {
  static List<_AttRow> build() {
    final base = DateTime.now();
    return [
      _AttRow(
        date: base,
        checkIn: const TimeOfDay(hour: 7, minute: 55),
        reason: "Normal",
        come: true,
      ),
      _AttRow(
        date: base.subtract(const Duration(days: 1)),
        checkIn: const TimeOfDay(hour: 8, minute: 20),
        reason: "Late",
        come: true,
      ),
      _AttRow(
        date: base.subtract(const Duration(days: 2)),
        checkIn: null,
        reason: "Sick",
        come: false,
      ),
    ];
  }
}

// =====================
// Saving mini table
// =====================
class _SavingMiniTable extends StatelessWidget {
  final bool compact;
  final bool isDark;
  final List<_SavingRow> rows;

  const _SavingMiniTable({
    required this.compact,
    required this.isDark,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    const inColor = Color(0xFF22C55E);
    const outColor = Color(0xFFEF4444);

    return LayoutBuilder(
      builder: (context, c) {
        final maxH = c.maxHeight;

        final headerH = compact ? 36.0 : 40.0;
        final rowH = compact ? 30.0 : 34.0;

        const topPad = 8.0;
        const bottomPad = 8.0;

        final availableForRows = (maxH - headerH - topPad - bottomPad).clamp(
          0.0,
          double.infinity,
        );
        int canFit = (availableForRows / rowH).floor();
        canFit = canFit.clamp(3, 5);

        final show = rows.take(canFit).toList();

        final fsDate = compact ? 10.6 : 11.4;
        final fsMoney = compact ? 11.8 : 12.6;
        final stripe = Colors.white.withOpacity(.04);

        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, topPad, 10, bottomPad),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF06162F),
                  Color(0xFF081E3E),
                  Color(0xFF0B2A6F),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.14)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(.22),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: headerH,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 12,
                        child: Text(
                          "Date",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.78),
                            fontWeight: FontWeight.w900,
                            fontSize: compact ? 10.4 : 11.0,
                            letterSpacing: .2,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "In",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.78),
                              fontWeight: FontWeight.w900,
                              fontSize: compact ? 10.4 : 11.0,
                              letterSpacing: .2,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Out",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.78),
                              fontWeight: FontWeight.w900,
                              fontSize: compact ? 10.4 : 11.0,
                              letterSpacing: .2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.white.withOpacity(.10),
                ),
                for (int i = 0; i < show.length; i++)
                  Container(
                        height: rowH,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i.isEven ? stripe : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 12,
                              child: Text(
                                show[i].dateText,
                                style: TextStyle(
                                  fontSize: fsDate,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  show[i].inText,
                                  style: TextStyle(
                                    fontSize: fsMoney,
                                    fontWeight: FontWeight.w900,
                                    color: show[i].inAmount > 0
                                        ? inColor
                                        : Colors.white.withOpacity(.18),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  show[i].outText,
                                  style: TextStyle(
                                    fontSize: fsMoney,
                                    fontWeight: FontWeight.w900,
                                    color: show[i].outAmount > 0
                                        ? outColor
                                        : Colors.white.withOpacity(.18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 180.ms, delay: (25 * i).ms)
                      .slideY(begin: .06, end: 0, duration: 180.ms),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SavingRow {
  final DateTime date;
  final int inAmount;
  final int outAmount;

  const _SavingRow({
    required this.date,
    required this.inAmount,
    required this.outAmount,
  });

  String get dateText => DateFormat('yyyy/MM/dd').format(date);
  String get inText => inAmount > 0 ? "+${_fmt(inAmount)}" : "";
  String get outText => outAmount > 0 ? "-${_fmt(outAmount)}" : "";

  static String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final left = s.length - i;
      buf.write(s[i]);
      if (left > 1 && left % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

class _SavingDemo {
  static List<_SavingRow> build() {
    final base = DateTime(2025, 1, 1);

    final deltas = <int>[
      100000,
      -50000,
      100000,
      -50000,
      100000,
      -100000,
      -10000,
      10000,
      -50000,
      100000,
    ];

    final rows = <_SavingRow>[];
    for (int i = 0; i < deltas.length; i++) {
      final d = deltas[i];
      rows.add(
        _SavingRow(
          date: base.add(Duration(days: i)),
          inAmount: d > 0 ? d : 0,
          outAmount: d < 0 ? d.abs() : 0,
        ),
      );
    }

    return rows.take(5).toList();
  }
}

// =====================
// Premium month calendar
// =====================
class _PremiumMonthCalendar extends StatelessWidget {
  final bool compact;
  final Color surface;
  final Color border;
  final Color titleColor;
  final Color subColor;
  final bool primary;

  const _PremiumMonthCalendar({
    required this.compact,
    required this.surface,
    required this.border,
    required this.titleColor,
    required this.subColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year - 5, 1, 1);
    final lastDay = DateTime(now.year + 5, 12, 31);

    return LayoutBuilder(
      builder: (context, c) {
        final maxH = c.maxHeight;

        final padTop = compact ? 8.0 : 10.0;
        final padBottom = compact ? 6.0 : 8.0;

        final headerEst = compact ? 32.0 : 36.0;
        final dowH = (compact ? 16.0 : 18.0);

        final inner = (maxH - padTop - padBottom)
            .clamp(0.0, double.infinity)
            .toDouble();
        final availForRows = (inner - headerEst - dowH)
            .clamp(0.0, double.infinity)
            .toDouble();

        final rowH = (availForRows / 6)
            .clamp(16.0, compact ? 26.0 : 28.0)
            .toDouble();

        final headerFs = compact ? 12.0 : 12.8;
        final dowFs = (dowH * 0.62)
            .clamp(9.0, compact ? 10.2 : 10.8)
            .toDouble();
        final dayFs = (rowH * 0.54)
            .clamp(10.0, compact ? 12.6 : 13.2)
            .toDouble();
        final m = (rowH * 0.10).clamp(1.5, 3.0).toDouble();

        const dayNumberColor = Colors.white;

        final todayFill = Colors.white.withOpacity(primary ? .22 : .18);
        final todayBorder = Colors.white.withOpacity(primary ? .95 : .75);

        return Container(
          padding: EdgeInsets.fromLTRB(10, padTop, 10, padBottom),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: IgnorePointer(
              ignoring: true,
              child: SizedBox.expand(
                child: TableCalendar(
                  locale: 'th_TH',
                  focusedDay: now,
                  firstDay: firstDay,
                  lastDay: lastDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableGestures: AvailableGestures.none,
                  calendarFormat: CalendarFormat.month,
                  sixWeekMonthsEnforced: true,
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    headerMargin: EdgeInsets.zero,
                    headerPadding: const EdgeInsets.only(bottom: 4),
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: headerFs,
                      color: titleColor,
                      letterSpacing: .2,
                    ),
                    titleTextFormatter: (date, locale) {
                      final month = DateFormat('MMMM', 'en').format(date);
                      return "$month ค.ศ. ${date.year}";
                    },
                  ),
                  daysOfWeekHeight: dowH,
                  rowHeight: rowH,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: dowFs,
                      color: subColor,
                    ),
                    weekendStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: dowFs,
                      color: subColor.withOpacity(.92),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    tablePadding: EdgeInsets.zero,
                    cellPadding: EdgeInsets.zero,
                    cellMargin: EdgeInsets.all(m),
                    outsideDaysVisible: false,
                    isTodayHighlighted: true,
                    defaultTextStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: dayFs,
                      color: dayNumberColor,
                      height: 1.0,
                    ),
                    weekendTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: dayFs,
                      color: dayNumberColor,
                      height: 1.0,
                    ),
                    todayTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: dayFs,
                      color: dayNumberColor,
                      height: 1.0,
                    ),
                    todayDecoration: BoxDecoration(
                      color: todayFill,
                      shape: BoxShape.circle,
                      border: Border.all(color: todayBorder, width: 1.8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                          color: Colors.black.withOpacity(.20),
                        ),
                      ],
                    ),
                  ),
                  selectedDayPredicate: (_) => false,
                  onDaySelected: (_, __) {},
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final Color bg;
  final Color fill;
  final double value;

  const _ProgressBar({
    required this.bg,
    required this.fill,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth * value.clamp(0.0, 1.0);
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: 220.ms,
              curve: Curves.easeOut,
              width: w,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =====================
// Mini menus
// =====================
class _MiniItem {
  final String id;
  final String title;
  final IconData icon;

  const _MiniItem({required this.id, required this.title, required this.icon});
}

class _MiniRows extends StatelessWidget {
  final bool compact;
  final bool tiny;
  final double fontSize;
  final bool isDark;
  final Color border;
  final Color bg;
  final Color shadow;
  final List<_MiniItem> items;
  final ValueChanged<_MiniItem> onTap;

  const _MiniRows({
    required this.compact,
    required this.tiny,
    required this.fontSize,
    required this.isDark,
    required this.border,
    required this.bg,
    required this.shadow,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDark ? Colors.white : AppColors.blue500;
    final labelColor = isDark
        ? AppColors.grayUltraLight.withOpacity(.82)
        : AppColors.blue500.withOpacity(.68);

    final top = items.take(4).toList();
    final bottom = items.skip(4).take(3).toList();
    final gap = tiny ? 8.0 : 10.0;

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              for (int i = 0; i < top.length; i++) ...[
                Expanded(
                  child: _MiniTile(
                    tiny: tiny,
                    compact: compact,
                    bg: bg,
                    border: border,
                    shadow: shadow,
                    icon: top[i].icon,
                    title: top[i].title,
                    iconColor: iconColor,
                    labelColor: labelColor,
                    fontSize: fontSize,
                    onTap: () => onTap(top[i]),
                  ),
                ),
                if (i != top.length - 1) SizedBox(width: gap),
              ],
            ],
          ),
        ),
        SizedBox(height: gap),
        Expanded(
          child: Row(
            children: [
              for (int i = 0; i < bottom.length; i++) ...[
                Expanded(
                  child: _MiniTile(
                    tiny: tiny,
                    compact: compact,
                    bg: bg,
                    border: border,
                    shadow: shadow,
                    icon: bottom[i].icon,
                    title: bottom[i].title,
                    iconColor: iconColor,
                    labelColor: labelColor,
                    fontSize: fontSize,
                    onTap: () => onTap(bottom[i]),
                  ),
                ),
                if (i != bottom.length - 1) SizedBox(width: gap),
              ],
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniTile extends StatefulWidget {
  final bool tiny;
  final bool compact;
  final Color bg;
  final Color border;
  final Color shadow;
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color labelColor;
  final double fontSize;
  final VoidCallback onTap;

  const _MiniTile({
    required this.tiny,
    required this.compact,
    required this.bg,
    required this.border,
    required this.shadow,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.labelColor,
    required this.fontSize,
    required this.onTap,
  });

  @override
  State<_MiniTile> createState() => _MiniTileState();
}

class _MiniTileState extends State<_MiniTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final h = c.maxHeight;

        final padV = (h * 0.10).clamp(3.0, widget.tiny ? 6.0 : 8.0);
        final padH = (h * 0.10).clamp(5.0, widget.tiny ? 8.0 : 10.0);
        final iconSize = (h * 0.42).clamp(14.0, widget.tiny ? 18.0 : 20.0);
        final gap = (h * 0.06).clamp(1.5, widget.tiny ? 4.0 : 5.0);
        final fs = (h * 0.22).clamp(8.0, widget.fontSize);

        return AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: 110.ms,
          curve: Curves.easeOut,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: widget.onTap,
              onTapDown: (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) => setState(() => _pressed = false),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: padH,
                    vertical: padV,
                  ),
                  decoration: BoxDecoration(
                    color: widget.bg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: widget.border),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                        color: widget.shadow,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon,
                          color: widget.iconColor,
                          size: iconSize,
                        ),
                        SizedBox(height: gap),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: fs,
                              height: 1.0,
                              color: widget.labelColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
