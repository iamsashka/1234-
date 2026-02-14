import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_constants.dart';

class LoadingWidget extends StatelessWidget {
  final String message;
  
  const LoadingWidget({super.key, this.message = 'Загрузка...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppConstants.loadingAnimation,
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}