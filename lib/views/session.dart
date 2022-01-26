import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musclatax/components/button.dart';
import 'package:musclatax/components/container.dart';
import 'package:musclatax/components/title.dart';
import 'package:musclatax/models/access.dart';
import 'package:musclatax/models/train.dart';

class SessionDisplay extends StatefulWidget {
  final Week week;
  final Session session;

  const SessionDisplay({Key? key, required this.week, required this.session})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SessionDisplayState();
}

class _SessionDisplayState extends State<SessionDisplay> {
  List<Segment> segments = [];

  @override
  void initState() {
    super.initState();
    _initAsyncState();
  }

  void _initAsyncState() async {
    var _segments = await _fetchData();
    segments = _segments;
  }

  Future<List<Segment>> _fetchData() async {
    return await DBAccess.getSegment(widget.session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0e0e0),
      body: DefaultContainer(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            text: widget.session.toString(),
            fontSize: 28,
          ),
          Flexible(
              child: ListView.separated(
                  itemBuilder: (context, int index) {
                    Segment extracted = segments[index];
                    return InkWell(
                      child: Segment.widget(widget.session, extracted),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        thickness: 1,
                      ),
                  itemCount: segments.length))
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 5,
        onPressed: () async {
          final value = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SegmentCreate(
                      session: widget.session, id: segments.length + 1)));
        },
      ),
    );
  }
}

class SegmentCreate extends StatelessWidget {
  final Session session;
  final int id;
  const SegmentCreate({Key? key, required this.session, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    createTab(SegmentType type) {
      const double topbottom = 17;
      return Container(
        margin: const EdgeInsets.only(top: topbottom, bottom: topbottom),
        child: NeumophirsmButton(
          content: type.name,
          colorDifference: 0.25,
          minWidth: 200,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SegmentCreateOptions(
                        session: session, id: id, type: type)));
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffe0e0e0),
      body: DefaultContainer(
        child: Column(
          children: [
            HeaderText(text: "Bloc $id"),
            StandarText(text: "Choix du type d'exercice"),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: SegmentType.values.map(createTab).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SegmentCreateOptions extends StatefulWidget {
  final Session session;
  final int id;
  final SegmentType type;
  const SegmentCreateOptions(
      {Key? key, required this.session, required this.id, required this.type})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SegmentCreateOptionsState();
}

class _SegmentCreateOptionsState extends State<SegmentCreateOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0e0e0),
      body: DefaultContainer(
        child: Column(
          children: [
            Flexible(
                child: StandarText(
              text: widget.type.desc,
            )),
          ],
        ),
      ),
    );
  }
}
