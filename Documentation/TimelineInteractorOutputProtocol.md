# TimelineInteractorOutputProtocol

Protocol that defines the commands sent from the Interactor to the Presenter.

``` swift
public protocol TimelineInteractorOutputProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`TimelinePresenter`](TimelinePresenter)

## Required Methods

## didDispatchTimelines(with:)

Finished dispatching Timelines from Core Data

``` swift
func didDispatchTimelines(with timelineArray: [TimelineModel])
```

  - parameter timelineArray: An array of TimelineModel including Timeline Data loaded from Core Data and Content processed from UserDefaults
