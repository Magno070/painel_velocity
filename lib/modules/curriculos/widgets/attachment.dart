import 'package:flutter/material.dart';

class CampoAnexo extends StatelessWidget {
  const CampoAnexo({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    final imageHeight = (deviceHeight * 0.9).toInt();
    final imageWidth = (deviceWidth * 0.3).toInt();

    return Container(
      height: imageHeight.toDouble(),
      width: imageWidth.toDouble(),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        image: DecorationImage(
          image: NetworkImage(
            'https://picsum.photos/seed/6/$imageWidth/$imageHeight',
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

void showAttachmentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: CampoAnexo(),
    ),
  );
}
