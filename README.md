# transformationLimitsMetric
### Purpose: 
  Create a measure for grasping that is independant from the hand or object being grasped.

#### Method:
  Simulate possible movement of an object within a grasp.
  Create an even sampling of translations and rotations, then move the object to those points and get the amount of it that is colliding with the hand.
  Finally save data for interpretation.
  
#### Why:
  All current grasping metrics are dependant on the hand or the object, while this method measures the ability of the object to move while in the grasp.
  Thus, we measure the negative space that the object could move in, separate from the hand and the object.
  
