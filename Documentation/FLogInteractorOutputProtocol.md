# FLogInteractorOutputProtocol

Protocol that defines the commands sent from the Interactor to the Presenter.

``` swift
public protocol FLogInteractorOutputProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`FLogPresenter`](FLogPresenter)

## Required Methods

## didDispatchRoutines(with:)

Finished dispatching Routines from UserDefaults

``` swift
func didDispatchRoutines(with mainRoutineArray: [MainRoutineModel])
```

  - parameter mainRoutineModelArray: An array of MainRoutineModel loaded from UserDefaults

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
