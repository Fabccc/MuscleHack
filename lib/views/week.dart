import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musclatax/models/access.dart';
import 'package:musclatax/models/train.dart';

class WeekDisplay extends StatefulWidget {
  final Week week;

  
  const WeekDisplay({Key? key, required this.week}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeekDisplayState();
}

class _WeekDisplayState extends State<WeekDisplay> {
  List<Session> sessions = [];

  @override
  void initState() {
    super.initState();
    _initAsyncState();
  }

  void _initAsyncState() async {
    var _sessions = await _fetchData();
    setState(() {
      sessions = _sessions;
    });
  }

  Future<List<Session>> _fetchData() async {
    return await DBAccess.getSessions(widget.week);
  }

  @override
  Widget build(BuildContext context) {
    List<Session> _sessions = sessions;

    return Scaffold(
        body: Row(
      children: [
        Text("Semaine n°${widget.week.id}: "),
        ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: _sessions.length,
          itemBuilder: (BuildContext context, int index) {
            Session extracted = _sessions[index];
            return InkWell(
              child: Session.widget(extracted),
              onTap: () => {
                // Launch the week view
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ],
    ));
  }
}