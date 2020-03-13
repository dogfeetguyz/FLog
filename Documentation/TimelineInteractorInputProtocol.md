# TimelineInteractorInputProtocol

Protocol that defines the Interactor's use case.
The Interactor is responsible for implementing business logics of the module.

``` swift
public protocol TimelineInteractorInputProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`TimelineInteractorInput`](TimelineInteractorInput)

## Required Properties

## presenter

Reference to the Presenter's interface.

``` swift
var presenter: TimelineInteractorOutputProtocol?
```

## Required Methods

## createTimelineData()

Creates TImeline data for the first execute

``` swift
func createTimelineData()
```

## dispatchTimelines()

Dispatches Timeline from Core Data

``` swift
func dispatchTimelines()
```
