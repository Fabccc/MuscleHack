# Diagramme UML de l'application


## Diagramme cas d'utilisation
```plantuml
@startuml
skinparam backgroundColor #EEEBDC
skinparam roundcorner 10
skinparam usecase {
BorderColor #4A8CFC
}
left to right direction
actor Utilisateur as s
package FTP{
  usecase "Créer une séance" as UC1
  usecase "Afficher ses anciennes séances" as UC2
  usecase "Statistiques sur ses séances " as UC3
}
s --> UC1
s --> UC2
s --> UC3
@enduml
```


## Diagramme de classe
```plantuml
@startuml
skinparam backgroundColor #EEEBDC
skinparam roundcorner 10
skinparam class {
BorderColor #4A8CFC
}

package "Diagramme de classe" {

  class Session{
    + segments : Map<String, Segment>
  }

  class Week{
    + sessions : Map<Seance, boolean>
  }

  enum SegmentType{
    AMRAP
    FORTIME
    EMOM
    TABATA
    REST
  }

  class Segment{
    + duration : int
    + type : SegmentType
    + exercices : Map<Integer, ExerciceData>
  }

  class ExerciceData{
    + weightTotal : int
    + weightX2 : boolean
    + repetition : int
    + eachSide : boolean
  }

' Notes

  note left of Segment::duration
    Temps en secondes
  end note

  note left of ExerciceData::weightTotal
    Poids en kilo de l'haltère
  end note

  note right of ExerciceData::weightX2
    Dit si on affiche "2x poids" au lieu de "poids"
    Ex: 
    si weightTotal = 14 et weightX2
    On aura "2x 14kg" sinon "14kg"
  end note

  note left of ExerciceData::eachSide
    Si on fait les deux cotés en même temps
    ou si on fait, par exemple, 3 reps / coté
  end note

  note left of Session::segments
    La liste des blocs de la séance
    Ex: "Bloc 1", "Bloc 2"...
  end note

  note left of Week::sessions
    Une semaine complète raptor daily
    Ex: "Lundi", "Mardi"...
  end note

' Lien entre classes

  Segment::type --> SegmentType
  Segment::exercices *-- ExerciceData
  Session::segments *-- Segment
  Week::sessions *-- Session
}

@enduml
```
