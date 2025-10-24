extends Node

func GetGhostHints(type: Ghost.GhostTypes) -> Array[Item.HoldableItems]:
  match type:
    Ghost.GhostTypes.Spirit:
      # return [Item.HoldableItems.Thermometer, Item.HoldableItems.SpiritBox, Item.HoldableItems.EMFDetector]
      return [Item.HoldableItems.SpiritBox]
    Ghost.GhostTypes.Demon:
      return [Item.HoldableItems.EMFDetector, Item.HoldableItems.MotionSensor, Item.HoldableItems.SpiritBox]
    Ghost.GhostTypes.Oni:
      return [Item.HoldableItems.Thermometer, Item.HoldableItems.MotionSensor, Item.HoldableItems.SpiritBox]
    Ghost.GhostTypes.Wraith:
      return [Item.HoldableItems.EMFDetector, Item.HoldableItems.Thermometer, Item.HoldableItems.MotionSensor]
    _:
      return []
