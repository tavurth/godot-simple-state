# Godot Simple State

A clean and easy to use Finite State Machine (FSM) for Godot 3.x

[![img](https://awesome.re/mentioned-badge.svg)](https://github.com/godotengine/awesome-godot)
![img](https://img.shields.io/github/license/tavurth/godot-simple-state.svg)
![img](https://img.shields.io/github/repo-size/tavurth/godot-simple-state.svg)
![img](https://img.shields.io/github/languages/code-size/tavurth/godot-simple-state.svg)

<a id="org4aefb14"></a>

# Usage

1.  Install the plugin
2.  Enable the plugin
3.  Add a `SateMachine` node to your character

    <img width="342" alt="Screenshot 2022-02-19 at 12 36 45" src="https://user-images.githubusercontent.com/100964/154795429-effb016d-1d2b-4719-b4f9-8dc14f6e23c1.png">

4.  Add any type of `Node` to the `StateMachine` as a child to create a new script

    <img width="343" alt="Screenshot 2022-02-19 at 12 36 30" src="https://user-images.githubusercontent.com/100964/154795416-322c85d7-8557-42a3-9b49-e3607a798512.png">

5.  Attach a script to the node
6.  Now at runtime you can change to a different state using `$StateMachine.goto("state")`

# Example

The example project contains two states, `idle` and `attack`.
The project will switch between each state automatically every 3 seconds.

# State functionality

The state has a few functionalities, here is an example state:

```ddscript
extends Node2D

var Parent
var States

func _state_enter(arg or not):
    pass

func _state_exit():
    pass
```

# Reference

## StateMachine

### `signal` `state_changed(new_state)`

Emitted whenever the `StateMachine` changes state (but before `_state_enter` is called)

### `goto(state_name: String, args = null)` change the state

`args` can be any or `undefined`

When an arg is passed, the argument will be pushed to the `_state_enter` function.

```gdscript
StateMachine.goto("attack")
StateMachine.goto("attack", some_character)
StateMachine.goto("attack", [some_character_a, some_character_b])
```

The last example would call this function in the `attack` state:

```gdscript
func _state_enter(some_characters: Array):
    ...
```

### `call(method: String, args = null)` call a function on the current state (if exists)

```gdscript
StateMachine.call("some_method")
StateMachine.call("some_method", my_argument)
StateMachine.call("some_method", [my_arguments])
```

### `now(state: String)`

Returns true if the current state matches `state`

```gdscript
if States.now("afraid"):
    # keep running away instead of stopping to look at something
```

### `restart(arg: any or none)`

Restarts the current state
This only calls "\_state_enter" again
it does not reset any variables

## State

`_state_enter(args or not)` will be called when the state is entered (each time)
An argument is only passed if one was passed. (`StateMachine.goto("state", arg)`)

`_state_exit()` will be called when the state is left (each time)

If the following variables exist on your state, they will be injected with dependencies as follows:

`Parent` is the parent of `StateMachine` i.e. your character controller

`States` is the `StateMachine`

If they do not exist on your state, nothing will be injected.

# Signals

You can connect signals directly to the `StateMachine` node using the following style:

<img width="1024" alt="Screenshot 2022-02-19 at 13 00 38" src="https://user-images.githubusercontent.com/100964/154796280-646ee238-583e-4688-b279-304023140a54.png">

They will be then automatically sent to the current active state if that state has the handler function defined.

<a href="https://www.buymeacoffee.com/tavurth" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
