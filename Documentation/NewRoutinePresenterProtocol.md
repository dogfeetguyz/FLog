# NewRoutinePresenterProtocol

Protocol that defines the commands sent from the View to the Presenter.
The Presenter is responsible for connecting the other objects inside a VIPER module.

``` swift
public protocol NewRoutinePresenterProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`NewRoutinePresenter`](NewRoutinePresenter)

## Required Properties

## view

Reference to the View (weak to avoid retain cycle).

``` swift
var view: NewRoutineViewProtocol?
```

## interactor

Reference to the Interactor's interface.

``` swift
var interactor: NewRoutineInteractorInputProtocol?
```

## wireFrame

Reference to the Router.

``` swift
var wireFrame: NewRoutineWireFrameProtocol?
```

## Required Methods

## viewDidLoad()

Should call after viewDidLoad called

``` swift
func viewDidLoad()
```

## clickCreateButton(title:unit:exerciseTitles:)

Should call when 'Create Button' clicked

``` swift
func clickCreateButton(title: String?, unit: Unit, exerciseTitles: Array<String?>)
```

  - parameter title: Routine Title

<!-- end list -->

  - parameter unit: Unit used for this routine between kg and lb

<!-- end list -->

  - parameter exerciseTitles: An array of exercise titles for this routine
