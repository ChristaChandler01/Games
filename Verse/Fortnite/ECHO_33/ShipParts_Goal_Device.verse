
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A minimalist logic gate that fires a trigger only when all three specified trackers have been completed.
# A Verse-authored creative device that can be placed in a level
ShipParts_Goal_Device := class(creative_device):

    # Assign your three cooperative trackers.
    @editable
    TrackerA : tracker_device = tracker_device{}

    @editable
    TrackerB : tracker_device = tracker_device{}

    @editable
    TrackerC : tracker_device = tracker_device{}

    # Assign a trigger that will activate your next objective or event.
    @editable
    OutputTrigger : trigger_device = trigger_device{}

    # Prevents the output from firing more than once.
    var HasFired : logic = false

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # Subscribe all three trackers to the SAME handler function.
        TrackerA.CompleteEvent.Subscribe(OnAnyTrackerComplete)
        TrackerB.CompleteEvent.Subscribe(OnAnyTrackerComplete)
        TrackerC.CompleteEvent.Subscribe(OnAnyTrackerComplete)
    
    # This single function runs whenever ANY of the three trackers complete.
    OnAnyTrackerComplete(Agent : agent):void=
        # Only proceed if we haven't already fired the output trigger.
        if (HasFired = false):
            # Check if all three trackers have reached their target for the triggering agent.
            # Because the trackers are shared, this works for the whole team.
            if:
                TrackerA.HasReachedTarget[Agent],
                TrackerB.HasReachedTarget[Agent],
                TrackerC.HasReachedTarget[Agent]
            then:
                # All three trackers are completed!
                set HasFired = true
                OutputTrigger.Trigger()