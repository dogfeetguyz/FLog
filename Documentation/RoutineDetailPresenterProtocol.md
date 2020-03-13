# RoutineDetailPresenterProtocol

Protocol that defines the commands sent from the View to the Presenter.
The Presenter is responsible for connecting the other objects inside a VIPER module.

``` swift
public protocol RoutineDetailPresenterProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`RoutineDetailPresenter`](RoutineDetailPresenter)

## Required Properties

## view

Reference to the View (weak to avoid retain cycle).

``` swift
var view: RoutineDetailViewProtocol?
```

## interactor

Reference to the Interactor's interface.

``` swift
var interactor: RoutineDetailInteractorInputProtocol?
```

## wireFrame

Reference to the Router.

``` swift
var wireFrame: RoutineDetailWireFrameProtocol?
```

## Required Methods

## viewDidLoad()

Should call after viewDidLoad called

``` swift
func viewDidLoad()
```

## loadLogs()

Should call when the contents of logs were updated

``` swift
func loadLogs()
```

## loadMaxInfo()

Should call when the more/less button for maxInfo clicked

``` swift
func loadMaxInfo()
```

## textfieldUpdated(tag:text:logDate:exerciseTitle:)

Should call when the textfield is updated

``` swift
func textfieldUpdated(tag: String, text: String, logDate: String, exerciseTitle: String)
```

  - parameter tag: A tag to indicate which textfield is updated

<!-- end list -->

  - parameter text: Updated text

<!-- end list -->

  - parameter logDate: The date of a log related to this update

<!-- end list -->

  - parameter exerciseTitle: The title of an exercise related to this update

## finishedInputData(logDate:)

Should call when typing on textfields is finished

``` swift
func finishedInputData(logDate: String)
```

  - parameter logDate: The date of a log related to this update

## newLogAction(date:)

Should call when a new log is created

``` swift
func newLogAction(date: Date)
```

  - parameter date: The date of a newly created log

## deleteLogAction(deleteIndex:)

Should call when a log is deleted

``` swift
func deleteLogAction(deleteIndex: Int)
```

  - parameter deleteIndex: The index of log to be deleted

## updateMaxInfo(exerciseTitle:)

Should call when the contents of logs were updated so that update max info

``` swift
func updateMaxInfo(exerciseTitle: String)
```

  - parameter exerciseTitle: The title of an exercise related to this update

## addSetAction(logDate:exerciseTitle:)

Should call when a new set is created

``` swift
func addSetAction(logDate: String, exerciseTitle: String)
```

  - parameter logDate: The date of a log related to this update

<!-- end list -->

  - parameter exerciseTitle: The title of an exercise related to this update

## removeSetAction(logDate:exerciseTitle:)

Should call when a set is deleted

``` swift
func removeSetAction(logDate: String, exerciseTitle: String)
```

  - parameter logDate: The date of a log related to this update

<!-- end list -->

  - parameter exerciseTitle: The title of an exercise related to this update
