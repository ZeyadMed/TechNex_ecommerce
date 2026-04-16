import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  final double initialRating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final Function(double) onRatingChanged;
  final bool showRatingText;
  final TextStyle? ratingTextStyle;
  final int maxRating;
  final double spacing;
  final double precision;
  // Optional callback when the user completes the gesture
  final Function(double)? onRatingSubmitted;

  const StarRatingWidget({
    super.key,
    this.initialRating = 1.0,
    this.size = 40.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    required this.onRatingChanged,
    this.showRatingText = true,
    this.ratingTextStyle,
    this.maxRating = 5,
    this.spacing = 0.0,
    this.precision = 1.0, // Use integer steps (1..maxRating)
    this.onRatingSubmitted,
  }) : assert(
  initialRating >= 1 && initialRating <= maxRating,
  'Rating must be between 1 and maxRating',
  );

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  // _rating stores the final (submitted) rating.
  late double _rating;
  // _dragRating is used to show live feedback during dragging.
  double? _dragRating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  // Calculate the rating based on the horizontal position and text direction.
  double _calculateRating(double dx, TextDirection textDirection) {
    final totalWidth = widget.maxRating * widget.size +
        (widget.maxRating - 1) * widget.spacing;

    // If in RTL, invert the coordinate.
    final adjustedDx =
    textDirection == TextDirection.rtl ? totalWidth - dx : dx;

    double rawRating = adjustedDx / (widget.size + widget.spacing);
    // Clamp to allowable range then round to nearest integer step.
    rawRating = rawRating.clamp(0.0, widget.maxRating.toDouble());
    int intRating = rawRating.round();
    // Ensure minimum rating is 1 (user requested 1..max without decimals)
    intRating = intRating.clamp(1, widget.maxRating);
    return intRating.toDouble();
  }

  void _handleDragStart(DragStartDetails details, TextDirection textDirection) {
    final newRating = _calculateRating(details.localPosition.dx, textDirection);
    setState(() {
      _dragRating = newRating;
    });
    widget.onRatingChanged(newRating);
  }

  void _handleDragUpdate(DragUpdateDetails details, TextDirection textDirection) {
    final newRating = _calculateRating(details.localPosition.dx, textDirection);
    if (_dragRating != newRating) {
      setState(() {
        _dragRating = newRating;
      });
      widget.onRatingChanged(newRating);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    // Finalize rating from the live drag state.
    final finalRating = _dragRating ?? _rating;
    setState(() {
      _rating = finalRating;
      _dragRating = null;
    });
    widget.onRatingChanged(_rating);
    if (widget.onRatingSubmitted != null) {
      widget.onRatingSubmitted!(_rating);
    }
  }

  // For tap gestures, update the rating immediately.
  void _handleTapDown(TapDownDetails details, TextDirection textDirection) {
    final newRating = _calculateRating(details.localPosition.dx, textDirection);
    setState(() {
      _rating = newRating;
    });
    widget.onRatingChanged(newRating);
    if (widget.onRatingSubmitted != null) {
      widget.onRatingSubmitted!(newRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the current text direction from the context.
    final textDirection = Directionality.of(context);
    // Use live _dragRating if available, otherwise use the submitted _rating.
    final displayRating = (_dragRating ?? _rating).roundToDouble();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Star icons based on current rating
        GestureDetector(
          onPanStart: (details) => _handleDragStart(details, textDirection),
          onPanUpdate: (details) => _handleDragUpdate(details, textDirection),
          onPanEnd: _handleDragEnd,
          onTapDown: (details) => _handleTapDown(details, textDirection),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.maxRating, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
                    child: _buildStar(index, displayRating),
                  );
                }),
              );
            },
          ),
        ),
        if (widget.showRatingText) ...[
          const SizedBox(width: 8),
          Text(
            displayRating.toStringAsFixed(0),
            style: widget.ratingTextStyle ??
                TextStyle(
                  fontSize: widget.size * 0.6,
                  fontWeight: FontWeight.bold,
                  color: widget.activeColor,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildStar(int index, double displayRating) {
    final int ratingInt = displayRating.round();
    final bool filled = index < ratingInt;
    return Icon(
      filled ? Icons.star : Icons.star_border,
      color: filled ? widget.activeColor : widget.inactiveColor,
      size: widget.size,
    );
  }
}
