import 'package:flutter/material.dart';
import 'package:dego/utilities/lang.dart';

class LegalFooter extends StatelessWidget {
  const LegalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      children: [
        _link(context, context.lang.politica_priv, 'register'),
        const Text("•"),
        _link(context, context.lang.term_cond, 'register'),
        const Text("•"),
        _link(context, context.lang.polit_cookies, 'register'),
        const Text("•"),
        _link(context, context.lang.aviso_legal, 'register'),
      ],
    );
  }

  Widget _link(BuildContext context, String text, String route) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.blue,
        ),
      ),
    );
  }
}