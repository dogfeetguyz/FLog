# NewRoutineInteractorInputProtocol

Protocol that defines the Interactor's use case.
The Interactor is responsible for implementing business logics of the module.

``` swift
public protocol NewRoutineInteractorInputProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`NewRoutineInteractor`](NewRoutineInteractor)

## Required Properties

## presenter

Reference to the Presenter's interface.

``` swift
var presenter: NewRoutineInteractorOutputProtocol?
```

## Required Methods

## createNewRoutine(title:unit:exerciseTitles:)

Create new routine

``` swift
func createNewRoutine(title: String?, unit: Unit, exerciseTitles: Array<String?>)
```

  - parameter title: Routine Title

<!-- end list -->

  - parameter unit: Unit used for this routine between kg and lb

<!-- end list -->

  - parameter exerciseTitles: An array of exercise titles for this routine
