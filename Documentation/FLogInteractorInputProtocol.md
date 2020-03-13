# FLogInteractorInputProtocol

Protocol that defines the Interactor's use case.
The Interactor is responsible for implementing business logics of the module.

``` swift
public protocol FLogInteractorInputProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`FLogInteractorInput`](FLogInteractorInput)

## Required Properties

## presenter

Reference to the Presenter's interface.

``` swift
var presenter: FLogInteractorOutputProtocol?
```

## Required Methods

## createSampleData()

Create Sample Data for the first execution

``` swift
func createSampleData()
```

## dispatchRoutines()

Dispatches Routine from UserDefaults

``` swift
func dispatchRoutines()
```

## deleteRoutine(index:)

Deletes Routines from UserDefaults

``` swift
func deleteRoutine(index: Int)
```

  - parameter index: the index of routine to delete

## replaceRoutines(sourceIndex:destinationIndex:)

Replaces Routines from UserDefaults

``` swift
func replaceRoutines(sourceIndex: Int, destinationIndex: Int)
```

  - parameter sourceIndex: the index of routine to left

<!-- end list -->

  - parameter destinationIndex: the index of routine to go

## updateRoutineTitle(index:newTitle:)

Updates Routine Title from UserDefaults

``` swift
func updateRoutineTitle(index: Int, newTitle: String)
```

  - parameter index: the index of routine to modify

<!-- end list -->

  - parameter newTitle: newly typed title
