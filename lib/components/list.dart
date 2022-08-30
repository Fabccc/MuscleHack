import 'package:flutter/widgets.dart';

typedef ListWidgetBuilder<R> = Widget Function(R element);
typedef IndexToObject<R> = R Function(int index);

class ListSelectView<E> extends StatelessWidget {
  final ListWidgetBuilder<E> widgetBuilder;
  final IndexToObject<E> indexToObject;
  final int itemCount;

  const ListSelectView(
      {Key? key,
      required this.indexToObject,
      required this.widgetBuilder,
      required this.itemCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return widgetBuilder(indexToObject(index));
        },
        itemCount: itemCount);
  }
}
