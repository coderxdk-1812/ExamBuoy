import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AnimatedMarkdown extends StatefulWidget {
  final String data;
  final TextStyle? textStyle;
  final Duration speed;
  final VoidCallback? onComplete;

  const AnimatedMarkdown({
    super.key,
    required this.data,
    this.textStyle,
    this.speed = const Duration(milliseconds: 20),
    this.onComplete,
  });

  @override
  State<AnimatedMarkdown> createState() => _AnimatedMarkdownState();
}

class _AnimatedMarkdownState extends State<AnimatedMarkdown>
    with SingleTickerProviderStateMixin {
  String _displayedText = '';
  int _currentIndex = 0;
  bool _isAnimating = true;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    if (_currentIndex < widget.data.length) {
      Future.delayed(widget.speed, () {
        if (mounted && _isAnimating) {
          setState(() {
            _currentIndex++;
            _displayedText = widget.data.substring(0, _currentIndex);
          });
          _startAnimation();
        }
      });
    } else {
      _isCompleted = true;
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    }
  }

  void _skipAnimation() {
    if (!_isCompleted) {
      setState(() {
        _isAnimating = false;
        _displayedText = widget.data;
        _currentIndex = widget.data.length;
        _isCompleted = true;
      });
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    }
  }

  @override
  void dispose() {
    _isAnimating = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _skipAnimation,
      child: MarkdownBody(
        data: _displayedText,
        styleSheet: MarkdownStyleSheet(
          p: widget.textStyle,
          h1: widget.textStyle?.copyWith(
            fontSize: (widget.textStyle?.fontSize ?? 15) * 1.6,
            fontWeight: FontWeight.bold,
          ),
          h2: widget.textStyle?.copyWith(
            fontSize: (widget.textStyle?.fontSize ?? 15) * 1.4,
            fontWeight: FontWeight.bold,
          ),
          h3: widget.textStyle?.copyWith(
            fontSize: (widget.textStyle?.fontSize ?? 15) * 1.2,
            fontWeight: FontWeight.bold,
          ),
          code: widget.textStyle?.copyWith(
            backgroundColor: Colors.grey[800],
            fontFamily: 'monospace',
          ),
          codeblockDecoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          blockquote: widget.textStyle?.copyWith(
            fontStyle: FontStyle.italic,
          ),
          listBullet: widget.textStyle,
          strong: widget.textStyle?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          em: widget.textStyle?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
        selectable: true,
      ),
    );
  }
}

class StaticMarkdown extends StatelessWidget {
  final String data;
  final TextStyle? textStyle;

  const StaticMarkdown({
    super.key,
    required this.data,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      styleSheet: MarkdownStyleSheet(
        p: textStyle,
        h1: textStyle?.copyWith(
          fontSize: (textStyle?.fontSize ?? 15) * 1.6,
          fontWeight: FontWeight.bold,
        ),
        h2: textStyle?.copyWith(
          fontSize: (textStyle?.fontSize ?? 15) * 1.4,
          fontWeight: FontWeight.bold,
        ),
        h3: textStyle?.copyWith(
          fontSize: (textStyle?.fontSize ?? 15) * 1.2,
          fontWeight: FontWeight.bold,
        ),
        code: textStyle?.copyWith(
          backgroundColor: Colors.grey[800],
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        blockquote: textStyle?.copyWith(
          fontStyle: FontStyle.italic,
        ),
        listBullet: textStyle,
        strong: textStyle?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        em: textStyle?.copyWith(
          fontStyle: FontStyle.italic,
        ),
      ),
      selectable: true,
    );
  }
}
