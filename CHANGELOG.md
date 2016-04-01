### 1.0.2 - 31 March 2016
* Use UTF-8 encoding by default
* Allow indentation level to be specified when outputting XML

### 1.0.1
* Fix nested DSLs not being able to access methods defined outside of their scope
    * ie. Rails url helpers from within a nested tag

### 1.0.0 [yanked] 
* Initial version of Ox::Builder
* Includes mappings for all Ox node types (element, instruct, doctype, comment)
* Includes template handler for ActionView and Tilt
