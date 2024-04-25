import 'package:buyer_seller_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class LoadingAlerDialog extends StatelessWidget {
  final String message;
  const LoadingAlerDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circlularProgress(),
          const SizedBox(height: 10),
          const Text('Please wait...'),
        ],
      ),
    );
  }
}
