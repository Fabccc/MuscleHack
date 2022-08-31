part of 'model.dart';

//ignore: must_be_immutable
class ExerciceAdd extends StatefulWidget {
  ExerciceAdd([this._exercice]) {
    _exercice ??= Exercice();
  }
  dynamic _exercice;
  @override
  State<StatefulWidget> createState() =>
      ExerciceAddState(_exercice as Exercice);
}

class ExerciceAddState extends State {
  ExerciceAddState(this.exercice);
  Exercice exercice;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtRest = TextEditingController();
  final TextEditingController txtSeries = TextEditingController();
  final TextEditingController txtReps = TextEditingController();
  final TextEditingController txtDay = TextEditingController();

  @override
  void initState() {
    txtName.text = exercice.name == null ? '' : exercice.name.toString();
    txtRest.text = exercice.rest == null ? '' : exercice.rest.toString();
    txtSeries.text = exercice.series == null ? '' : exercice.series.toString();
    txtReps.text = exercice.reps == null ? '' : exercice.reps.toString();
    txtDay.text = exercice.day == null ? '' : exercice.day.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UITools.mainBgColor,
        title: (exercice.id == null)
            ? Text("Ajout d'un nouvel exercice")
            : Text('Modifier un exercice'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    buildRowName(),
                    buildRowRest(),
                    buildRowSeries(),
                    buildRowReps(),
                    saveButton()
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowName() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Name';
        }
        return null;
      },
      controller: txtName,
      decoration: const InputDecoration(labelText: "Nom de l'Exercice"),
    );
  }

  Widget buildRowRest() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Temps de repos invalide';
        }
        int restTime = int.parse(value);
        if (restTime <= 0) {
          return 'Temps de repos invalide (<= 0)';
        }

        return null;
      },
      controller: txtRest,
      decoration: const InputDecoration(labelText: 'Temps de repos'),
    );
  }

  Widget buildRowSeries() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Nombre de series invalide';
        }
        int restTime = int.parse(value);
        if (restTime <= 0) {
          return 'Nombre de series invalide (<= 0)';
        }

        return null;
      },
      controller: txtSeries,
      decoration: const InputDecoration(labelText: 'Series'),
    );
  }

  Widget buildRowReps() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Nombre de reps invalide';
        }
        int restTime = int.parse(value);
        if (restTime <= 0) {
          return 'Nombre de reps invalide (<= 0)';
        }

        return null;
      },
      controller: txtReps,
      decoration: const InputDecoration(labelText: 'Reps'),
    );
  }

  Widget buildRowDay() {
    return TextFormField(
      validator: (value) {
        if (int.tryParse(value!) == null) {
          return 'Please Enter valid number (required)';
        }

        return null;
      },
      controller: txtDay,
      decoration: InputDecoration(labelText: 'Day'),
    );
  }

  Widget saveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          save();
        }
      },
      child: Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void save() async {
    exercice
      ..name = txtName.text
      ..rest = int.tryParse(txtRest.text)
      ..series = int.tryParse(txtSeries.text)
      ..reps = int.tryParse(txtReps.text)
      ..day = int.tryParse(txtDay.text);
    await exercice.save();
    if (exercice.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(exercice.saveResult.toString(),
          title: 'saving Failed!', callBack: () {});
    }
  }
}
