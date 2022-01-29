import 'package:flutter/widgets.dart';

typedef ListWidgetBuilder<R> = Widget Function(R element);

class ListSelectView<E> extends StatefulWidget {
  final ListWidgetBuilder widgetBuilder;

  const ListSelectView({Key? key, required this.widgetBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListSelectViewState();
}

class _ListSelectViewState extends State<ListSelectView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return const Text("suuu");
        },
        itemCount: 5);
  }
}
