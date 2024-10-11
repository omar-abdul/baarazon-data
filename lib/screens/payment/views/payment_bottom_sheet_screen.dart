import 'package:animations/animations.dart';
import 'package:baarazon_data/models/payment_options/payment_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubit/payment_and_data_option_cubit.dart';
import '../components/payment_complete.dart';
import '../components/payment_select.dart';
import 'package:flutter/material.dart';

import '../../../models/data_options/option_export.dart';

class PaymentBottomSheet extends StatelessWidget {
  const PaymentBottomSheet({super.key, required this.option});
  final Option option;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentAndDataOptionCubit(),
      child: BlocBuilder<PaymentAndDataOptionCubit, PaymentAndDataOptionState>(
        builder: (context, state) {
          final List<Widget> paymentPages = [
            PaymentScreen(option: option, onSelectPayment: onSelectPayment),
            if (state is NewPaymentAndDataState)
              PaymentComplete(
                  option: state.selectedOption!, entry: state.paymentOption!),
          ];

          // return paymentPages[state.currentIndex];
          return PageTransitionSwitcher(
            transitionBuilder: (child, animation, secondaryAnimation) =>
                SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            ),
            child: paymentPages[state.currentIndex],
          );
        },
      ),
    );
  }

  void onSelectPayment(Option option,
      MapEntry<PaymentOptions, PaymentOption> entry, BuildContext context) {
    context.read<PaymentAndDataOptionCubit>().onSelectPayment(option, entry);
  }
}
