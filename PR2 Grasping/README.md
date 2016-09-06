## Purpose

The intent of this section of the project was to get another set of hand-object grasp pairs using a different hand, in this case the PR2, with the goal of verifying that the simulation was hand agnostic - that it could classify similar grasps made using different hands. By doing this, the simulation would be proved as watertight. 

## Data Source and Issues

All of this data was extracted from the [household objects database](http://wiki.ros.org/household_objects_database). The models in [stls](stls.rar) are extracted from the models table of the database. The filenames are the first values of the rows of the [objData](objData.csv) file, which was sourced from the [objInfo](objInfo.csv), [objNums](objNums.csv), and [setInfo](setInfo.csv) files, which were in turn extracted from the database, from various tables. 

The [stls](stls.rar) stored are associated with the many grasps stored there, though the grasps are as of yet un-extracted, since the [xml format](http://www.cs.columbia.edu/~cmatei/graspit/html-manual/graspit-manual_4.html#sec:robotfile) for the hands used with [GraspIt!](http://graspit-simulator.github.io/) is incompatable with the COLLADA or [xml format](http://openrave.programmingvision.com/wiki/index.php/Format:XML) used by [OpenRave](http://openrave.org/).