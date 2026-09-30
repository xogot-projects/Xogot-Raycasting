# Raycasting in Xogot (Xogot 3D Tutorial)

This project contains the example scenes and assets used in the
**Xogot 3D Modular Series - Raycasting** tutorial by **Erin Uptegrove**.

It demonstrates how to use paired `RayCast3D` nodes to align a 3D character with sloped
surfaces, detect when the character is partly over an edge, and add a natural forward or
backward tilt before the character falls.

---

## Features

* Add front and back `RayCast3D` nodes to a character scene
* Force raycast updates after movement so collision results stay synchronized
* Detect which parts of the character are supported with `is_colliding()`
* Read and average collision normals from the ground
* Align the character to slopes with `Basis.looking_at()` and `slerp()`
* Detect front- and back-foot overhangs independently
* Tilt the character toward an unsupported edge
* Apply a small directional nudge so a stopped character completes the fall

---

## Notes

This project focuses on an introductory, practical use of raycasting in Xogot. The sample uses
two downward-facing rays beneath the axolotl: one near the front feet and one near the back feet.
Their collision results determine whether the character should follow a surface, lean over an
edge, or return to an upright orientation while airborne.

The project also retains the movement, jumping, camera, animated platform, and fall-reset systems
used by the surrounding modular tutorial series.

---

## Video Tutorial

Watch the full walkthrough on the [Xogot YouTube Channel](https://youtube.com/@xogot):

**Raycasting in Xogot - Game Development in Godot on iPad**

https://youtu.be/VF3md2fhKqI

---

## How to Use

1. Download or clone this repository:

   ```bash
   git clone https://github.com/xogot-projects/Xogot-Raycasting.git
   ```

2. Open the project in [Xogot](https://apps.apple.com/us/app/xogot-make-games-anywhere/id6469385251) on iPad or iPhone.

3. Open `Environments/Day.tscn` and preview the project.

4. Use the virtual controls to move and turn the axolotl, then test the ramps and platform edges.

5. Open `Assets/player.tscn` and `scripts/player_raycast.gd` to inspect or tune the ray positions, tilt amount, alignment speed, and falling behavior.

---

## Project Structure

* `Assets/player.tscn` - character scene with front and back `RayCast3D` nodes
* `Environments/Day.tscn` - main tutorial scene with slopes, gaps, and moving platforms
* `scripts/player_raycast.gd` - surface alignment and edge-overhang raycasting logic
* `scripts/player.gd` - baseline movement script without the raycasting additions
* `Assets/cam_control.tscn` - reusable third-person camera controller

---

## Learn More

* [Xogot](https://xogot.com)
* [Xogot Documentation](https://docs.xogot.com/documentation/xogot/)
* [Xogot Tutorials](https://docs.xogot.com/tutorials/xogot-tutorials/)

Built with Xogot on iPad.
