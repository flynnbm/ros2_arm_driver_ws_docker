# ROS 2 Jazzy Arm Simulation Docker Setup

This repository provides a setup for running a Gazebo simulated Franka Emika Panda with ROS 2 Jazzy inside a Docker container. It is built for plug-and-play ROS 2 robot simulation, more robot embodiments will be added in future updates.

## Docker Image

Pre-built image is hosted on Docker Hub:

```bash
docker pull flynnbm/arm_driver_ws
```

Contains:

- ROS 2 Jazzy (Ubuntu 24.04)
- ROS2 Panda moveit config package (`flynnbm/panda_ros2`)
- ROS2 hardware/simulated hardware bringup and description packages (`armada_ros2`)
- Gazebo Sim and RViz2
- Prebuilt `/root/arm_driver_ws` with RealSense launch files

## Requirements

- Docker and/or Docker Compose installed on a Linux machine
- Not tested outside of Linux, instructions are for Ubuntu but should work on any machine capable of running Docker

## Setup Instructions

### 1. Installing Docker & Compose on your machine

```bash
sudo apt update
sudo apt install docker.io docker-compose
```

### 2. Clone the repository

```bash
git clone https://github.com/flynnbm/ros2_arm_driver_ws_docker.git
cd ros2_arm_driver_ws_docker
```

### 3. Start the container

```bash
docker-compose up -d
```

Then enter the container:

```bash
docker exec -it arm_driver_ws bash
```

#### 3.1 (Optional alternative: no docker compose)
If you do not wish to use docker compose but still don't want to build the image yourself:

<pre>
# Enable X11 access from Docker containers
xhost +local:docker

# Run the container with GUI support
docker run -it \
  --name arm_driver_ws_dev \
  --env="DISPLAY=$DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  flynnbm/arm_driver_ws:jazzy
</pre>

#### 3.2  (Optional alternative: local image build)
Lastly, if you wish to build the docker image yourself:

<pre>
# Build the image
docker build -t arm_driver_ws:jazzy .

# Enable X11 access from Docker containers
xhost +local:docker

# Run the container with GUI support
docker run -it \
  --name arm_driver_dev \
  --env="DISPLAY=$DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  arm_driver_ws:jazzy
</pre>

### 4. Launch the Simulation nodes

Inside the container:

```bash
ros2 launch armada_bringup gazebo_move_group.launch.py
```

Alternatively run:
```bash
ros2 launch armada_bringup gazebo_move_group.launch.py workstation:=pedestal_workstation
```

This will generate a simulation with a very simple workstation and pedestal where the workstation is placed directly under the static depth camera for manipulation.

You will need to change the Fixed Frame in the Displays panel to panda_link0 for propert tf, add in a Motionplanning display for manual robot control, and a PointCloud2 display (search by topic for /rgbd_camera/depth_image/points) for visualizing the depth camera output in RViz.

## Troubleshooting: Reset Docker Environment

To fully reset Docker:

```bash
docker ps -q | xargs -r docker stop
docker ps -aq | xargs -r docker rm
docker images -q | xargs -r docker rmi
```

To remove just this image:

```bash
docker stop arm_driver_ws
docker rm arm_driver_ws
docker rmi flynnbm/arm_driver_ws:latest
```

## Future Improvements

- Add more robot embodiments
- Add further instructions for creating and spawning models into scene
- Add some images to the instructions to make setup more clear
