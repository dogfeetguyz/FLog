# FLogPresenterProtocol

Protocol that defines the commands sent from the View to the Presenter.
The Presenter is responsible for connecting the other objects inside a VIPER module.

``` swift
public protocol FLogPresenterProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`FLogPresenter`](FLogPresenter)

## Required Properties

## view

Reference to the View (weak to avoid retain cycle).

``` swift
var view: FLogViewProtocol?
```

## interactor

Reference to the Interactor's interface.

``` swift
var interactor: FLogInteractorInputProtocol?
```

## wireFrame

Reference to the Router.

``` swift
var wireFrame: FLogWireFrameProtocol?
```

## Required Methods

## viewDidLoad()

Should call after viewDidLoad is called

``` swift
func viewDidLoad()
```

## updateView()

Should call after viewWillAppear is called

``` swift
func updateView()
```

## deleteCell(index:)

Should call after a cell is deleted

``` swift
func deleteCell(index: Int)
```

  - parameter index: the index of routine to delete

## moveCell(sourceIndex:destinationIndex:)

Should call after a cell is moved

``` swift
func moveCell(sourceIndex: Int, destinationIndex: Int)
```

  - parameter sourceIndex: the index of routine to left

<!-- end list -->

  - parameter destinationIndex: the index of routine to go

## modifyCellTitle(index:newTitle:)

Should call when the title of a cell is requested to modify

``` swift
func modifyCellTitle(index: Int, newTitle: String)
```

  - parameter index: the index of routine to modify

<!-- end list -->

  - parameter newTitle: newly typed title

## clickRoutineCell(forRoutine:)

Should call when a cell is clicked

``` swift
func clickRoutineCell(forRoutine routine: MainRoutineModel)
```

  - parameter routine: Routine clicked

## clickNewButton()

Should call when 'New Button' is cllicked

``` swift
func clickNewButton()
```
