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
  * transformByOutputValues.m (*Function*): 
  * visualizeTransformations.m (*Function*): 
* **sampleSTLs**
* **Simulation Sections**
  * **Collision Detection**
     * **Dependencies**
        * COMPUTE_mesh_normals.m (*Function*): 
        * CONVERT_meshformat.m (*Function*): 
        * VOXELISE.m (*Function*): 
        * intriangulation.m (*Function*): 
     * getCollisionValues.m (*Function*): 
     * getCollisionVoxelVoxel.m (*Function*): 
     * getPercentCollision.m (*Function*): 
     * getPercentCollisionWithVerts.m (*Function*): 
     * getVoxelisedVerts.m (*Function*): 
     * voxelValues.m (*Function*): 
  * **Generate Transformations**
    * **Dependencies**
      * SpiralSampleSphere.m (*Function*): 
      * stlPlot.m (*Function*): 
      * stlPlotWColor.m (*Function*): 
    * applySavedTransformations.m (*Function*): 
    * generateTrajectories.m (*Function*): Uses *SpiralSampleSphere.m* to generate translation vectors and rotation axes, then takes an input for the amount of rotation around each axis and gets all possible combinations of each, with an added no-movement case. See also: *saveTrajectories.m*, *transformationStored.mat*
    * matrix2values.m (*Function*): Converts a set of 4x4 transformation matrices into *x,y,z* translation vectors and a rotation quaternion, to be stored alongside the collision volume in **Output**. See also: *saveTrajectories.m*, *transformByOutputValues.m*
    * oldTrajectoryStepsEXPM.m (*Function*): 
    * oldTrajectoryStepsEuler.m (*Function*): 
    * saveTrajectories.m (*Function*): 
    * trajectoryStepsEXPM.m (*Function*): 
    * trajectoryStepsEuler.m (*Function*): 
  * runSimFun.m (*Function*): 
* applySim2data.m (*Script*): **This is the main script to run the simulation.** It loads in or generates the stored transformations (*transformationStored.mat*), all grasp-object sets (**handAndAlignment**), calls *runSimFun.m*, and saves the intersection volume data to **Output**. See also: *runSimFun.m*, *transformationStored.mat*, *pathMapping.csv*, **Output**, **handAndAlignment**
* filenamesFromComponents.m (*Function*): Takes in the object, subject, grasp, and optimal or extreme string and outputs filenames for the hand, object, transformations, and output data, with optional step numbers or sprintf input format. See also: *pathMapping.csv*, *linkFilenames.m*
* linkFilenames.m (*Function*): Generates *pathMapping.csv*. Reads the **handAndAlignment/transforms** directory and scrapes the filename, then calls *filenamesFromComponents.m* and saves the results to a given file (*pathMapping.csv*). See also: *filenamesFromComponents.m*, *pathMapping.csv*
* loadHandObject.m (*Function*): Given a hand filepath, object vertices, and information about the hand centering, positions and scales the object and hand to fit in the origin, normalized to the unit sphere. Called by *applySim2data.m*.
* makeTransformationValuesOld.m (*Function*): An old function that used a different method for generating transformation values, using an Icosahedron sphere point generation, replaced by *generateTrajectories.m* as it did not allow the direct selection of an arbitrary number of values.
* pathMapping.csv: A list that links the filenames of the transformations, objects, hands, and outputs with the object, subject, grasp, and optimal or extreme string. Each line is an individual and unique grasp. See also: *filenamesFromComponents.m*, *linkFilenames.m*
* simpleHand.stl: An old example hand used for initial testing. Unimportant, unused now.
* transformationStored.mat: 