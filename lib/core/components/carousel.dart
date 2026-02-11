import 'package:flutter/material.dart';
import 'package:zapp/features/models/news.dart';
import 'package:zapp/features/services/news_service.dart';

class TopCarousel extends StatefulWidget {
  const TopCarousel({super.key});

  @override
  State<TopCarousel> createState() => _TopCarouselState();
}

class _TopCarouselState extends State<TopCarousel> {
  List<News> items = [];
  int currentIndex = 0;
  final PageController controller = PageController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final result = await NewsService.fetchNews();

      if (!mounted) return;

      setState(() {
        items = result.take(3).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetch news: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ================= LOADING VERSION =================
    if (isLoading) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 160,
          width: double.infinity,
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Text(
            "Loading news...",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    // ================= EMPTY VERSION =================
    if (items.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 160,
          width: double.infinity,
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Text(
            "No news available",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    // ================= NORMAL UI (TIDAK DIUBAH) =================
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: controller,
              itemCount: items.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                final item = items[index];

                return Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          item.imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 160,
                              width: double.infinity,
                              color: Colors.grey,
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                        Container(
                          height: 160,
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.45),
                        ),
                      ],
                    ),
                    Container(
                      height: 70,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            right: 12,
            child: Row(
              children: List.generate(items.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: currentIndex == index ? 10 : 6,
                  height: currentIndex == index ? 10 : 6,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.white
                        : Colors.white54,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
