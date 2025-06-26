FROM ros:jazzy-ros-base

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# Install basic tools and dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3-colcon-common-extensions \
    python3-vcstool \
    python3-pip \
    ros-jazzy-rviz2 \
    ros-jazzy-xacro \
    ros-jazzy-ros-gz \
    ros-jazzy-moveit \ 
    ros-jazzy-controller-manager \
    ros-jazzy-ros2-control \
    ros-jazzy-gz-ros2-control \
    ros-jazzy-position-controllers \
    ros-jazzy-joint-trajectory-controller \
    ros-jazzy-gripper-controllers \
    && rm -rf /var/lib/apt/lists/*

# Create workspace
RUN mkdir -p /root/arm_driver_ws/src
WORKDIR /root/arm_driver_ws/src

# Clone repositories
RUN git clone https://github.com/uml-robotics/armada_ros2.git && \
    git clone https://github.com/flynnbm/panda_ros2.git

# Build the workspace
WORKDIR /root/arm_driver_ws/
RUN . /opt/ros/jazzy/setup.sh && \
    colcon build

# Source setup on container start
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc && \
    echo "source /root/arm_driver_ws/install/setup.bash" >> ~/.bashrc

# Default command
CMD ["bash"]