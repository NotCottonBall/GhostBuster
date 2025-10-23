extends Node

func GetGhostHints(type: Ghost.GhostTypes) -> Array[Item.HoldableItems]:
  match type:
    Ghost.GhostTypes.Spirit:
      # return [Item.HoldableItems.EMFDetector, Item.HoldableItems.Thermometer, Item.HoldableItems.MotionSensor]
      return [Item.HoldableItems.EMFDetector]
    Ghost.GhostTypes.Demon:
      return [Item.HoldableItems.EMFDetector, Item.HoldableItems.MotionSensor, Item.HoldableItems.SoundSensor]
    Ghost.GhostTypes.Oni:
      return [Item.HoldableItems.Thermometer, Item.HoldableItems.MotionSensor, Item.HoldableItems.SoundSensor]
    Ghost.GhostTypes.Wraith:
      return [Item.HoldableItems.Thermometer, Item.HoldableItems.SoundSensor, Item.HoldableItems.EMFDetector]
    _:
      return []
