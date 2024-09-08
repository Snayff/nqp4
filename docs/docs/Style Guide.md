# Brief
For self and for others who might want to contribute, we need a consistent way of working. This document seeks to define that way. It will also support easier introduction and reading of the project. 

We try to follow Godot's [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) as a primary authority, and Python's [PEP8](https://www.python.org/dev/peps/pep-0008/) after that.
# Structure
## Overview
The top level folder structure should look like this:
-assets
-data
-docs
-scenes
-scripts

## Assets
The `assets` folder contains all non-code assets. 


While utilising assets from a variety of places we include the `license.txt` file alongside the related assets. 
## Data
Config and data files.
## Docs
Project documentation is held here.

## Scenes
xxx

## Scripts
xxx

# Naming
## Private or Public
Private or local variables and functions should be prefixed with an underscore, i.e. `_`. This is to keep the external API of the class as clean and simple as possible. 

## Is or Has
For any conditions that check the *thing*-ness of a class, we use `Is*` or `Has*`, e.g. `IsReady` naming conventions. 

# Formatting
## Ordering
A template is provided, which provides a standard organisation for .gd files.
## Indentation
We use K&R indentation, specifically the One True Brace version, e.g.
```
func is_negative(int x) -> bool:
    if (x < 0):
        return true
    else:
        return false
    

```
Or
```
bool is_negative(int x) {
    if (x < 0) {
        return true;
    } else {
        return false;
    }
}
```
# Type Hints
Static typing is used for everything. This is both for comprehension and for performance increases.

# Comments
Comment precede the thing they refer to. We use the preceding line for most things, and inline for class variables, to make scanning the block of variables easier.

# Warnings & Errors
`assert`s are used where we want the game to fail hard. These are predominantly for things that will be known at initialisation.
`push_error`s are used where we want to log a serious, game breaking issue found during run-time.
`push_warning`s are for anything that isnt game breaking, but as a developer we still want to log has happened. 
