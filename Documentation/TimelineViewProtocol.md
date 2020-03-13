# TimelineViewProtocol

Protocol that defines the view input methods.
The View is responsible for displaying Timeline Screen.

``` swift
public protocol TimelineViewProtocol: class
```

## Inheritance

`class`

## Conforming Types

[`TimelineView`](TimelineView)

## Required Properties

## presenter

Reference to the Presenter's interface.

``` swift
var presenter: TimelinePresenterProtocol?
```

## Required Methods

## showTimelines(with:)

Shows timeline data on tableview

``` swift
func showTimelines(with timelineArray: [TimelineModel])
```

  - parameter timelineArray: An array of TimelineModel including Timeline Data loaded from Core Data and Content processed from UserDefaults
