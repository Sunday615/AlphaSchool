import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key, required this.article});

  final NewsArticle article;

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final _commentCtl = TextEditingController();
  bool _bookmarked = false;

  @override
  void dispose() {
    _commentCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topInset = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size;

    final heroH = (size.height * 0.46).clamp(320.0, 420.0);
    final sheetTop = heroH - 54; // overlap like reference

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B1220)
          : const Color(0xFFEFF6FF),
      body: Stack(
        children: [
          // =========================================
          // HERO
          // =========================================
          SizedBox(
            height: heroH,
            width: size.width,
            child: Stack(
              children: [
                Positioned.fill(
                  child:
                      _NetImage(
                            url: widget.article.heroImageUrl,
                            fallbackColor: const Color(0xFF111827),
                          )
                          .animate()
                          .fadeIn(duration: 260.ms)
                          .scale(
                            begin: const Offset(1.03, 1.03),
                            end: const Offset(1, 1),
                            duration: 520.ms,
                            curve: Curves.easeOutCubic,
                          ),
                ),

                // overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(.12),
                          Colors.black.withOpacity(.26),
                          Colors.black.withOpacity(.62),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 80.ms, duration: 240.ms),
                ),

                // top bar (back + search)
                Positioned(
                  left: 14,
                  right: 14,
                  top: topInset + 10,
                  child: Row(
                    children: [
                      _GlassIconBtn(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => Navigator.of(context).pop(),
                          )
                          .animate()
                          .fadeIn(duration: 220.ms)
                          .slideX(
                            begin: -.12,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                      const Spacer(),
                      _GlassIconBtn(
                            icon: FontAwesomeIcons.search,
                            fa: true,
                            onTap: () {},
                          )
                          .animate()
                          .fadeIn(duration: 220.ms)
                          .slideX(
                            begin: .12,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                  ),
                ),

                // category + title
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CategoryPill(label: widget.article.category)
                          .animate()
                          .fadeIn(delay: 130.ms, duration: 240.ms)
                          .slideY(
                            begin: .18,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 10),
                      Text(
                            widget.article.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              height: 1.06,
                              letterSpacing: .2,
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 170.ms, duration: 260.ms)
                          .slideY(
                            begin: .20,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // =========================================
          // FLOAT ACTIONS (bookmark/share)
          // =========================================
          Positioned(
            right: 18,
            top: sheetTop - 46,
            child: Row(
              children: [
                _CircleActionBtn(
                      icon: _bookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                      onTap: () => setState(() => _bookmarked = !_bookmarked),
                    )
                    .animate()
                    .fadeIn(delay: 220.ms, duration: 220.ms)
                    .scale(
                      begin: const Offset(.9, .9),
                      end: const Offset(1, 1),
                    ),
                const SizedBox(width: 10),
                _CircleActionBtn(icon: Icons.share_rounded, onTap: () {})
                    .animate()
                    .fadeIn(delay: 260.ms, duration: 220.ms)
                    .scale(
                      begin: const Offset(.9, .9),
                      end: const Offset(1, 1),
                    ),
              ],
            ),
          ),

          // =========================================
          // CONTENT SHEET
          // =========================================
          Positioned.fill(
            top: sheetTop,
            child: _Sheet(
              isDark: isDark,
              child:
                  _ArticleContent(
                        isDark: isDark,
                        article: widget.article,
                        commentController: _commentCtl,
                      )
                      .animate()
                      .fadeIn(delay: 140.ms, duration: 260.ms)
                      .slideY(begin: .07, end: 0, curve: Curves.easeOutCubic),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// Sheet + content
// ======================================================

class _Sheet extends StatelessWidget {
  const _Sheet({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF0B1220) : Colors.white;
    final border = isDark ? Colors.white.withOpacity(.10) : Colors.black12;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(26),
        topRight: Radius.circular(26),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isDark ? 12 : 8,
          sigmaY: isDark ? 12 : 8,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: bg.withOpacity(isDark ? .86 : 1),
            border: Border(top: BorderSide(color: border)),
            boxShadow: [
              BoxShadow(
                blurRadius: 28,
                offset: const Offset(0, -10),
                color: Colors.black.withOpacity(isDark ? .35 : .10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ArticleContent extends StatelessWidget {
  const _ArticleContent({
    required this.isDark,
    required this.article,
    required this.commentController,
  });

  final bool isDark;
  final NewsArticle article;
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    final titleC = isDark ? Colors.white : const Color(0xFF111827);
    final subC = isDark
        ? Colors.white.withOpacity(.65)
        : const Color(0xFF9CA3AF);
    final bodyC = isDark
        ? Colors.white.withOpacity(.80)
        : const Color(0xFF6B7280);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // author
            Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: _NetImage(
                      url: article.authorAvatarUrl,
                      fallbackColor: const Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.authorName,
                        style: TextStyle(
                          color: titleC,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${article.timeAgo} / ${article.views} View",
                        style: TextStyle(
                          color: subC,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 60.ms, duration: 240.ms),

            const SizedBox(height: 16),

            _DropCapParagraph(
              isDark: isDark,
              text: article.paragraphs.isNotEmpty
                  ? article.paragraphs.first
                  : "",
            ).animate().fadeIn(delay: 90.ms, duration: 240.ms),

            const SizedBox(height: 10),

            for (int i = 1; i < article.paragraphs.length; i++) ...[
              Text(
                    article.paragraphs[i],
                    style: TextStyle(
                      color: bodyC,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 1.55,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: (120 + i * 40).ms, duration: 220.ms)
                  .slideY(begin: .06, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 4),

            _QuoteBlock(isDark: isDark, quote: article.quote)
                .animate()
                .fadeIn(delay: 220.ms, duration: 240.ms)
                .slideY(begin: .06, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: 16),

            _CommentBar(
                  isDark: isDark,
                  controller: commentController,
                  onSend: () {
                    FocusScope.of(context).unfocus();
                    commentController.clear();
                  },
                )
                .animate()
                .fadeIn(delay: 260.ms, duration: 240.ms)
                .slideY(begin: .08, end: 0, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }
}

class _DropCapParagraph extends StatelessWidget {
  const _DropCapParagraph({required this.isDark, required this.text});

  final bool isDark;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    final bodyC = isDark
        ? Colors.white.withOpacity(.80)
        : const Color(0xFF6B7280);
    final titleC = isDark ? Colors.white : const Color(0xFF111827);

    final first = text.characters.first;
    final rest = text.characters.skip(1).toString();

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: first,
            style: TextStyle(
              color: titleC,
              fontWeight: FontWeight.w900,
              fontSize: 54,
              height: 1.0,
            ),
          ),
          TextSpan(
            text: rest,
            style: TextStyle(
              color: bodyC,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuoteBlock extends StatelessWidget {
  const _QuoteBlock({required this.isDark, required this.quote});

  final bool isDark;
  final String quote;

  @override
  Widget build(BuildContext context) {
    final line = isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);
    final textC = isDark
        ? Colors.white.withOpacity(.86)
        : const Color(0xFF6B7280);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: 64,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: line,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            quote,
            style: TextStyle(
              color: textC,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _CommentBar extends StatelessWidget {
  const _CommentBar({
    required this.isDark,
    required this.controller,
    required this.onSend,
  });

  final bool isDark;
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? Colors.white.withOpacity(.08) : const Color(0xFFF3F4F6);
    final hint = isDark
        ? Colors.white.withOpacity(.45)
        : const Color(0xFF9CA3AF);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 54,
              color: bg,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write a comment…",
                    hintStyle: TextStyle(
                      color: hint,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _CircleActionBtn(
          icon: Icons.send_rounded,
          onTap: onSend,
          size: 54,
          color: const Color(0xFF2563EB),
        ),
      ],
    );
  }
}

// ======================================================
// Small UI parts
// ======================================================

class _GlassIconBtn extends StatelessWidget {
  const _GlassIconBtn({
    required this.icon,
    required this.onTap,
    this.fa = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool fa;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(.18)),
          ),
          child: Center(
            child: fa
                ? FaIcon(icon, size: 18, color: Colors.white.withOpacity(.92))
                : Icon(icon, size: 22, color: Colors.white.withOpacity(.92)),
          ),
        ),
      ),
    );
  }
}

class _CircleActionBtn extends StatelessWidget {
  const _CircleActionBtn({
    required this.icon,
    required this.onTap,
    this.size = 46,
    this.color = const Color(0xFF2563EB),
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: size / 2,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                offset: const Offset(0, 10),
                color: Colors.black.withOpacity(.22),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w900,
              fontSize: 12,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetImage extends StatelessWidget {
  const _NetImage({required this.url, required this.fallbackColor});

  final String url;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                fallbackColor.withOpacity(.85),
                fallbackColor.withOpacity(.35),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              FontAwesomeIcons.solidImage,
              color: Colors.white.withOpacity(.85),
              size: 26,
            ),
          ),
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: fallbackColor.withOpacity(.18),
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(.80),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ======================================================
// Model
// ======================================================

class NewsArticle {
  final String category;
  final String title;
  final String heroImageUrl;

  final String authorName;
  final String authorAvatarUrl;
  final String timeAgo;
  final int views;

  final List<String> paragraphs;
  final String quote;

  const NewsArticle({
    required this.category,
    required this.title,
    required this.heroImageUrl,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.timeAgo,
    required this.views,
    required this.paragraphs,
    required this.quote,
  });
}
