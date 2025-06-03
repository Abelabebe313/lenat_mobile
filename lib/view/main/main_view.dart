import 'package:flutter/material.dart';
import 'package:lenat_mobile/view/consult/consult_page.dart';
import 'package:lenat_mobile/view/home/home_view.dart';
import 'package:lenat_mobile/view/market/market_view.dart';
import 'package:lenat_mobile/view/media/media_view.dart';
import 'package:lenat_mobile/view/profile/profile_screen.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:hugeicons/hugeicons.dart';
import 'main_viewmodel.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final List<Widget> _pages = const [
    HomeView(),
    MediaView(),
    ConsultView(),
    MarketView(),
    ProfilePage(),
  ];

  final List<IconData> _icons = [
    HugeIcons.strokeRoundedHome04,
    HugeIcons.strokeRoundedAlbum02,
    HugeIcons.strokeRoundedStethoscope02,
    HugeIcons.strokeRoundedStore01,
    HugeIcons.strokeRoundedUserSquare,
  ];

  List<String> _getLabels(bool isAmharic) {
    return isAmharic
        ? [
            "ዋና ገፅ",
            "ሚዲያ",
            "ኮንሰልት",
            "ገበያ",
            "ፕሮፋይል",
          ]
        : [
            "Home",
            "Media",
            "Consult",
            "Market",
            "Profile",
          ];
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MainViewModel>(context);
    final viewModel = Provider.of<ProfileViewModel>(context);
    final labels = _getLabels(viewModel.isAmharic);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              final isSelected = vm.selectedIndex == index;
              return GestureDetector(
                onTap: () => vm.updateIndex(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: const Color(0xFFEAF2FB),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: _icons[index],
                        color: isSelected ? Colors.blue : Colors.black,
                        size: 24.0,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        Text(
                          labels[index],
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'NotoSansEthiopic',
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: IndexedStack(
        index: vm.selectedIndex,
        children: _pages,
      ),
    );
  }
}
