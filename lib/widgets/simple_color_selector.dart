import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SimpleColorSelector extends HookWidget {
  final List<MaterialColor> colors;
  final int selectedColor;
  final void Function(int) onChange;

  const SimpleColorSelector({
    Key? key,
    required this.colors,
    required this.selectedColor,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerKeys = useMemoized(
      () => [
        for (var i = 0; i < colors.length; i += 1) GlobalKey(),
      ],
    );

    final leftOffset = useState(0.0);
    final showAnimation = useState(false);

    void calcSelectedItemPosition() {
      if (containerKeys[selectedColor].currentContext == null) {
        return;
      }

      RenderBox box = containerKeys[selectedColor]
          .currentContext!
          .findRenderObject() as RenderBox;

      RenderBox firstBox =
          containerKeys[0].currentContext!.findRenderObject() as RenderBox;

      Offset firstBoxPosition = firstBox.localToGlobal(Offset.zero);

      Offset position = box.localToGlobal(Offset(
        -firstBoxPosition.dx,
        0,
      ));

      leftOffset.value = position.dx;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => calcSelectedItemPosition(),
    );

    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: showAnimation.value ? 150 : 0),
          left: leftOffset.value,
          curve: Curves.fastOutSlowIn,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              border: Border.all(color: colors[selectedColor], width: 3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < colors.length; i++)
              GestureDetector(
                onTap: () {
                  onChange(i);
                  showAnimation.value = true;
                },
                child: Container(
                  key: containerKeys[i],
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [colors[i].shade200, colors[i]],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: const [0, .7],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
