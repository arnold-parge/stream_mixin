## [3.0.4] - 7 Nov 2021
- Updated package description

# [3.0.3] - 6 Nov 2021
- Updated README

## [3.0.2] - 6 Nov 2021
- Updated README
- Updated example

## [3.0.1] - 6 Nov 2021
- Updated README

## [3.0.0] - 6 Nov 2021 (BREAKING CHANGES)
- Simplified the functions of StoreService
- Added more functions to StoreService
    - add
    - update
    - delete
    - deleteItemById
- Renamed BasicModel -> BaseModel for better understanding
- Changed type of TodoModel's id from int to string as the id could be string and int can be converted to string but not the other way around
- Added unit tests for StreamMixin and StoreService(add, update and delete item)

## [2.0.0] - 8 Aug 2021
- Added null safty
- Added `lastUpdate` in StreamMixin to know the last update value

## [1.0.6] - 21 June 2020
- added descriptive comments for classes, fields and methods

## [1.0.5] - 21 June 2020
- Updated issue link in readme

## [1.0.4] - 20 June 2020
- Merged examples in main.dart

## [1.0.3] - 20 June 2020
- Moved todo example in separate file

## [1.0.2] - 20 June 2020
### Bux fixes:
- Null id in example todo model
- Fixed add method in StoreService
- Added updateAll in StoreService
- Changed item in StreamMixin to element
- Made element in StreamMixin optional
- Updated tests for above changes

## [1.0.1] - 20 June 2020
- Added intention in readme.

## [1.0.0] - 20 June 2020
- Initial Release.
