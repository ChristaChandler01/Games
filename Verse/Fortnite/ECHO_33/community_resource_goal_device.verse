
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
# A creative device that tracks collective resource contributions from all players.
# When all resource thresholds are met, it triggers a cinematic sequence to "assemble" a building.
community_resource_goal_device := class(creative_device):

    # --- Resource Thresholds ---
    # The total amount of each resource required to complete the goal.
    @editable
    WoodThreshold : int = 1

    @editable
    StoneThreshold : int = 1

    @editable
    MetalThreshold : int = 1

    # --- Collection Devices ---
    # Assign three conditional_button_devices, each configured in UEFN to remove exactly 1 of its 
    # respective resource (wood, stone, metal).
    @editable
    WoodButton : conditional_button_device = conditional_button_device{}

    @editable
    StoneButton : conditional_button_device = conditional_button_device{}

    @editable
    MetalButton : conditional_button_device = conditional_button_device{}

    # --- Assembly Trigger ---
    # Assign a cinematic sequence that plays the building assembly animation.
    @editable
    AssemblySequence : cinematic_sequence_device = cinematic_sequence_device{}

    # --- Alternative: Prop Manipulator ---
    # If you prefer to show a pre-placed (but hidden) prop, assign a
    # prop_manipulator_device here and use ShowProps() in CheckThresholds.
    # @editable
    # BuildingProp : prop_manipulator_device = prop_manipulator_device{}

    # --- Internal State ---
    var CurrentWood : int = 0
    var CurrentStone : int = 0
    var CurrentMetal : int = 0
    var GoalReached : logic = false

    # Subscribe to all resource collection events when the experience starts.
    OnBegin<override>()<suspends>:void=
        WoodButton.ActivatedEvent.Subscribe(OnWoodCollected)
        StoneButton.ActivatedEvent.Subscribe(OnStoneCollected)
        MetalButton.ActivatedEvent.Subscribe(OnMetalCollected)

    # Increments wood count and checks if the goal is met.
    OnWoodCollected(Agent : agent) : void =
        if (GoalReached = false):
            set CurrentWood += 1
            CheckThresholds()
            
    # Increments stone count and checks if the goal is met.
    OnStoneCollected(Agent : agent) : void =
        if (GoalReached = false):
            set CurrentStone += 1
            CheckThresholds()

    # Increments metal count and checks if the goal is met.
    OnMetalCollected(Agent : agent) : void =
        if (GoalReached = false):
            set CurrentMetal += 1
            CheckThresholds()

    # Checks if all resource thresholds have been met.
    # If so, triggers the assembly and prevents future triggers.
    CheckThresholds() : void =
        # Guard: do nothing if the goal has already been reached.
        if (GoalReached = true):
            return

        # Check if all three resource counts meet or exceed their thresholds.
        if:
            CurrentWood >= WoodThreshold
            CurrentStone >= StoneThreshold
            CurrentMetal >= MetalThreshold
        then:
            # Mark the goal as reached to prevent re-triggering.
            set GoalReached = true

            # Trigger the building assembly.
            AssemblySequence.Play()

            #Alternative: if using a prop_manipulator_device, use this instead:
            # BuildingProp.ShowProps()

            # Optional: disable removers to stop further collection.
            WoodButton.Disable()
            StoneButton.Disable()
            MetalButton.Disable()