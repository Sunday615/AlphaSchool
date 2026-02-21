import 'dart:ui';
import 'package:alpha_school/core/widgets/scanqrcode/scan_qr_code_page.dart';
import 'package:alpha_school/features/demo/DemoTest.dart';
import 'package:alpha_school/features/home/presentation/pages/appointment/appointment_page.dart';
import 'package:alpha_school/features/home/presentation/pages/attendance/attendance_page.dart';
import 'package:alpha_school/features/home/presentation/pages/calendar/calendar_page.dart';
import 'package:alpha_school/features/home/presentation/pages/calendar/calendar_year.dart';
import 'package:alpha_school/features/home/presentation/pages/contact/contact_page.dart';
import 'package:alpha_school/features/home/presentation/pages/gallery/gallery_page.dart';
import 'package:alpha_school/features/home/presentation/pages/news/news_page.dart';
import 'package:alpha_school/features/home/presentation/pages/profile/profile.dart';
import 'package:alpha_school/features/home/presentation/pages/saving/saving_page.dart';
import 'package:alpha_school/features/home/presentation/pages/task/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:alpha_school/features/students/presentation/pages/choose_students.dart';
import 'package:remixicon/remixicon.dart';

import '../../../../../core/theme/app_colors.dart';

// ✅ ADD: profile page

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  static const _bgAsset = "assets/images/homepagewall/homepagewallpaper.jpg";

  // ✅ ADD: profile avatar asset (shown in top bar)
  static const _profileAvatarAsset = "assets/images/profile/me.jpg";

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

    // ✅ ADD: open profile page
    void openProfile() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
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

          // ✅ for FAB safe positioning
          final bottomInset = MediaQuery.of(context).padding.bottom;

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
                                  // ✅ UPDATE: show avatar IMAGE from assets + tap -> profile
                                  InkResponse(
                                        onTap: openProfile,
                                        radius: avatarRadius + 12,
                                        child: Container(
                                          width: avatarRadius * 2,
                                          height: avatarRadius * 2,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white24,
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                .20,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              _profileAvatarAsset,
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.high,
                                              errorBuilder: (_, __, ___) =>
                                                  Center(
                                                    child: FaIcon(
                                                      FontAwesomeIcons.user,
                                                      color: Colors.white,
                                                      size: avatarIconSize,
                                                    ),
                                                  ),
                                            ),
                                          ),
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

                              // ✅ Card 1
                              _AttendanceCalendarCard(
                                    height: topCardH,
                                    blur: headerBlur,
                                    scale: s,
                                    isSmallPhone: isSmallPhone,
                                    date: today,
                                    checkedIn: checkedIn,
                                    checkinTime: checkinTime,
                                    isDark: isDark,

                                    // ✅ participant 70%
                                    participantPercent: 0.70,

                                    onTapAttendance: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const AttendancePage(),
                                        ),
                                      );
                                    },
                                    onTapParticipant: () =>
                                        go(const ParticipantPage()),
                                    onTapCalendar: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const YearCalendarPage(),
                                        ),
                                      );
                                    },
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

                              // ✅ Event & Announcement card (PREVIEW ONLY — no tap)
                              IgnorePointer(
                                    ignoring: true,
                                    child: _MiniInfoCard(
                                      height: miniCardH,
                                      blur: miniBlur,
                                      scale: s,
                                      isSmallPhone: isSmallPhone,
                                      isTablet: isTablet || isLargeTablet,
                                      eventText: "ປີໃໝ່ລາວ 2026",
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

                // ==========================================================
                // ✅ Scan QR Floating Button
                // ==========================================================
                Positioned(
                  right: (isTablet || isLargeTablet) ? 22 : 16,
                  bottom: (12 + bottomInset).toDouble(),
                  child:
                      _ScanQrFab(
                            isSmallPhone: isSmallPhone,
                            onTap: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ScanQrCodePage(),
                                ),
                              );

                              if (result != null) {
                                debugPrint("QR = $result");
                              }
                            },
                          )
                          .animate()
                          .fadeIn(delay: 220.ms, duration: 240.ms)
                          .scale(
                            begin: const Offset(.92, .92),
                            end: const Offset(1, 1),
                            duration: 260.ms,
                            curve: Curves.easeOutBack,
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

// ======================================================
// ✅ Floating Scan QR Button (Dark Blue Premium)
// ======================================================
class _ScanQrFab extends StatelessWidget {
  final bool isSmallPhone;
  final VoidCallback onTap;

  const _ScanQrFab({required this.isSmallPhone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final d = isSmallPhone ? 68.0 : 78.0;
    final iconSize = (d * 0.58).clamp(32.0, 44.0);

    const premiumGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0B2A66), Color(0xFF0A3E9A), Color(0xFF0A57D6)],
      stops: [0.0, 0.55, 1.0],
    );

    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: d / 2,
        child: Container(
          width: d,
          height: d,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: premiumGradient,
            border: Border.all(color: Colors.white.withOpacity(.18), width: 1),
            boxShadow: [
              BoxShadow(
                blurRadius: 26,
                offset: const Offset(0, 16),
                color: Colors.black.withOpacity(.30),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Remix.qr_scan_2_line,
              size: iconSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// =====================
// ✅ TOP CARD: Attendance + Calendar
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

  // ✅ participant percent (0.0 - 1.0)
  final double participantPercent;

  // ✅ taps
  final VoidCallback onTapAttendance;
  final VoidCallback onTapCalendar;
  final VoidCallback? onTapParticipant;

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
    this.onTapParticipant,
    this.participantPercent = 0.70,
  });

  String _fmtTime(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final titleSize = isSmallPhone ? 12.5 : 13.0;
    final valueSize = isSmallPhone ? 15.0 : 16.0;
    final labelSize = isSmallPhone ? 11.0 : 12.0;

    final statusColor = checkedIn ? Colors.greenAccent : Colors.redAccent;
    final statusText = checkedIn ? "Checked-In" : "Not Checked-In";

    final pct = participantPercent.clamp(0.0, 1.0);
    final pctLabel = "${(pct * 100).round()}%";

    final padL = isSmallPhone ? 14.0 : 16.0;
    final padT = isSmallPhone ? 12.0 : 14.0;
    final padR = isSmallPhone ? 12.0 : 14.0;
    final padB = isSmallPhone ? 12.0 : 14.0;

    final rowDivider = Container(
      height: 1,
      color: Colors.white.withOpacity(.20),
    );

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
              // ✅ LEFT
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(padL, padT, padR, padB),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== TITLE ROW =====
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.clipboardUser,
                            size: isSmallPhone ? 13.0 : 14.0,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "ຕິດຕາມການມາໂຮງຮຽນ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: titleSize,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isSmallPhone ? 10 : 12),

                      Expanded(
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
                            child: Column(
                              children: [
                                // Row 1
                                Expanded(
                                  flex: 2,
                                  child: _TapScale(
                                    onTap: onTapAttendance,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallPhone ? 12 : 14,
                                        vertical: isSmallPhone ? 10 : 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                statusText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: valueSize,
                                                  height: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.clock,
                                                size: isSmallPhone
                                                    ? 12.0
                                                    : 13.0,
                                                color: Colors.white.withOpacity(
                                                  .88,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  _fmtTime(checkinTime),
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(.95),
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: valueSize,
                                                    height: 1.0,
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

                                rowDivider,

                                // Row 2: Participant (bar + %ท้าย bar)
                                Expanded(
                                  flex: 3,
                                  child: _TapScale(
                                    onTap: onTapParticipant ?? onTapAttendance,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        isSmallPhone ? 12 : 14,
                                        isSmallPhone ? 10 : 12,
                                        isSmallPhone ? 12 : 14,
                                        isSmallPhone ? 10 : 12,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.userGroup,
                                                color: Colors.white.withOpacity(
                                                  .92,
                                                ),
                                                size: isSmallPhone
                                                    ? 13.0
                                                    : 14.0,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  "ຄະແນນການມີສ່ວນຮ່ວມ",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(.96),
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: labelSize,
                                                    height: 1.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: isSmallPhone ? 8 : 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _PercentBar(
                                                  height: isSmallPhone
                                                      ? 12.0
                                                      : 14.0,
                                                  value: pct,
                                                  isSmallPhone: isSmallPhone,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  pctLabel,
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(.98),
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: isSmallPhone
                                                        ? 12.5
                                                        : 14.0,
                                                    height: 1.0,
                                                    letterSpacing: .2,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(width: 1, color: Colors.white.withOpacity(.12)),

              // ✅ RIGHT (Calendar)
              Expanded(
                child: _TapScale(
                  onTap: onTapCalendar,
                  child: Padding(
                    padding: EdgeInsets.all(isSmallPhone ? 12.0 : 14.0),
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
    final headerH = widget.isSmallPhone ? 30.0 : 34.0;

    return Column(
      children: [
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
            ignoring: true,
            child: SfCalendar(
              controller: _ctrl,
              view: CalendarView.month,
              initialDisplayDate: widget.initialDate,
              backgroundColor: Colors.transparent,
              headerHeight: 0,
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
              selectionDecoration: BoxDecoration(
                color: Colors.white.withOpacity(.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(.35),
                  width: 1,
                ),
              ),
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
// ✅ Mini info (Event & Announcement)
// =====================
class _MiniInfoCard extends StatelessWidget {
  final double height;
  final double blur;
  final double scale;
  final bool isSmallPhone;
  final bool isTablet;

  /// ✅ Event content (วันนี้มี Event อะไร)
  final String eventText;

  const _MiniInfoCard({
    required this.height,
    required this.blur,
    required this.scale,
    required this.isSmallPhone,
    required this.isTablet,
    required this.eventText,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isSmallPhone ? 16.0 : 18.0;
    final titleSize = isSmallPhone ? 13.0 : 14.0;
    final bodySize = isSmallPhone ? 12.5 : 13.5;

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
                // Header: icon + title + small pill
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.bullhorn,
                      color: Colors.white.withOpacity(.92),
                      size: iconSize,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Event & Announcement",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.98),
                          fontWeight: FontWeight.w900,
                          fontSize: titleSize,
                          height: 1.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallPhone ? 8 : 10,
                        vertical: isSmallPhone ? 4 : 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withOpacity(.18),
                        ),
                      ),
                      child: Text(
                        "Today",
                        style: TextStyle(
                          color: Colors.white.withOpacity(.92),
                          fontWeight: FontWeight.w800,
                          fontSize: isSmallPhone ? 10.0 : 11.0,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isSmallPhone ? 8.0 : 10.0),

                // Body: calendar icon + event text
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.calendarDays,
                      color: Colors.white.withOpacity(.85),
                      size: isSmallPhone ? 14.0 : 15.0,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        eventText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.95),
                          fontWeight: FontWeight.w900,
                          fontSize: bodySize,
                          height: 1.10,
                          letterSpacing: .2,
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
    );
  }
}

// ✅ Percent bar
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

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;

        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.16),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withOpacity(.30),
                width: 1,
              ),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: v01),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, t, _) {
                final markerLeft = (w * t - 1).clamp(0.0, w - 2.0);

                return Stack(
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: t,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white.withOpacity(.98),
                              Colors.white.withOpacity(.86),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 1,
                        color: Colors.white.withOpacity(.40),
                      ),
                    ),
                    Positioned(
                      left: markerLeft,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.white.withOpacity(.95),
                      ),
                    ),
                    Positioned(
                      left: (markerLeft - 3).clamp(0.0, w - 8.0),
                      top: (height / 2 - 4).clamp(0.0, height - 8.0),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(.98),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                              color: Colors.black.withOpacity(.22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
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
            MaterialPageRoute(builder: (_) => const NewsPage()),
          );
        },
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.images,
        label: "ຄັງຮູບພາບ",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GalleryPage()),
          );
        },
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.userClock,
        label: "ນັດໝາຍ",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AppointmentPage()),
          );
        },
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.book,
        label: "ວຽກບ້ານ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.plus,
        label: "ວຽກພິເສດ",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskPage()),
          );
        },
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

// =====================
// ✅ Tap helper (UPDATED: support enabled=false)
// =====================
class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool enabled;

  const _TapScale({
    required this.child,
    required this.onTap,
    this.enabled = true,
  });

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

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
// ✅ Placeholder pages
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

class EventAnnouncementPage extends StatelessWidget {
  const EventAnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event & Announcement")),
      body: const Center(child: Text("EventAnnouncementPage()")),
    );
  }
}
