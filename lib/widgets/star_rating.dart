import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StarRating extends StatefulWidget {
  final int rating;
  final bool interactive;
  final double size;
  final ValueChanged<int>? onChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.interactive = false,
    this.size = 20,
    this.onChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < _current;
        return GestureDetector(
          onTap: widget.interactive
              ? () {
                  setState(() => _current = i + 1);
                  widget.onChanged?.call(i + 1);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: filled ? AppColors.starGold : AppColors.captionText,
              size: widget.size,
            ),
          ),
        );
      }),
    );
  }
}

// Static display-only star row with decimal support (e.g., 4.5 stars)
class StarDisplay extends StatelessWidget {
  final double rating;
  final double size;

  const StarDisplay({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(Icons.star_rounded, color: AppColors.starGold, size: size);
        } else if (i == rating.floor() && rating % 1 >= 0.5) {
          return Icon(Icons.star_half_rounded, color: AppColors.starGold, size: size);
        } else {
          return Icon(Icons.star_outline_rounded, color: AppColors.captionText, size: size);
        }
      }),
    );
  }
}
