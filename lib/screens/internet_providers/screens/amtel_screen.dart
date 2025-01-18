// import 'package:baarazon_data/components/Banner/banner_m_style1.dart';
// import 'package:baarazon_data/constants.dart';
// // import 'package:baarazon_data/components/custom_button.dart';
// import 'package:baarazon_data/screens/internet_providers/screens/components/options_list_card.dart';
// import 'package:flutter/material.dart';

// class AmtelScreen extends StatelessWidget {
//   const AmtelScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Amtel'),
//         centerTitle: true,
//       ),
//       body: const SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(child: AmtelBanner()),
//             SliverToBoxAdapter(
//               child: SizedBox(
//                 height: 10,
//               ),
//             ),
//             SliverToBoxAdapter(
//                 child: DataOptions(
//               provider: InternetProviders.amtel,
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AmtelBanner extends StatelessWidget {
//   const AmtelBanner({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BannerMStyle1(
//       image:
//           'https://scontent.fbsa2-1.fna.fbcdn.net/v/t39.30808-6/246522289_360447669186899_8524213493584526319_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=a5f93a&_nc_ohc=6ra69e0qGlIQ7kNvgESQJTv&_nc_ht=scontent.fbsa2-1.fna&_nc_gid=AE-9fYNdRy_fWnRVDX7ehHf&oh=00_AYBW-bkpYfQjhuobKURPAcuLf7uBkdHbZrBDykUW71_70Q&oe=670B81CD', // Replace with Amtel's banner image URL
//       press: () {},
//       text: '',
//     );
//   }
// }
