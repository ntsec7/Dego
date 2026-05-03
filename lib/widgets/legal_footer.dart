import 'package:flutter/material.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/models/politics_type.dart';
import 'package:dego/screens/politics.dart';

class LegalFooter extends StatelessWidget {
  const LegalFooter({super.key});

  Widget _link(BuildContext context, String text, PoliticsType type) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600;

    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Politics(type: type),
          ),
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: web
              ? (screenHeight + screenWidth) * 0.006
              : (screenHeight + screenWidth) * 0.01,
          color: Colors.blue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      children: [
        _link(context, context.lang.politica_priv, PoliticsType.p),
        const Text("•"),
        _link(context, context.lang.term_cond, PoliticsType.t),
        const Text("•"),
        _link(context, context.lang.aviso_legal, PoliticsType.a),
      ],
    );
  }
}