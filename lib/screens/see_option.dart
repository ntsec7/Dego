import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/cupertino.dart';

class SeeOption extends ConsumerStatefulWidget {
  final String id;

  const SeeOption({super.key, required this.id});

  @override
  ConsumerState<SeeOption> createState() => _SeeOption();
}

class _SeeOption extends ConsumerState<SeeOption> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool web = screenWidth > 600 ? true : false;

    final optionAsync = ref.watch(optionByIdProvider(widget.id));

    if (optionAsync.isLoading) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator(radius: 15)));
    }

    final option = optionAsync.requireValue;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // FILA SUPERIOR: FLECHA VOLVER ATRÁS + TÍTULO DE LA OPCIÓN
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: web ? screenHeight * 0.02 : screenHeight * 0.015,
                horizontal: web ? screenWidth * 0.14 : screenWidth * 0.03,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  Expanded(
                    child: Text(
                      option.title,
                      style: TextStyle(
                        fontSize: web ? (screenHeight + screenWidth) * 0.014 : (screenHeight + screenWidth) * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.02),

                        // IMAGEN
                        if (option.image != null && option.image!.isNotEmpty) ...[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.1),
                              //     blurRadius: 8,
                              //     offset: const Offset(0, 4),
                              //   )
                              // ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                option.image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: web ? screenHeight * 0.4 : screenHeight * 0.3,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: web ? screenHeight * 0.4 : screenHeight * 0.3,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.broken_image,
                                    size: web ? screenWidth * 0.05 : screenWidth * 0.15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                        ],

                        // DESCRIPCIÓN
                        if (option.description != null && option.description!.isNotEmpty)
                          Text(
                            option.description!,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.0135,
                              // color: Theme.of(context).textTheme.bodyMedium?.color,
                              // height: 1.4,
                              // fontFamily: 'Arial',
                            ),
                          ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}