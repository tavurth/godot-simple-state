# Table of Contents

1.  [Usage](#org4aefb14)

<a id="org4aefb14"></a>

# Usage

1.  Install the plugin
2.  Enable the plugin
3.  Add a \`SateMachine\` node to your character
<img width="342" alt="Screenshot 2022-02-19 at 12 36 45" src="https://user-images.githubusercontent.com/100964/154795429-effb016d-1d2b-4719-b4f9-8dc14f6e23c1.png">

5.  Add any type of \`Node\` to the \`StateMachine\` as a child to create a new script
<img width="343" alt="Screenshot 2022-02-19 at 12 36 30" src="https://user-images.githubusercontent.com/100964/154795416-322c85d7-8557-42a3-9b49-e3607a798512.png">

7.  Attach a script to the node
8.  Now at runtime you can change to a different state using `$StateMachine.godot("state")`

# Example

The example project contains two states, `idle` and `attack`.
The project will switch between each state automatically every 3 seconds.

# Signals

You can connect signals directly to the `StateMachine` node using the following style:

<img width="1024" alt="Screenshot 2022-02-19 at 13 00 38" src="https://user-images.githubusercontent.com/100964/154796280-646ee238-583e-4688-b279-304023140a54.png">

They will be then automatically sent to the current active state if that state has the handler function defined.
