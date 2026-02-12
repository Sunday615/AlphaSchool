import 'dart:ui';
import 'package:alpha_school/features/demo/DemoTest.dart';
import 'package:alpha_school/features/home/presentation/pages/attendance/attendance_page.dart';
import 'package:alpha_school/features/home/presentation/pages/calendar/calendar_page.dart';
import 'package:alpha_school/features/home/presentation/pages/contact/contact_page.dart';
import 'package:alpha_school/features/home/presentation/pages/saving/saving_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:alpha_school/features/students/presentation/pages/choose_students.dart';

import '../../../../../core/theme/app_colors.dart';

// ✅ TODO: ปรับ path import ให้ตรงโปรเจกต์คุณ
// import '../students/presentation/pages/students_card_list_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  static const _bgAsset = "assets/images/homepagewall/homepagewallpaper.jpg";

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    // ✅ ตัวอย่างข้อมูล (ค่อยผูกกับ API/State จริงได้)
    final today = DateTime.now();
    final bool checkedIn = true;
    final TimeOfDay checkinTime = const TimeOfDay(hour: 8, minute: 15);

    final String studentName = "Student Name";
    final String studentClass = "Class 5A";

    void go(Widget page) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          // ===== Breakpoints =====
          final isSmallPhone = w < 360;
          final isTablet = w >= 600 && w < 1024;
          final isLargeTablet = w >= 1024;

          // ===== Responsive scalars =====
          double clamp(double v, double min, double max) =>
              v.clamp(min, max).toDouble();
          final s = clamp(w / 375.0, 0.88, 1.35);

          final pagePadH = (isTablet || isLargeTablet) ? 22.0 : 18.0;
          final topPad = isSmallPhone ? 8.0 : 10.0;

          final gapAfterTopbar = isSmallPhone ? 8.0 : 12.0;
          final gapBetweenCards = isSmallPhone ? 8.0 : 12.0;

          final topCardH = isSmallPhone ? 170.0 : (isTablet ? 200.0 : 190.0);
          final miniCardH = isSmallPhone ? 82.0 : 96.0;

          final avatarRadius = isSmallPhone ? 20.0 : 24.0;
          final avatarIconSize = isSmallPhone ? 18.0 : 22.0;

          final topBtnSize = isSmallPhone ? 40.0 : 44.0;
          final topBtnIcon = isSmallPhone ? 18.0 : 20.0;

          final bgBlur = isSmallPhone ? 7.0 : 8.0;
          final headerBlur = isSmallPhone ? 14.0 : 16.0;
          final miniBlur = isSmallPhone ? 12.0 : 14.0;
          final sheetBlur = isSmallPhone ? 16.0 : 18.0;

          final topBarH = (avatarRadius * 2) + 6;
          final desiredHeader =
              topPad +
              topBarH +
              gapAfterTopbar +
              topCardH +
              gapBetweenCards +
              miniCardH;

          final headerMax = clamp(
            h * (isSmallPhone ? 0.62 : 0.58),
            280.0,
            520.0,
          );
          final headerH = clamp(desiredHeader, 280.0, headerMax);

          return SizedBox(
            height: h,
            width: w,
            child: Stack(
              children: [
                // ===== BACKGROUND IMAGE =====
                Positioned.fill(
                  child:
                      Image.asset(
                            _bgAsset,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            alignment: Alignment.topCenter,
                          )
                          .animate()
                          .fadeIn(duration: 260.ms)
                          .scale(
                            begin: const Offset(1.02, 1.02),
                            end: const Offset(1, 1),
                            duration: 480.ms,
                            curve: Curves.easeOutCubic,
                          ),
                ),

                // ===== SOFT BLUR =====
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: bgBlur, sigmaY: bgBlur),
                    child: const SizedBox.shrink(),
                  ),
                ),

                // ===== DARK OVERLAY =====
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(isDark ? .22 : .16),
                          Colors.black.withOpacity(isDark ? .38 : .28),
                          Colors.black.withOpacity(isDark ? .54 : .42),
                        ],
                      ),
                    ),
                  ),
                ),

                // ===== OPTIONAL GLOW BLOBS =====
                Positioned.fill(
                  child: IgnorePointer(
                    child: Stack(
                      children: [
                        Positioned(
                          top: isSmallPhone ? -100.0 : -120.0,
                          left: isSmallPhone ? -70.0 : -90.0,
                          child: _GlowBlob(
                            size: (isSmallPhone ? 240.0 : 280.0) * s,
                            color: Colors.white.withOpacity(.10),
                          ),
                        ),
                        Positioned(
                          top: isSmallPhone ? 20.0 : 30.0,
                          right: isSmallPhone ? -95.0 : -120.0,
                          child: _GlowBlob(
                            size: (isSmallPhone ? 280.0 : 320.0) * s,
                            color: Colors.white.withOpacity(.08),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // ===== HEADER CONTENT =====
                      SizedBox(
                        height: headerH,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            pagePadH,
                            topPad,
                            pagePadH,
                            0.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ TOP BAR
                              Row(
                                children: [
                                  CircleAvatar(
                                        radius: avatarRadius,
                                        backgroundColor: Colors.white24,
                                        child: FaIcon(
                                          FontAwesomeIcons.user,
                                          color: Colors.white,
                                          size: avatarIconSize,
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(duration: 220.ms)
                                      .scale(
                                        begin: const Offset(.9, .9),
                                        end: const Offset(1, 1),
                                        curve: Curves.easeOutBack,
                                        duration: 260.ms,
                                      ),

                                  SizedBox(width: isSmallPhone ? 10 : 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          studentName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: isSmallPhone ? 13.5 : 15,
                                            height: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          studentClass,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              .75,
                                            ),
                                            fontWeight: FontWeight.w800,
                                            fontSize: isSmallPhone ? 11.0 : 12,
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).animate().fadeIn(
                                    delay: 60.ms,
                                    duration: 220.ms,
                                  ),

                                  _TopIconButton(
                                        icon: FontAwesomeIcons.bell,
                                        onTap: () {},
                                        size: topBtnSize,
                                        iconSize: topBtnIcon,
                                      )
                                      .animate()
                                      .fadeIn(delay: 100.ms, duration: 220.ms)
                                      .slideX(begin: .15, end: 0),

                                  const SizedBox(width: 10),

                                  // ✅ when click go to StudentsCardListPage()
                                  _TopIconButton(
                                        icon: FontAwesomeIcons.arrowsRotate,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const StudentsCardListPage(),
                                            ),
                                          );
                                        },
                                        size: topBtnSize,
                                        iconSize: topBtnIcon,
                                      )
                                      .animate()
                                      .fadeIn(delay: 140.ms, duration: 220.ms)
                                      .slideX(begin: .15, end: 0),
                                ],
                              ),

                              SizedBox(height: gapAfterTopbar),

                              // ✅ Card 1: tappable -> new page
                              _TapScale(
                                    onTap: () =>
                                        go(const AttendanceCalendarPage()),
                                    child: _AttendanceCalendarCard(
                                      height: topCardH,
                                      blur: headerBlur,
                                      scale: s,
                                      isSmallPhone: isSmallPhone,
                                      date: today,
                                      checkedIn: checkedIn,
                                      checkinTime: checkinTime,
                                      isDark: isDark,

                                      // ✅ NEW
                                      onTapAttendance: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const AttendancePage(),
                                          ),
                                        );
                                      },
                                      onTapCalendar: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const CalendarPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: 120.ms, duration: 260.ms)
                                  .slideY(
                                    begin: .18,
                                    end: 0,
                                    duration: 320.ms,
                                    curve: Curves.easeOutCubic,
                                  ),

                              SizedBox(height: gapBetweenCards),

                              // ✅ Participant: tappable -> new page
                              _TapScale(
                                    onTap: () => go(const ParticipantPage()),
                                    child: _MiniInfoCard(
                                      height: miniCardH,
                                      blur: miniBlur,
                                      scale: s,
                                      isSmallPhone: isSmallPhone,
                                      isTablet: isTablet || isLargeTablet,
                                      participantPercent: 0.70,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: 170.ms, duration: 260.ms)
                                  .slideY(
                                    begin: .18,
                                    end: 0,
                                    duration: 320.ms,
                                    curve: Curves.easeOutCubic,
                                  ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        child: _WalletSheet(
                          isDark: isDark,
                          width: w,
                          isSmallPhone: isSmallPhone,
                          isTablet: isTablet,
                          isLargeTablet: isLargeTablet,
                          blur: sheetBlur,
                          scale: s,
                        ).animate().fadeIn(delay: 120.ms, duration: 240.ms),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =====================
// ✅ TOP CARD: Attendance + Calendar (Syncfusion)
// =====================
class _AttendanceCalendarCard extends StatelessWidget {
  final double height;
  final double blur;
  final double scale;
  final bool isSmallPhone;

  final DateTime date;
  final bool checkedIn;
  final TimeOfDay checkinTime;
  final bool isDark;

  // ✅ NEW: callbacks แยกซ้าย/ขวา
  final VoidCallback onTapAttendance;
  final VoidCallback onTapCalendar;

  const _AttendanceCalendarCard({
    required this.height,
    required this.blur,
    required this.scale,
    required this.isSmallPhone,
    required this.date,
    required this.checkedIn,
    required this.checkinTime,
    required this.isDark,
    required this.onTapAttendance,
    required this.onTapCalendar,
  });

  String _fmtYMD(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}/$mm/$dd';
  }

  String _fmtTime(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final titleSize = isSmallPhone ? 12.5 : 13.0;
    final valueSize = isSmallPhone ? 14.0 : 15.0;
    final labelSize = isSmallPhone ? 11.5 : 12.0;

    final statusColor = checkedIn ? Colors.greenAccent : Colors.redAccent;
    final statusText = checkedIn ? "Checked-In" : "Not Checked-In";

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.10),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(.14)),
          ),
          child: Row(
            children: [
              // ✅ LEFT (Attendance) - tappable
              Expanded(
                child: _TapScale(
                  onTap: onTapAttendance,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isSmallPhone ? 14.0 : 16.0,
                      isSmallPhone ? 12.0 : 14.0,
                      isSmallPhone ? 12.0 : 14.0,
                      isSmallPhone ? 12.0 : 14.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.clipboardUser,
                              size: isSmallPhone ? 13.0 : 14.0,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "ຕິດຕາມການມາໂຮງຮຽນ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: titleSize,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ວັນທີ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(.70),
                                fontWeight: FontWeight.w700,
                                fontSize: labelSize,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _fmtYMD(date),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: valueSize,
                              ),
                            ),
                            SizedBox(height: isSmallPhone ? 6 : 8),
                            Text(
                              "ສະຖານະ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(.70),
                                fontWeight: FontWeight.w700,
                                fontSize: labelSize,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              statusText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w900,
                                fontSize: valueSize,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.clock,
                              size: isSmallPhone ? 12.0 : 13.0,
                              color: Colors.white.withOpacity(.86),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Check-in: ${_fmtTime(checkinTime)}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.86),
                                  fontWeight: FontWeight.w800,
                                  fontSize: labelSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ✅ divider
              Container(width: 1, color: Colors.white.withOpacity(.12)),

              // ✅ RIGHT (Calendar) - tappable
              Expanded(
                child: _TapScale(
                  onTap: onTapCalendar,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isSmallPhone ? 10.0 : 12.0,
                      isSmallPhone ? 10.0 : 12.0,
                      isSmallPhone ? 12.0 : 14.0,
                      isSmallPhone ? 10.0 : 12.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.06),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(.10),
                          ),
                        ),
                        child: _MonthCalendarGlass(
                          initialDate: date,
                          isDark: isDark,
                          isSmallPhone: isSmallPhone,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================
// ✅ Calendar with header (NO prev/next)
// =====================
class _MonthCalendarGlass extends StatefulWidget {
  final DateTime initialDate;
  final bool isDark;
  final bool isSmallPhone;

  const _MonthCalendarGlass({
    required this.initialDate,
    required this.isDark,
    required this.isSmallPhone,
  });

  @override
  State<_MonthCalendarGlass> createState() => _MonthCalendarGlassState();
}

class _MonthCalendarGlassState extends State<_MonthCalendarGlass> {
  late final CalendarController _ctrl;
  late DateTime _display;

  static const _months = <String>[
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = CalendarController();
    _display = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
    _ctrl.displayDate = _display;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final headerH = widget.isSmallPhone ? 30.0 : 34.0;

    return Column(
      children: [
        // ✅ Header แสดงเดือน/ปี อย่างเดียว (เอา prev/next ออก)
        Container(
          height: headerH,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF001E51), Color(0xFF003A8C), Color(0xFF001E51)],
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                offset: const Offset(0, 10),
                color: Colors.black.withOpacity(.20),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "${_months[_display.month - 1]} ${_display.year}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(.96),
                fontWeight: FontWeight.w900,
                fontSize: widget.isSmallPhone ? 11.0 : 12.0,
                letterSpacing: .2,
              ),
            ),
          ),
        ),

        Expanded(
          child: IgnorePointer(
            ignoring: true, // ✅ preview only: disable ALL taps/selection/drag
            child: SfCalendar(
              controller: _ctrl,
              view: CalendarView.month,
              initialDisplayDate: widget.initialDate,
              backgroundColor: Colors.transparent,

              headerHeight: 0,

              // ✅ ยัง swipe เปลี่ยนเดือนได้ (เพราะเป็น gesture ภายใน calendar)
              // แต่พอ IgnorePointer = true จะ "ปิด swipe ด้วย" เช่นกัน
              // ถ้าคุณอยากให้ swipe ยังได้อยู่ ให้ดูตัวเลือกด้านล่าง (Option B)
              monthViewSettings: const MonthViewSettings(
                showAgenda: false,
                navigationDirection: MonthNavigationDirection.horizontal,
              ),

              viewHeaderHeight: widget.isSmallPhone ? 18 : 26,
              viewHeaderStyle: ViewHeaderStyle(
                dayTextStyle: TextStyle(
                  color: Colors.white.withOpacity(.70),
                  fontWeight: FontWeight.w800,
                  fontSize: widget.isSmallPhone ? 9.5 : 10.5,
                ),
              ),

              todayHighlightColor: Colors.white.withOpacity(.90),

              // ✅ selection decoration คงไว้ได้ (แต่จะไม่เกิด selection แล้ว)
              selectionDecoration: BoxDecoration(
                color: Colors.white.withOpacity(.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(.35),
                  width: 1,
                ),
              ),

              // ✅ onViewChanged จะไม่ถูกเรียกแล้วเมื่อ IgnorePointer=true (เพราะ swipe ถูกปิด)
              // ถ้าจะให้ swipe ได้ ให้ดู Option B ด้านล่าง
              monthCellBuilder: (context, details) {
                final d = details.date;
                final now = DateTime.now();
                final isToday = _isSameDate(d, now);

                final inMonth =
                    d.month ==
                    (_ctrl.displayDate?.month ?? widget.initialDate.month);

                final textColor = inMonth
                    ? Colors.white.withOpacity(.88)
                    : Colors.white.withOpacity(.45);

                return Center(
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday
                          ? Colors.white.withOpacity(.18)
                          : Colors.transparent,
                      border: isToday
                          ? Border.all(
                              color: Colors.white.withOpacity(.85),
                              width: 1.2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${d.day}',
                        style: TextStyle(
                          color: isToday ? Colors.white : textColor,
                          fontWeight: isToday
                              ? FontWeight.w900
                              : FontWeight.w800,
                          fontSize: widget.isSmallPhone ? 10.0 : 10.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// =====================
// Mini info
// =====================
class _MiniInfoCard extends StatelessWidget {
  final double height;
  final double blur;
  final double scale;
  final bool isSmallPhone;
  final bool isTablet;

  /// ✅ 0.0 - 1.0 (เช่น 0.70 = 70%)
  final double participantPercent;

  const _MiniInfoCard({
    required this.height,
    required this.blur,
    required this.scale,
    required this.isSmallPhone,
    required this.isTablet,
    required this.participantPercent,
  });

  @override
  Widget build(BuildContext context) {
    final pct = participantPercent.clamp(0.0, 1.0);
    final pctText = "${(pct * 100).round()}%";

    final iconSize = isSmallPhone ? 16.0 : 18.0;
    final titleSize = isSmallPhone ? 13.0 : 14.0;

    final pctSize = isSmallPhone ? 18.0 : 20.0;
    final barH = isSmallPhone ? 12.0 : 14.0;
    final gapTop = isSmallPhone ? 8.0 : 10.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.10),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(.14)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isSmallPhone ? 14.0 : 16.0,
              isSmallPhone ? 12.0 : 14.0,
              isSmallPhone ? 14.0 : 16.0,
              isSmallPhone ? 12.0 : 14.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.userGroup,
                      color: Colors.white.withOpacity(.92),
                      size: iconSize,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "ຄະແນນການມີສ່ວນຮ່ວມ",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: titleSize,
                          height: 1.0,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          pctText,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.98),
                            fontWeight: FontWeight.w900,
                            fontSize: pctSize,
                            height: 1.0,
                            letterSpacing: .2,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: gapTop),
                Row(
                  children: [
                    Expanded(
                      child: _PercentBar(
                        height: barH,
                        value: pct,
                        isSmallPhone: isSmallPhone,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PercentBar extends StatelessWidget {
  final double height;
  final double value;
  final bool isSmallPhone;

  const _PercentBar({
    required this.height,
    required this.value,
    required this.isSmallPhone,
  });

  double _to01(double v) {
    if (v > 1.0) return (v / 100.0).clamp(0.0, 1.0);
    return v.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final v01 = _to01(value);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.35),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(.25), width: 1.2),
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: v01),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          builder: (context, t, _) {
            return LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final x = (w * t).clamp(0.0, w);

                final knobSize = height * 1.25;
                final knobLeft = (x - knobSize / 2).clamp(0.0, w - knobSize);

                return Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: t,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.95),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 14,
                              spreadRadius: 1,
                              color: Colors.white.withOpacity(.18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...[0.0, 0.25, 0.5, 0.75, 1.0].map((f) {
                      final left = (w * f - 0.5).clamp(0.0, w - 1);
                      return Positioned(
                        left: left,
                        top: 2,
                        bottom: 2,
                        child: Container(
                          width: 1,
                          color: Colors.white.withOpacity(f == 0.5 ? .28 : .18),
                        ),
                      );
                    }),
                    Positioned(
                      left: (x - 1).clamp(0.0, w - 2),
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.white.withOpacity(.95),
                      ),
                    ),
                    Positioned(
                      left: knobLeft,
                      top: (height - knobSize) / 2,
                      child: Container(
                        width: knobSize,
                        height: knobSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(.98),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                              color: Colors.black.withOpacity(.25),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// =====================
// ✅ Mini Pill (คงเดิม)
// =====================
class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double? percent;

  const _MiniPill({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isSmallPhone = w < 360;

    final iconBox = isSmallPhone ? 36.0 : 40.0;
    final iconSize = isSmallPhone ? 16.0 : 17.0;

    final titleSize = isSmallPhone ? 12.5 : 13.0;
    final subSize = isSmallPhone ? 11.0 : 11.5;

    final pct = percent == null ? null : percent!.clamp(0.0, 1.0);
    final pctText = pct == null ? null : "${(pct * 100).round()}%";
    final pctSize = isSmallPhone ? 18.0 : 20.0;
    final pctHint = isSmallPhone ? 10.0 : 10.5;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallPhone ? 12.0 : 14.0,
          vertical: isSmallPhone ? 10.0 : 12.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.12)),
        ),
        child: Row(
          children: [
            Container(
              width: iconBox,
              height: iconBox,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(.14)),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: Colors.white.withOpacity(.94),
                  size: iconSize,
                ),
              ),
            ),
            SizedBox(width: isSmallPhone ? 10 : 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.98),
                      fontWeight: FontWeight.w900,
                      fontSize: titleSize,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.70),
                      fontWeight: FontWeight.w700,
                      fontSize: subSize,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            if (pctText != null) ...[
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pctText,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.98),
                      fontWeight: FontWeight.w900,
                      fontSize: pctSize,
                      height: 1.0,
                      letterSpacing: .2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "percent",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.60),
                      fontWeight: FontWeight.w700,
                      fontSize: pctHint,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const _TopIconButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: size / 2 + 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(.12)),
        ),
        child: Center(
          child: FaIcon(
            icon,
            color: Colors.white.withOpacity(.92),
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

// =====================
// ✅ GLASS MENU SHEET (คงเดิม)
// =====================
class _WalletSheet extends StatelessWidget {
  final bool isDark;
  final double width;
  final bool isSmallPhone;
  final bool isTablet;
  final bool isLargeTablet;
  final double blur;
  final double scale;

  const _WalletSheet({
    required this.isDark,
    required this.width,
    required this.isSmallPhone,
    required this.isTablet,
    required this.isLargeTablet,
    required this.blur,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final bg = const Color.fromARGB(
      255,
      0,
      30,
      81,
    ).withOpacity(isDark ? .18 : .14);
    final border = Colors.white.withOpacity(isDark ? .18 : .22);

    final crossAxisCount = isLargeTablet ? 6 : (isTablet ? 5 : 4);
    final spacing = isSmallPhone ? 14.0 : 18.0;

    final childAspectRatio = isLargeTablet
        ? 0.95
        : isTablet
        ? 0.92
        : isSmallPhone
        ? 0.88
        : 0.92;

    final titleSize = isSmallPhone ? 16.0 : 18.0;

    final items = <_QuickMenuItem>[
      _QuickMenuItem(
        icon: FontAwesomeIcons.headset,
        label: "ຕິດຕໍ່ໂຮງຮຽນ",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactPage()),
          );
        },
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.piggyBank,
        label: "ເງິນຝາກປະຍັດ",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SavingPage()),
          );
        },
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.newspaper,
        label: "ຂ່າວ ແລະ ກິດຈະກຳ",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubPageDemo()),
          );
        },
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.images,
        label: "ຄັງຮູບພາບ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.userClock,
        label: "ນັດໝາຍ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.book,
        label: "ວຽກບ້ານ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.plus,
        label: "ວຽກພິເສດ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.fileAlt,
        label: "ລາຍງານ",
        onTap: () {},
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        const revealTop = 12.0;

        return Column(
          children: [
            const SizedBox(height: revealTop),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  (isTablet || isLargeTablet) ? 18.0 : 14.0,
                  0.0,
                  (isTablet || isLargeTablet) ? 18.0 : 14.0,
                  (isTablet || isLargeTablet) ? 18.0 : 14.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: border, width: 1),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            offset: const Offset(0, 14),
                            color: Colors.black.withOpacity(isDark ? .30 : .14),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(.12),
                                    Colors.white.withOpacity(.04),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              isSmallPhone ? 16.0 : 18.0,
                              isSmallPhone ? 14.0 : 16.0,
                              isSmallPhone ? 16.0 : 18.0,
                              isSmallPhone ? 16.0 : 18.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ເມນູທັງຫມົດ",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.95),
                                    fontWeight: FontWeight.w900,
                                    fontSize: titleSize,
                                  ),
                                ),
                                SizedBox(height: isSmallPhone ? 12.0 : 14.0),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        mainAxisSpacing: spacing,
                                        crossAxisSpacing: spacing,
                                        childAspectRatio: childAspectRatio,
                                      ),
                                  itemBuilder: (context, i) {
                                    final it = items[i];
                                    return _QuickMenuTile(
                                          item: it,
                                          isDark: isDark,
                                          isSmallPhone: isSmallPhone,
                                          isTablet: isTablet || isLargeTablet,
                                        )
                                        .animate()
                                        .fadeIn(
                                          delay: (60 + i * 45).ms,
                                          duration: 220.ms,
                                        )
                                        .slideY(begin: .12, end: 0);
                                  },
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
            ),
          ],
        );
      },
    );
  }
}

class _QuickMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  _QuickMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });
}

class _QuickMenuTile extends StatelessWidget {
  final _QuickMenuItem item;
  final bool isDark;
  final bool isSmallPhone;
  final bool isTablet;

  const _QuickMenuTile({
    required this.item,
    required this.isDark,
    required this.isSmallPhone,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = item.enabled;

    final ring = Colors.white.withOpacity(enabled ? .85 : .35);
    final circleBg = Colors.white.withOpacity(enabled ? .08 : .04);

    final iconC = Colors.white.withOpacity(enabled ? .95 : .40);
    final textC = Colors.white.withOpacity(enabled ? .92 : .40);

    final double circle = isTablet ? 72.0 : (isSmallPhone ? 56.0 : 66.0);
    final double iconSize = isTablet ? 24.0 : (isSmallPhone ? 20.0 : 22.0);
    final double labelSize = isTablet ? 12.0 : (isSmallPhone ? 10.8 : 11.5);

    return InkResponse(
      onTap: enabled ? item.onTap : null,
      radius: circle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: circle,
            height: circle,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleBg,
              border: Border.all(color: ring, width: 1.2),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(enabled ? .18 : .08),
                ),
              ],
            ),
            child: Center(
              child: FaIcon(item.icon, color: iconC, size: iconSize),
            ),
          ),
          SizedBox(height: isSmallPhone ? 8.0 : 10.0),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              height: 1.08,
              color: textC,
              fontWeight: FontWeight.w800,
              fontSize: labelSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}

class _FakeSlider extends StatelessWidget {
  final String valueText;
  const _FakeSlider({required this.valueText});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isSmallPhone = w < 360;

    return Container(
      height: isSmallPhone ? 30.0 : 34.0,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      padding: EdgeInsets.symmetric(horizontal: isSmallPhone ? 8.0 : 10.0),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: isSmallPhone ? 9.0 : 10.0,
                width: isSmallPhone ? 90.0 : 120.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          Text(
            valueText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: isSmallPhone ? 11.5 : 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// ✅ Tap helper (นุ่มๆ แบบ iOS)
// =====================
class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _TapScale({required this.child, required this.onTap});

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

// =====================
// ✅ Placeholder pages (เปลี่ยนเป็นของจริงได้)
// =====================
class AttendanceCalendarPage extends StatelessWidget {
  const AttendanceCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance & Calendar")),
      body: const Center(child: Text("AttendanceCalendarPage()")),
    );
  }
}

class ParticipantPage extends StatelessWidget {
  const ParticipantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Participant")),
      body: const Center(child: Text("ParticipantPage()")),
    );
  }
}
