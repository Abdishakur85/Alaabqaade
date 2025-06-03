import 'package:alaabqaade/constants/theme_data.dart';
import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  const Order({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Page')),
      body: Center(
        child: Text(
          'This is the Order Page',
          style: AppTextStyles.description.copyWith(
            fontSize: 18,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
