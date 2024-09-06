# Fanctronic (Vectronic in Portal 2) - [PROJECT STATUS: ABANDONED]

This repository contains the VSquirrel code for a Portal 2 mod project, "Fanctronic". It aimed to recreate the Vectronic game mode within Portal 2, with permission from ReepBlue, the original creator of Vectronic. The project envisioned enhancements to the original Vectronic gameplay and the addition of a narrative element through a Workshop map. 

**Important:** This project is currently **abandoned** due to time constraints. The code is not actively maintained and is provided **for educational purposes only**. It is **not intended for use in other projects** without explicit permission. 

## Disclaimer

This code was written some time ago and utilizes an older version of PCapture-Lib (2.0). It may not be fully optimized or adhere to best practices. It is recommended to explore the updated PCapture-Lib 3.0 for any serious modding endeavors.

## Demonstrations

You can see some early gameplay demonstrations in these videos:

* [Video 1](https://youtu.be/VSlK_Ylirb0)
* [Video 2](https://youtu.be/M09aj3l4OvU)
* [Video 3](https://www.youtube.com/watch?v=jMmPvt8GkEc)
* [Video 4](https://youtu.be/Kx8BKRb6ry8)

## Code Overview

The codebase leverages PCapture-Lib to interact with Portal 2 entities and create custom gameplay elements. It primarily revolves around the following components:

### Vecballs (Projectiles)

* **projectile.nut:** Defines the base class for all vecball projectiles, handling their creation, movement, and interactions.
* **vecballs/main.nut:** Initializes the array of available vecball types.
* **vecballs/[color].nut:** (e.g., blue.nut, green.nut) Implement specific behaviors for each vecball color (gravity manipulation, ghosting, etc.).

### Vecgun

* **vecgun.nut:** Implements the Vectronic Gun logic, including mode selection, shooting, and projectile management.

### Hit Controller

* **hit-controller.nut:** Manages the collision detection between vecballs and vecboxes (cargo cubes), triggering the appropriate effects.

### Gameplay Elements

* **vecbox.nut:** Defines the vecbox (cargo cube) class, handling its modes, activation, and effects.
* **dispenser.nut:** Implements the vecball dispenser logic, providing new vecballs to the player.
* **ballshot.nut:** Handles the functionality of ball shooter entities.
* **fizzler.nut:** Implements the fizzler logic, which resets vecballs and vecboxes.

## Learning Resources

* **PCapture-Lib:** https://github.com/IaVashik/PCapture-Lib
* **VScripts (VSquirrel) Documentation:** https://developer.valvesoftware.com/wiki/Squirrel
* **Portal 2 VScript Documentation:** https://developer.valvesoftware.com/wiki/Portal_2_Scripting

By studying this code, you can gain insights into:

* Implementing custom gameplay mechanics in Portal 2 using PCapture-Lib.
* Creating and managing projectiles and their interactions.
* Designing custom HUD elements and event systems.

Feel free to explore, experiment, and learn from the code. Remember that it is provided for educational purposes and should not be used directly in other projects without proper authorization. 