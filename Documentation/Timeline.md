# Timeline

Structure that is used for holding Timeline data.

``` swift
public class Timeline: NSManagedObject
```

## Inheritance

`NSManagedObject`

## Properties

## id

Unique id

``` swift
var id: Int32
```

## logDate

Date for this timeline

``` swift
var logDate: String?
```

## routineTitle

Title for this timeline

``` swift
var routineTitle: String?
```

## Methods

## fetchRequest()

Request FETCH for Timeline data

``` swift
@nonobjc public class func fetchRequest() -> NSFetchRequest<Timeline>
```
