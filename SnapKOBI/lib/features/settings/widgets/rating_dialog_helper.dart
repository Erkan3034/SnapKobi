// 'Uygulamayı puanla' diyaloğunu açan yardımcı.
import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';

void showRatingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
      title: const Text('Uygulamayı Puanlayın'),
      content: const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Icon(Icons.star, color: Colors.amber, size: 36),
        Icon(Icons.star, color: Colors.amber, size: 36),
        Icon(Icons.star, color: Colors.amber, size: 36),
        Icon(Icons.star, color: Colors.amber, size: 36),
        Icon(Icons.star, color: Colors.amber, size: 36),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Puanınız için teşekkür ederiz! ⭐⭐⭐⭐⭐')),
            );
          },
          child: const Text('Gönder'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Puanınız için teşekkür ederiz! ⭐⭐⭐⭐⭐')),
            );
          },
          child: const Text('Puanla'),
        ),
      ],
    ),
  );
}
