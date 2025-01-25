FROM nvidia/cuda:11.3.1-devel-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="2592509183@qq.com"
LABEL description="This is a Docker Image for DeepLSD build."

RUN apt update && apt upgrade -y --no-install-recommends && apt install libbz2-dev python3.8-distutils sqlite3 libsqlite3-dev python3-dev libffi-dev software-properties-common libceres-dev lsb-core libatlas-base-dev liblapack-dev libblas-dev ninja-build libgflags-dev libopencv-dev openssl libssl-dev libopencv-contrib-dev libarpack++2-dev libarpack2-dev libsuperlu-dev wget curl git nano build-essential cmake libgflags-dev libunwind-dev libeigen3-dev libgflags-dev libopencv-dev -y --no-install-recommends &&  add-apt-repository ppa:ubuntu-toolchain-r/test && apt install gcc-9 g++-9 -y --no-install-recommends && apt clean && apt autoclean

RUN wget https://www.sqlite.org/2018/sqlite-autoconf-3240000.tar.gz && tar -xvf sqlite-autoconf-3240000.tar.gz && cd sqlite-autoconf-3240000 && ./configure --prefix=/usr/local/sqlite && make -j4 && make install && cd .. && rm -rf sqlite-autoconf-3240000

RUN wget https://www.python.org/ftp/python/3.8.20/Python-3.8.20.tar.xz && tar -xvf Python-3.8.20.tar.xz && cd Python-3.8.20 && ./configure --enable-optimizations && make -j4 && make install && cd .. && rm -rf Python-3.8.20

RUN ln -s /usr/include/eigen3/Eigen /usr/include/Eigen && ln -s /usr/include/eigen3/unsupported /usr/include/unsupported

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 100 && update-alternatives --install /usr/bin/python python /usr/local/bin/python3.8 100 && update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.8 100

RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0.tar.gz && tar -xvf cmake-3.22.0.tar.gz && cd cmake-3.22.0 && ./bootstrap && make -j4 && make install && cd .. && rm -rf cmake-3.22.0 cmake-3.22.0.tar.gz

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt update && apt install -y --no-install-recommends python3-yaml ros-melodic-desktop-full python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc && apt clean && apt autoclean

RUN bash -c "source ~/.bashrc && . /opt/ros/melodic/setup.bash && mkdir -p ~/catkin_plvins/src && cd ~/catkin_plvins/ && catkin_make && source devel/setup.bash && cd src && git clone https://github.com/cnqiangfu/PL-VINS.git && cd PL-VINS/feature_tracker && rm CMakeLists.txt && wget https://raw.githubusercontent.com/Jiu-xiao/DeepLSD-Docker/refs/heads/main/CMakeLists.txt && cd ~/catkin_plvins && catkin_make"
