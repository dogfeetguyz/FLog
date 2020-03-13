# RoutineDetailInteractorOutputProtocol

Protocol that defines the commands sent from the Interactor to the Presenter.

``` swift
public protocol RoutineDetailInteractorOutputProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`RoutineDetailPresenter`](RoutineDetailPresenter)

## Required Methods

## needsFirstLog()

Notifies this routine doesn't contain any logs, so it needs the first log

``` swift
func needsFirstLog()
```

## didLogLoaded(routineDetail:)

Finished load logs

``` swift
func didLogLoaded(routineDetail: RoutineDetailModel)
```

  - parameter routineDetail: Routine detail data to draw the screen

## didUpdateLog(routineDetail:)

Finished updating the log

``` swift
func didUpdateLog(routineDetail: RoutineDetailModel)
```

  - parameter routineDetail: Routine detail data to update the screen

## didMaxInfoLoaded(maxInfo:)

Finished load max info

``` swift
func didMaxInfoLoaded(maxInfo: Dictionary<String, Dictionary<String, String>>)
```

  - parameter maxInfo: The information of max data

## didCreateNewFitnessLog()

finished creating new log

``` swift
func didCreateNewFitnessLog()
```

## didDeleteFitnessLog(deletedIndex:)

finished deleteing the targeted log

``` swift
func didDeleteFitnessLog(deletedIndex: Int)
```

  - parameter deletedIndex: The index deleted

## onError(title:message:buttonTitle:handler:)

Handles error occurred during dispatching Account Detail

``` swift
func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?)
```

  - parameter title: title for the alert

<!-- end list -->

  - parameter message: message for the alert

<!-- end list -->

  - parameter buttonTitle: OK Button title for the alert

<!-- end list -->

  - parameter handler: OK Button action for the alert
