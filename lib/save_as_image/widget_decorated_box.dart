import 'package:flutter/material.dart';
import 'package:flutter_practice/save_as_image/image_capture_helper.dart';
import 'package:flutter_practice/shared/utils/helpers.dart';
import 'package:flutter_practice/shared/widgets/custom_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final boxWidgetKey = GlobalKey();

class WidgetDecoratedBox extends StatelessWidget {
  const WidgetDecoratedBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // This widget represent the widget we want to extract and save it as image.
        SizedBox(
          height: 320,
          child: buildContentColumn(theme, key: boxWidgetKey),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: "Save As Image",
          onTap: () async {
            // here we are implementing capturing the widget as image and saving it locally
            final pngBytes =
                await ImageCaptureHelper.captureAsPng(boxWidgetKey);
            if (pngBytes == null) {
              displaySnackBar(context, hasError: true, "Failed to save image");
              return;
            }
            await ImageCaptureHelper.saveImageLocally(pngBytes).then((value) {
              displaySnackBar(context, "Image saved successfully");
            }, onError: (e) {
              displaySnackBar(context, hasError: true, e.toString());
            });
          },
        ),
      ],
    );
  }

  Widget buildContentColumn(ThemeData theme, {required GlobalKey key}) {
    return RepaintBoundary(
      key: boxWidgetKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: customizedDecorationBox(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Icon(FontAwesomeIcons.quoteLeft, color: Colors.white),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '''Knowledge is the source of wealth. Applied to tasks we already know, it becomes productivity. Applied to tasks that are new, it becomes innovation
                     ''',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 12,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      color: Colors.black87,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          "Peter Drucker",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(FontAwesomeIcons.quoteRight,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration customizedDecorationBox() {
    return const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      gradient: LinearGradient(
        colors: [Colors.blueAccent, Colors.pink],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 1.0], // Optional, controls the distribution of colors
      ),
    );
  }
}
