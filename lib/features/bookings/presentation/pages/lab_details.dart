import 'package:flutter/material.dart';

class LabReviewsPage extends StatefulWidget {
  const LabReviewsPage({super.key});

  @override
  State<LabReviewsPage> createState() => _LabReviewsPageState();
}

class _LabReviewsPageState extends State<LabReviewsPage> {
  static const Color primaryColor = Color(0xFF1769E8);
  static const Color textColor = Color(0xFF101438);
  static const Color starColor = Color(0xFFFFC107);
  static const Color backgroundColor = Color(0xFFFAFAFC);

  final List<LabReview> reviews = [
    LabReview(
      name: 'Sneha R.',
      rating: 5,
      date: '2 weeks ago',
      comment:
          'Very good service and friendly staff. Reports are provided on time.',
      avatarColor: Color(0xFF3995D8),
    ),
    LabReview(
      name: 'Arjun M.',
      rating: 4,
      date: '1 month ago',
      comment: 'Clean and well organized lab. Quick and accurate results.',
      avatarColor: Color(0xFF596272),
    ),
    LabReview(
      name: 'Reshma P.',
      rating: 3,
      date: '1 month ago',
      comment: 'Good experience. Staff are polite and helpful.',
      avatarColor: Color(0xFF8037D5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 22,
          ),
        ),
        title: const Text(
          'Atlas Labs & Scans',
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _buildLabInfoCard(),
            const SizedBox(height: 24),
            _buildReviewsHeader(),
            const SizedBox(height: 24),
            ...reviews.map(_buildReviewItem),
          ],
        ),
      ),
    );
  }

  Widget _buildLabInfoCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0F1F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Atlas Labs & Scans',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStars(4.5, size: 25),
              const Text(
                '4.5',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(120 reviews)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  fontWeight: .w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsHeader() {
    return Row(
      children: [
        Text(
          'Reviews (${reviews.length})',
          style: const TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(LabReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFECEEF2), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    _buildStars(review.rating.toDouble(), size: 22),
                    Text(
                      review.date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF858A99),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  review.comment,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF555B69),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars(double rating, {double size = 20}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final difference = rating - index;

        final IconData icon;

        if (difference >= 1) {
          icon = Icons.star_rounded;
        } else if (difference >= 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }

        return Icon(icon, color: starColor, size: size);
      }),
    );
  }

  void _showWriteReviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return WriteReviewSheet(
          onSubmit: (rating, comment) {
            setState(() {
              reviews.insert(
                0,
                LabReview(
                  name: 'You',
                  rating: rating,
                  date: 'Just now',
                  comment: comment,
                  avatarColor: primaryColor,
                ),
              );
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class LabReview {
  final String name;
  final int rating;
  final String date;
  final String comment;
  final Color avatarColor;

  const LabReview({
    required this.name,
    required this.rating,
    required this.date,
    required this.comment,
    required this.avatarColor,
  });
}

class WriteReviewSheet extends StatefulWidget {
  final void Function(int rating, String comment) onSubmit;

  const WriteReviewSheet({super.key, required this.onSubmit});

  @override
  State<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<WriteReviewSheet> {
  int selectedRating = 0;

  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Write a Review',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: _LabReviewsPageState.textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Share your experience with this lab.',
              style: TextStyle(fontSize: 15, color: Color(0xFF858A99)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Rating',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < selectedRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: const Color(0xFFFFC107),
                    size: 35,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commentController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Describe your experience...',
                alignLabelWithHint: true,
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  final comment = commentController.text.trim();

                  if (selectedRating == 0 || comment.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please select a rating and write a review.',
                        ),
                      ),
                    );
                    return;
                  }

                  widget.onSubmit(selectedRating, comment);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1769E8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Submit Review',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
