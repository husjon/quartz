---
title: Modelling with Blender for the 3D printer
created: 2023-07-19T19:53:11+02:00
updated: 2023-11-11T19:01:33+01:00
tags:
  - 3d_printing
  - 3d_modelling
  - blender
publish: true
---
When using the default settings in Blender (Metric and a scale of 1), PrusaSlicer tends to be very unsure as to which kind of dimensions were used.  
It will ask if you want to recalculate the dimensions as seen below.
![[public/images/Pasted image 20230719194937.png]]

This can be fixed by setting the Scaling used in Blender to 100
![[public/images/Pasted image 20230719195549.png]]

This will make it so that a 200meter object in Blender is converted to a 200millimeter object in PrusaSlicer.  
This will also make it so that PrusaSlicer knows exactly how big the object is and will no longer ask to recalculate the dimensions that you export from Blender.
![[public/images/Pasted image 20230719195619.png]]

**Note:**
* If you're using the 3D-Print toolbox[^3d_print_toolbox-link] addon, remember to check `Apply Scale` before exporting.
* If you're using the stock Blender export, remember to check `Scene Units` under Transform during the stl export.


[^3d_print_toolbox-link]: https://docs.blender.org/manual/en/3.6/addons/mesh/3d_print_toolbox.html
