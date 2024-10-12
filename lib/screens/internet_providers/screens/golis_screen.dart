import 'package:baarazon_data/components/Banner/banner_m_style1.dart';
import 'package:baarazon_data/constants.dart';
import 'package:flutter/material.dart';
import 'components/options_list_card.dart';

class GolisScreen extends StatelessWidget {
  const GolisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Golis'),
        centerTitle: true,
      ),
      body: const SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: GolisBanner()),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
              child: DataOptions(
            provider: InternetProviders.golis,
          ))
        ],
      )),
    );
  }
}

class GolisBanner extends StatelessWidget {
  const GolisBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BannerMStyle1(
      image:
          'https://media-exp1.licdn.com/dms/image/C4D1BAQH1Ob--LPxirg/company-background_10000/0/1631084960976?e=2147483647&v=beta&t=OH2DmKPKc2-b1qjUQSEOqWnp3hCZPM6DRBVb_NuL9zU',
      press: () {},
      text: '',
    );
  }
}
