# NewRoutineViewProtocol

Protocol that defines the view input methods.
The View is responsible for displaying Routine Screen.

``` swift
public protocol NewRoutineViewProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`NewRoutineView`](NewRoutineView)

## Required Properties

## presenter

Reference to the Presenter's interface.

``` swift
var presenter: NewRoutinePresenterProtocol?
```

## Required Methods

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
