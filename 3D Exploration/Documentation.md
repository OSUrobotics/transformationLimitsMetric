* **Analysis**
  * clusterStd.m (*Script*): 
  * getThresholds.m (*Function*): 
  * imageGenerator.m (*Script*): 
  * kMeansStability.m (*Function*): 
  * kmeans2images.m (*Function*): 
  * load4kmeans.m (*Function*): 
  * plotKmeans.m (*Script*): 
  * prepGraspForKmeans.m (*Function*): 
* **ClusterOut**
* **handAndAlignment**
  * **hand**
  * **transforms**
  * obj_dict.csv: 
* ****Images****
* **Mesh Tools**
  * **File Readers**
    * read_ply.m (*Function*): 
    * stlGetFormat.m (*Function*): 
    * stlRead.m (*Function*): 
    * stlReadAscii.m (*Function*): 
    * stlReadBinary.m (*Function*): 
    * stlSlimVerts.m (*Function*): 
  * **File Writers**
    * write_ply.m (*Function*): 
  * getBBcenter.m (*Function*): 
  * getCentroidMesh.m (*Function*): 
  * rotateMesh.m (*Function*): 
  * translateMesh.m (*Function*): 
  * trimeshSurfaceArea.m (*Function*): 
  * vectorCross3d.m (*Function*): 
* **Output**
* **Readers and Visualizations**
  * **PresentationImages**
  * plotAxesArrows.m (*Function*): 
  * visualizeTransformations.m (*Function*): 
* **sampleSTLs**
* **Simulation Sections**
  * **Collision Detection**
     * **Dependencies**
        * VOXELISE.m (*Function*): 
        * intriangulation.m (*Function*): 
     * getCollisionValues.m (*Function*): Old function that used *intriangulation.m* to calculate volume of intersection. Was replaced by *getCollisionVoxelVoxel.m*. See also: *getCollisionVoxelVoxel.m*, *intriangulation.m*
     * getCollisionVoxelVoxel.m (*Function*): 
     * getPercentCollision.m (*Function*): Old function that used *intriangulation.m* to to calculate volume of intersection and percentage of intersection. Was replaced by *getCollisionVoxelVoxel.m*. See also: *getCollisionVoxelVoxel.m*, *intriangulation.m*
     * getPercentCollisionWithVerts.m (*Function*): Old function that used *intriangulation.m* to calculate volume of intersection and percentage of intersection. Was replaced by *getCollisionVoxelVoxel.m*. See also: *getCollisionVoxelVoxel.m*, *intriangulation.m*
     * getVoxelisedVerts.m (*Function*): 
     * getVoxelValues.m (*Function*): 
  * **Generate Transformations**
    * **Dependencies**
      * SpiralSampleSphere.m (*Function*): Function from [Suite of functions to perform uniform sampling of a sphere](http://www.mathworks.com/matlabcentral/fileexchange/37004-suite-of-functions-to-perform-uniform-sampling-of-a-sphere) that generates a given number of point coordinates on a unit sphere using a "spiral phyllotaxis" method (Sunflower magic). See also: *generateTrajectories.m*
      * stlPlot.m (*Function*): Function from [stlTools](https://www.mathworks.com/matlabcentral/fileexchange/51200-stltools) modified to plot vertices as well. Plots a stl as stored with vertices and faces. See also: *stlPlotWColor.m*
      * stlPlotWColor.m (*Function*): A modified *stlPlot.m* that accepts an extra value (typically collision volume), which is the percentage of red added to the normal color of the object (high values will add more red to the gray). See also: *stlPlot.m*
    * applySavedTransformations.m (*Function*): Takes in a list of object points and the all-values transformation matrix generated by *saveTrajectories.m* and applies the transformations to the points, outputting a large set of all of the points, transformed to all of the steps on the way to the locations and orientations created by *generateTrajectories.m*, in a multi-dimensional array. See also: *saveTrajectories.m*, *generateTrajectories.m*, *runSimFun.m*
    * generateTrajectories.m (*Function*): Uses *SpiralSampleSphere.m* to generate translation vectors and rotation axes, then takes an input for the amount of rotation around each axis and gets all possible combinations of each, with an added no-movement case. See also: *saveTrajectories.m*, *SpiralSampleSphere.m*
    * matrix2values.m (*Function*): Converts a set of 4x4 transformation matrices from *trajectoryStepsEXPM.m* into *x,y,z* translation vectors and a rotation quaternion, to be stored alongside the collision volume in **Output**. See also: *saveTrajectories.m*
    * oldTrajectoryStepsEXPM.m (*Function*): An older version of trajectoryStepsEXPM that directly applied the transformations to the points instead of saving the matrices. See also: *trajectoryStepsEXPM.m*, *oldTrajectoryStepsEuler.m*
    * oldTrajectoryStepsEuler.m (*Function*): An older version of trajectoryStepsEuler that directly applied the transformations to the points instead of saving the matrices. See also: *trajectoryStepsEuler.m*, *oldTrajectoryStepsEXPM.m*
    * saveTrajectories.m (*Function*): Calls *trajectoryStepsEXPM.m* to generate interpolated paths to the coordinates and orientations specified in 
    * trajectoryStepsEXPM.m (*Function*): Creates a set of interpolated 4x4 transformation matrices along a set number of steps from the origin to the locations and orientations generated with *generateTrajectories.m*. Uses EXPM, the equivalent of a transformation matrix integral rather than the approximation used in *trajectoryStepsEuler.m*. See also: *saveTrajectories.m*, *generateTrajectories.m*, *trajectoryStepsEuler.m*
    * trajectoryStepsEuler.m (*Function*): An alternative to *trajectoryStepsEXPM.m* that uses the Euler to iterate over small transformations instead of EXPM. See also: *trajectoryStepsEXPM.m*
  * runSimFun.m (*Function*): 
* applySim2data.m (*Script*): **This is the main script to run the simulation.** It loads in or generates the stored transformations (*transformationStored.mat*), all grasp-object sets (**handAndAlignment**), calls *runSimFun.m*, and saves the intersection volume data to **Output**. See also: *runSimFun.m*, *transformationStored.mat*, *pathMapping.csv*, **Output**, **handAndAlignment**
* filenamesFromComponents.m (*Function*): Takes in the object, subject, grasp, and optimal or extreme string and outputs filenames for the hand, object, transformations, and output data, with optional step numbers or sprintf input format. See also: *pathMapping.csv*, *linkFilenames.m*
* linkFilenames.m (*Function*): Generates *pathMapping.csv*. Reads the **handAndAlignment/transforms** directory and scrapes the filename, then calls *filenamesFromComponents.m* and saves the results to a given file (*pathMapping.csv*). See also: *filenamesFromComponents.m*, *pathMapping.csv*
* loadHandObject.m (*Function*): Given a hand filepath, object vertices, and information about the hand centering, positions and scales the object and hand to fit in the origin, normalized to the unit sphere. Called by *applySim2data.m*.
* makeTransformationValuesOld.m (*Function*): An old function that used a different method for generating transformation values, using icosahedron sphere point generation, replaced by *generateTrajectories.m* as it did not allow the direct selection of an arbitrary number of values.
* pathMapping.csv: A list that links the filenames of the transformations, objects, hands, and outputs with the object, subject, grasp, and optimal or extreme string. Each line is an individual and unique grasp. See also: *filenamesFromComponents.m*, *linkFilenames.m*
* simpleHand.stl: An old example hand used for initial testing. Unimportant, unused now.
* transformationStored.mat: The saved transformation values and 4x4 matrices for every transformation direction and orientation, along with the settings used to create them. Generated by *saveTrajectories.m* and associated code. See also: *saveTrajectories.m*