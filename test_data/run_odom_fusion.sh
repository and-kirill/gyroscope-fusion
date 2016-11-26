#!/bin/bash
# Run odom fusion demo from the repository root
./bin.linux64.release/odom_fusion_demo tools/odom_fusion_simulink/test_data/test_pitch.ldj result.dat
# Visualize angles
./visualize.R
okular Rplot.png
