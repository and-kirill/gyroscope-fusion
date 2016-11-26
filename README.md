Gyroscope Kalman filter implementation based on the following paper:

http://library.keldysh.ru//preprint.asp?lg=e&id=2015-47

This model was presented at Lab. 11 IITP RAS seminar in october 2015.
'doc' directory contains description and presntation (in Russian).

The main idea of this filter is to replace rotation increment with quaternion multiplication. Proper linearization is implemented within this code and demo scenarios are provided.

The following data as assumed to be fused:
- angular velocity measurements (with constant bias taken into account)
- some reference direction (say, magnetic field).

Quick start:
1. run startup.m
2. runtests.m

Running estimation procedure on real data:
1. exectute runJson script
