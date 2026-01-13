import 'package:flutter/material.dart';

class TopCarousel extends StatefulWidget {
  const TopCarousel({super.key});

  @override
  State<TopCarousel> createState() => _TopCarouselState();
}

class _TopCarouselState extends State<TopCarousel> {
  final List<Map<String, String>> items = [
    {
      "image": "https://images.unsplash.com/photo-1558002038-1055907df827",
      "title": "6 Tips Menghindari Bahaya Aliran Listrik Saat Banjir"
    },
    {
      "image": "https://images.unsplash.com/photo-1558002038-1055907df827",
      "title": "6 Tips Menghindari Bahaya Aliran Listrik Saat Banjir"
    },
    {
      "image": "https://images.unsplash.com/photo-1558002038-1055907df827",
      "title": "6 Tips Menghindari Bahaya Aliran Listrik Saat Banjir"
    },
  ];

  int currentIndex = 0;
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
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
                          item["image"]!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
                        item["title"]!,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
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
                    color: currentIndex == index ? Colors.white : Colors.white54,
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
