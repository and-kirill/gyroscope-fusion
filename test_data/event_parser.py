#!/opt/local/bin/python2.7

import argparse
import json

def write_data(data, filename):
    # Write data as the space-delimited numbers
    f = open(filename, 'w')
    for event in data:
        s = ''
        for val in event:
            s += '%7.10f ' % val
        s += '\n'
        f.write(s)
    f.close()


# Command line arguments parser
parser = argparse.ArgumentParser(
        description='Process json-based event list into matlab and R readable data structures'
        )
parser.add_argument("source", help="JSON event source")

args = parser.parse_args()

fname = args.source
# Read json file
with open(fname) as f:
    content = f.readlines()

# Final data: additional IMU
# Format: ts, omega_x, omega_y, omega_z
add_imu_gyroscope = []
# Format: ts, acc_x, acc_y, acc_z
add_imu_accelerometer= []
# Format: ts, Bx, By, Bz
add_imu_magnetometer = []
# Format: ts, Bx, By, Bz
main_imu_magnetometer = []
# Format: ts, direction
encoder_rear_left = []
# Format: ts, direction
encoder_rear_right = []

ts_start = None  # Should be initialized with the first event
for s in content:
    event = json.loads(s)
    assert 'w' in event.keys()
    assert 'ts' in event.keys()
    ts = float(event['ts'])
    # Some bags have erroneous zero timestamp. Skip this data
    if ts == 0:
        continue
    if ts_start is None:
        ts_start = ts
    ts_rel = ts - ts_start
    source = event['w']
    if source == 'add_imu':
        # Gyroscope measurement event
        gyro_meas = [ts_rel]+ event['angular_velocity']
        add_imu_gyroscope.append(gyro_meas)
        # Accelerometer measurement event
        acc_meas = [ts_rel] + event['linear_acceleration']
        add_imu_accelerometer.append(acc_meas)
        # Magnetometer measurement event
        mag_meas = [ts_rel] + event['mag']
        add_imu_magnetometer.append(mag_meas)
    if source == 'main_imu':
        # Magnetometer measurement event
        mag_meas = [ts_rel] + event['mag']
        main_imu_magnetometer.append(mag_meas)
    if source == 'rear_wheels':
        assert 'encoder_trigger' in event.keys()
        wheel_name = event['encoder_trigger']
        encoder_event = [ts_rel, event['direction']]
        if wheel_name == 'left':
            encoder_rear_left.append(encoder_event)
        elif wheel_name == 'right':
            encoder_rear_right.append(encoder_event)
        else:
            raise RuntimeError('Unknown wheel name when encoder received')
        wheel_name = None
        print event



write_data(add_imu_accelerometer, 'add_imu_acc.dat');
write_data(add_imu_gyroscope, 'add_imu_gyro.dat');
write_data(add_imu_magnetometer, 'add_imu_magnetometer.dat');
write_data(main_imu_magnetometer, 'main_imu_magnetometer.dat');
write_data(encoder_rear_left, 'encoder_left.dat');
write_data(encoder_rear_right, 'encoder_right.dat');
