import 'package:ess/enums/skeleton_loading_enum.dart';
import 'package:flutter/material.dart';
import 'package:fade_shimmer/fade_shimmer.dart';

class SkeletonLoading extends StatelessWidget {
  final SkeletonType type;
  final int count;
  final double? height;
  final double? width;

  const SkeletonLoading({
    super.key,
    required this.type,
    this.count = 3,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
            (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSkeletonItem(),
        ),
      ),
    );
  }

  Widget _buildSkeletonItem() {
    switch (type) {
      case SkeletonType.card:
        return _buildCardSkeleton();
      case SkeletonType.list:
        return _buildListSkeleton();
      case SkeletonType.text:
        return _buildTextSkeleton();
      case SkeletonType.circle:
        return _buildCircleSkeleton();
      case SkeletonType.rectangle:
        return _buildRectangleSkeleton();
    }
  }

  Widget _buildCardSkeleton() {
    return FadeShimmer(
      height: height ?? 120,
      width: width ?? double.infinity,
      radius: 12,
      highlightColor: Colors.grey[100]!,
      baseColor: Colors.grey[300]!,
    );
  }

  Widget _buildListSkeleton() {
    return Row(
      children: [
        FadeShimmer(
          height: 60,
          width: 60,
          radius: 8,
          highlightColor: Colors.grey[100]!,
          baseColor: Colors.grey[300]!,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeShimmer(
                height: 16,
                width: double.infinity,
                radius: 4,
                highlightColor: Colors.grey[100]!,
                baseColor: Colors.grey[300]!,
              ),
              const SizedBox(height: 8),
              FadeShimmer(
                height: 14,
                width: 150,
                radius: 4,
                highlightColor: Colors.grey[100]!,
                baseColor: Colors.grey[300]!,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextSkeleton() {
    return FadeShimmer(
      height: height ?? 16,
      width: width ?? double.infinity,
      radius: 4,
      highlightColor: Colors.grey[100]!,
      baseColor: Colors.grey[300]!,
    );
  }

  Widget _buildCircleSkeleton() {
    return FadeShimmer.round(
      size: height ?? 60,
      highlightColor: Colors.grey[100]!,
      baseColor: Colors.grey[300]!,
    );
  }

  Widget _buildRectangleSkeleton() {
    return FadeShimmer(
      height: height ?? 100,
      width: width ?? double.infinity,
      radius: 8,
      highlightColor: Colors.grey[100]!,
      baseColor: Colors.grey[300]!,
    );
  }
}