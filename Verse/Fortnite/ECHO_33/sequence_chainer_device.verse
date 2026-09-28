
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for 
# how to create a verse device.

# Manages a multi-stage cinematic sequence chain triggered by a game event.
# 1. Trigger fires -> Seq2 plays in reverse at 3x speed.
# 2. Seq2 reverse fineshes -> Seq1 plays in reverse at 3x speed.
# 3. Seq1 reverse finishes -> Seq3 plays forward (UFO takeoff).
# 4. Seq3 finishes -> End game is triggered.

# A Verse-authored creative device that can be placed in a level
sequence_chainer_device := class(creative_device):

    # The trigger that starts the entire sequence (e.g., from a tracker completion).
    @editable
    TriggerDevice : trigger_device = trigger_device{}

    # The first cinematic sequence (vertical damage volume).
    @editable
    Seq1 : cinematic_sequence_device = cinematic_sequence_device{}

    # The second cinematic sequence (horizontal damage volume).
    @editable
    Seq2 : cinematic_sequence_device = cinematic_sequence_device{}

    # The third cinematic sequence (UFO takeoff).
    @editable
    Seq3 : cinematic_sequence_device = cinematic_sequence_device{}

    # The device that ends the game.
    @editable
    EndGameDevice : end_game_device = end_game_device{}

    # Tracks the current phase of the sequence chain to distinguish between stop events.
    # 0 = Idle
    # 1 = waiting for Seq2 to finish playing in reverse
    # 2 = waiting for Seq1 to finish playing in reverse
    # 3 = Waiting for Seq3 to finish playing forward
    var CurrentPhase : int = 0

    # Subscribes to all device events when the experience begins.
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        TriggerDevice.TriggeredEvent.Subscribe(OnTriggerFired)
        Seq1.StoppedEvent.Subscribe(OnSeq1Stopped)
        Seq2.StoppedEvent.Subscribe(OnSeq2Stopped)
        Seq3.StoppedEvent.Subscribe(OnSeq3Stopped)

    # Called when the trigger device is activated. Starts the sequence chain.
    OnTriggerFired(Agent : ?agent):void =
        # Only start if we are in the idle phase to prevent re-triggering.
        if (CurrentPhase = 0):
            set CurrentPhase = 1
            # Set play rate to 3x before playing in reverse.
            Seq2.SetPlayRate(3.0)
            Seq2.PlayReverse()
            
    # Called whenever Seq2 stops. Only proceeds if we're in the correct phase.
    OnSeq2Stopped():void =
        # This fires after seq2's reverse play completes.
        # The check ensures we ignore an prior forward-play stops.
        if (CurrentPhase = 1):
            # Reset Seq2's play rate to normal for future use.
            Seq2.SetPlayRate(1.0)
            set CurrentPhase = 2
            # Set Seq1's play rate to 3x for its reverse play.
            Seq1.SetPlayRate(3.0)
            Seq1.PlayReverse()

    # Called whenever Seq1 stops. Proceeds to the next phase.
    OnSeq1Stopped():void =
        # This fires after Seq1;s reverse play completes.
        if (CurrentPhase =2):
            # Reset Seq1's play rate to normal.
            Seq1.SetPlayRate(1.0)
            set CurrentPhase = 3
            # Ensure Seq3 plays at normal speed.
            Seq3.SetPlayRate(1.0)
            Seq3.Play()

    # Called whenever Seq3 stops. Triggers the end of the game.
    OnSeq3Stopped():void=
        # This fires after the UFO takeoff sequence completes.
        if (CurrentPhase = 3):
            # Mark as complete to prevent any further actions.
            set CurrentPhase = 4
            # Activate the end game device. The agent is optional;
            # if the device is set to "Everyone", it can be triggered without one.
            if (Agent := GetPlayspace().GetPlayers()[0]):
                EndGameDevice.Activate(Agent)

    # Summary of changes:
        # Increased sequences 1 and 2's play rates by 3x for dramatic end sequence effect.