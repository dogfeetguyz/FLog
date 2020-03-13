# RoutineDetailViewProtocol

Protocol that defines the view input methods.
The View is responsible for displaying Routine Screen.

``` swift
public protocol RoutineDetailViewProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`RoutineDetailView`](RoutineDetailView)

## Required Properties

## presenter

Reference to the Presenter's interface.

``` swift
var presenter: RoutineDetailPresenterProtocol?
```

## routineDetailData

Routine Detail Data for the detail screen

``` swift
var routineDetailData: RoutineDetailModel?
```

## Required Methods

## showRoutineDetail(routineDetail:)

Shows routine detail with logs for this routine

``` swift
func showRoutineDetail(routineDetail: RoutineDetailModel)
```

  - parameter routineDetail: Routine detail data to draw the screen

## showCreateDialog(isFirst:)

Shows a dialog to create new log

``` swift
func showCreateDialog(isFirst: Bool)
```

  - parameter isFirst: Indicates whetere is the first log or not

## updateLogView(segmentIndex:)

Updates the targeted log

``` swift
func updateLogView(segmentIndex: Int)
```

  - parameter segmentIndex: Current segment index after create or delete

## updateMaxInfoView(maxInfo:)

Update max info view

``` swift
func updateMaxInfoView(maxInfo: Dictionary<String, Dictionary<String, String>>)
```

  - parameter maxInfo: Updated max info

## updateTableView(routineDetail:)

Update TableView

``` swift
func updateTableView(routineDetail: RoutineDetailModel)
```

  - parameter routineDetail: Updated routine detail data

## showError(title:message:buttonTitle:handler:)

Shows error message on the view

``` swift
func showError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?)
```

  - parameter title: title for the alert

<!-- end list -->

  - parameter message: message for the alert

<!-- end list -->

  - parameter buttonTitle: OK Button title for the alert

<!-- end list -->

  - parameter handler: OK Button action for the alert
