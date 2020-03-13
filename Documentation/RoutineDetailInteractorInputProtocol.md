# RoutineDetailInteractorInputProtocol

Protocol that defines the Interactor's use case.
The Interactor is responsible for implementing business logics of the module.

``` swift
public protocol RoutineDetailInteractorInputProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`RoutineDetailInteractor`](RoutineDetailInteractor)

## Required Properties

## presenter

Reference to the Presenter's interface.

``` swift
var presenter: RoutineDetailInteractorOutputProtocol?
```

## Required Methods

## loadLogs(routine:)

Loads logs from UserDefaults

``` swift
func loadLogs(routine: MainRoutineModel)
```

  - parameter routine: Routine Data to load the detail data

## loadMaxInfo(routineTitle:)

Loads max info from UserDefaults

``` swift
func loadMaxInfo(routineTitle: String)
```

  - parameter routineTitle: The routine title related to this loading

## checkNewMaxInfo(routineTitle:logDate:)

Checks if max info needs updating

``` swift
func checkNewMaxInfo(routineTitle: String, logDate: String)
```

  - parameter routineTitle: The routine title related to this checking

<!-- end list -->

  - parameter logDate: The date of a log to check the targeted max info

## createNewFitnessLog(date:routine:)

Creates new routine

``` swift
func createNewFitnessLog(date: Date, routine: MainRoutineModel)
```

  - parameter date: The date of a newly created log

<!-- end list -->

  - parameter routine: Routine Data for this routine

## deleteFitnessLog(deleteIndex:routine:)

Deletes the targeted log

``` swift
func deleteFitnessLog(deleteIndex: Int, routine: MainRoutineModel)
```

  - parameter deleteIndex: The index of log to be deleted

<!-- end list -->

  - parameter routine: Routine Data for this routine

## refindMaxValue(routineTitle:exerciseTitle:)

Refinds the max info when it is needed

``` swift
func refindMaxValue(routineTitle: String, exerciseTitle: String)
```

  - parameter routineTitle: The routine title related to this refinding

<!-- end list -->

  - parameter exerciseTitle: The title of an exercise  to look up the max info

## createNewSet(routineDetail:logDate:exerciseTitle:)

Creates a new set for the exercise on the log

``` swift
func createNewSet(routineDetail: RoutineDetailModel, logDate: String, exerciseTitle: String)
```

  - parameter routineDetail:Routine detail data related to this update

<!-- end list -->

  - parameter logDate: The date of a log related to this update

<!-- end list -->

  - parameter exerciseTitle: The title of an exercise related to this update

## removeSet(routineDetail:logDate:exerciseTitle:)

Removes a targeted set

``` swift
func removeSet(routineDetail: RoutineDetailModel, logDate: String, exerciseTitle: String)
```

  - parameter routineDetail: Routine detail data related to this update

<!-- end list -->

  - parameter logDate: The date of a log related to this update

<!-- end list -->

  - parameter exerciseTitle: The title of an exercise related to this update

## updateSet(routineDetail:tag:text:logDate:exerciseTitle:)

Updates the content of a set

``` swift
func updateSet(routineDetail: RoutineDetailModel, tag: String, text: String, logDate: String, exerciseTitle: String)
```

  - parameter routineDetail: Routine detail data related to this update

<!-- end list -->

  - parameter tag: A tag to indicate which textfield is updated

<!-- end list -->

  - parameter text: Updated text

<!-- end list -->

  - parameter logDate: The date of a log related to this update

<!-- end list -->

  - parameter exerciseTitle: The title of an exercise related to this update
