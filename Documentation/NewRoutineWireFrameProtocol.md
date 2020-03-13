# NewRoutineWireFrameProtocol

Protocol that defines the possible routes from the Routine Module.
The Router is responsible for navigation between modules.

``` swift
public protocol NewRoutineWireFrameProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`NewRoutineWireFrame`](NewRoutineWireFrame)

## Required Methods

## createNewRoutineModule()

Creates New Routine Module

``` swift
static func createNewRoutineModule() -> UIViewController
```

## finishNewRoutineModule(from:)

Dismiss New Routine Module

``` swift
func finishNewRoutineModule(from view: NewRoutineViewProtocol)
```

  - parameter view: This view
