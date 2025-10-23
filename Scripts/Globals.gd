extends Node

func GetGhostHints(type: Ghost.GhostTypes) -> Array[Item.HoldableItems]:
  match type:
    Ghost.GhostTypes.Spirit:
      return [Item.HoldableItems.EMFSDetector, Item.HoldableItems.Thermometer, Item.HoldableItems.MotionSensor]
    Ghost.GhostTypes.Demon:
      return [Item.HoldableItems.EMFSDetector, Item.HoldableItems.MotionSensor, Item.HoldableItems.SoundSensor]
    Ghost.GhostTypes.Oni:
      return [Item.HoldableItems.Thermometer, Item.HoldableItems.MotionSensor, Item.HoldableItems.SoundSensor]
    Ghost.GhostTypes.Wraith:
      return [Item.HoldableItems.Thermometer, Item.HoldableItems.SoundSensor, Item.HoldableItems.EMFSDetector]
    _:
      return []
