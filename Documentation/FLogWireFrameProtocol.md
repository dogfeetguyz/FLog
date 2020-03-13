# FLogWireFrameProtocol

Protocol that defines the possible routes from the Routine Module.
The Router is responsible for navigation between modules.

``` swift
public protocol FLogWireFrameProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`FLogWireFrame`](FLogWireFrame)

## Required Methods

## createRoutineModule()

Creates Routine Module

``` swift
static func createRoutineModule() -> UIViewController
```

## presentRoutineDetailViewScreen(from:forRoutine:)

Presents Routine Detail Module

``` swift
func presentRoutineDetailViewScreen(from view: FLogViewProtocol, forRoutine routine: MainRoutineModel)
```

  - parameter view: this view

<!-- end list -->

  - parameter routine: targeted routine to go detail module

## presentNewRoutineViewScreen(from:)

Presents New Routine Module

``` swift
func presentNewRoutineViewScreen(from view: FLogViewProtocol)
```

  - parameter view: this view
