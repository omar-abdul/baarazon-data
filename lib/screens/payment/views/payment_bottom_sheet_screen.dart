import 'package:animations/animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../models/services.dart';
import '../bloc/cubit/payment_and_data_option_cubit.dart';
import '../components/payment_complete.dart';
import '../components/payment_select.dart';

class PaymentBottomSheet extends StatelessWidget {
  const PaymentBottomSheet({super.key, required this.service});
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentAndDataOptionCubit(),
      child: BlocBuilder<PaymentAndDataOptionCubit, PaymentAndDataOptionState>(
        builder: (context, state) {
          final List<Widget> paymentPages = [
            PaymentScreen(
              service: service,
              onSelectPayment: (entry, context) {
                context
                    .read<PaymentAndDataOptionCubit>()
                    .onSelectPayment(entry);
              },
            ),
            if (state is NewPaymentAndDataState)
              PaymentComplete(
                service: service,
                entry: state.paymentOption!,
              ),
          ];

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
}
