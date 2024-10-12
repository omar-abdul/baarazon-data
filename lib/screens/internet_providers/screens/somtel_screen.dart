import 'package:baarazon_data/components/Banner/banner_m_style1.dart';
import 'package:baarazon_data/constants.dart';
import 'package:flutter/material.dart';
import 'components/options_list_card.dart';

class SomtelScreen extends StatelessWidget {
  const SomtelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Somtel'),
        centerTitle: true,
      ),
      body: const SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SomtelBanner()),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
              child: DataOptions(
            provider: InternetProviders.somtel,
          ))
        ],
      )),
    );
  }
}

class SomtelBanner extends StatelessWidget {
  const SomtelBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BannerMStyle1(
      image:
          'https://media-exp1.licdn.com/dms/image/C4D1BAQGCBEqsfs0ESw/company-background_10000/0/1625908078920?e=2147483647&v=beta&t=aazI6Qozdgj4RYcQKwZcFGRmoP2LHfohWzvDoceV3KU',
      press: () {},
      text: '',
    );
  }
}
