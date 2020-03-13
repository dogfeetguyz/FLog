# RoutineDetailWireFrameProtocol

Protocol that defines the possible routes from the Routine Module.
The Router is responsible for navigation between modules.

``` swift
public protocol RoutineDetailWireFrameProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`RoutineDetailWireFrame`](RoutineDetailWireFrame)

## Required Methods

## createRoutineDetailModule(with:)

Creates Routine Detail Module

``` swift
static func createRoutineDetailModule(with routineModel: MainRoutineModel) -> UIViewController
```
