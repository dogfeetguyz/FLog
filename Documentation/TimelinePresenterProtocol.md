# TimelinePresenterProtocol

Protocol that defines the commands sent from the View to the Presenter.
The Presenter is responsible for connecting the other objects inside a VIPER module.

``` swift
public protocol TimelinePresenterProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`TimelinePresenter`](TimelinePresenter)

## Required Properties

## view

Reference to the View (weak to avoid retain cycle).

``` swift
var view: TimelineViewProtocol?
```

## interactor

Reference to the Interactor's interface.

``` swift
var interactor: TimelineInteractorInputProtocol?
```

## wireFrame

Reference to the Router.

``` swift
var wireFrame: TimelineWireFrameProtocol?
```

## Required Methods

## viewDidLoad()

Should call after viewDidLoad is called

``` swift
func viewDidLoad()
```
