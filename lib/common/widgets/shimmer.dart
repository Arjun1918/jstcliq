// File: lib/common/widgets/shimmer_loading.dart
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? child;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(milliseconds: 100),
      color: Colors.grey.shade300,
      colorOpacity: 0.3,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: child ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
          ),
    );
  }
}

class DashboardShimmerLoading extends StatelessWidget {
  const DashboardShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerLoading(
            width: 120,
            height: 32,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 4),
          const ShimmerLoading(
            width: 200,
            height: 16,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ShimmerLoading(
                  height: 120,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ShimmerLoading(
                  height: 120,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Featured Services title shimmer
          const ShimmerLoading(
            width: 160,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 16),

          // Featured Services horizontal list shimmer
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  child: ShimmerLoading(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // Featured Products title shimmer
          const ShimmerLoading(
            width: 160,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 16),

          // Featured Products horizontal list shimmer
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  child: ShimmerLoading(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Generic shimmer widgets for different use cases
class CardShimmer extends StatelessWidget {
  final double? width;
  final double? height;

  const CardShimmer({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      width: width,
      height: height ?? 120,
      borderRadius: BorderRadius.circular(12),
    );
  }
}

class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const ShimmerLoading(
            width: 60,
            height: 60,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                ShimmerLoading(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Grid shimmer for product/service grids
class GridShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const GridShimmer({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const CardShimmer();
      },
    );
  }
}

// Search bar shimmer
class SearchBarShimmer extends StatelessWidget {
  final double? height;
  final double? borderRadius;

  const SearchBarShimmer({
    super.key,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      height: height ?? 48,
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
    );
  }
}

// Category grid shimmer specifically for services and products
class CategoryGridShimmer extends StatelessWidget {
  final int itemCount;
  final double childAspectRatio;

  const CategoryGridShimmer({
    super.key,
    this.itemCount = 6,
    this.childAspectRatio = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: childAspectRatio,
      children: List.generate(
        itemCount,
        (index) => ShimmerLoading(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}