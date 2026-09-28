Overview
This folder contains the Verse-authored gameplay devices used in ECHO-33: Alien Rescue Adventure, a cooperative prop-hunt/adventure island published through the UEFN Bootcamp.
Each device handles a different gameplay system: resource collection, cinematic sequencing, or end-game progression - so the island can react dynamically to what players do.

These scripts are meant to be readable and easy to reuse. If you're building something similar, feel free to borrow the patterns, tweak the thresholds, or plug the devices into your own UEFN project.

Included Devices
1. community_resource_goal_device.verse
  Track team-wide resource contributions (wood, stone, metal).
  When all thresholds are met, it triggers a building assembly cinematic.
    Useful for:
      * Cooperative goals
      * "Collect X resources to unlock Y" mechanics
      * Team-based progression
      * Triggering sequences or prop reveals
   Key ideas inside the script:
      * Subscribing to button events
      * Editable thresholds
      * Guarding against re-triggering
      * Disabling devices after completion
2. sequence_chainer_device.verse
  Runs a multi-stage cinematic chain in a specific order.
  Some sequences play in reverse at 3x speed before transitioning to the next.
    Useful for:
      * Dramatic finales
      * Multi-step cutscenes
      * Chaining multiple sequences together
      * Triggering endgame events
   Key ideas inside the script:
      * Phase-based state machine
      * Reverse play logic
      * Adjustable play rates
      * Clean event-driven sequencing
3. ShipParts_Goal_Device.verse
   This file currently mirrors the sequence chainer logic.
   If you're using it for ship-part collection or a different goal, you can rename or modify it to match your gameplay.

How to Reuse These Devices
You can drop these devices into your own UEFN project and:
  * Adjust thresholds with @editable values
  * Swap out cinematic sequences
  * Replace triggers with your own devices
  * Add more resource types
  * Extend the phase logic for longer chains
Everything is written to be modular and easy to customize.

Fortnite Island code: 7782-2027-0384
To play the game just put the island code in the Discover tab's search bar, type ECHO-33, or use this link: https://play.fn.gg/island/6782-2027-0384?pl=cr00001
My credential for completing the Bootcamp can be viewed here: https://www.credential.net/8d59974c-5216-48f9-b915-523098ac81d2#acc.LtSYbo1c
