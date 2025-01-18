FROM nvidia/cuda:11.3.1-devel-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="2592509183@qq.com"
LABEL description="This is a Docker Image for DeepLSD build."

RUN apt update && apt upgrade -y --no-install-recommends && apt install python3-distutils software-properties-common python3-defusedxml python3-dev python3.8-dev python-dev libceres-dev lsb-core libatlas-base-dev liblapack-dev libblas-dev ninja-build python3.8-dev libgflags-dev libopencv-dev openssl libssl-dev libopencv-contrib-dev libarpack++2-dev libarpack2-dev libsuperlu-dev wget curl git nano build-essential cmake libgflags-dev libunwind-dev libeigen3-dev libgflags-dev libopencv-dev -y --no-install-recommends &&  add-apt-repository ppa:ubuntu-toolchain-r/test && apt install gcc-9 g++-9 -y --no-install-recommends && apt clean && apt autoclean

# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_22.11.1-1-Linux-x86_64.sh && bash Miniconda3-py38_22.11.1-1-Linux-x86_64.sh -b && rm Miniconda3-py38_22.11.1-1-Linux-x86_64.sh

RUN ln -s /usr/include/eigen3/Eigen /usr/include/Eigen && ln -s /usr/include/eigen3/unsupported /usr/include/unsupported

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 100 && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 100 && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3.8 get-pip.py && update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.8 100

RUN pip install torch==1.12.0+cu113 -f https://download.pytorch.org/whl/torch_stable.html && pip install torchvision==0.13.0 && rm -rf ~/.cache/pip

RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0.tar.gz && tar -xvf cmake-3.22.0.tar.gz && cd cmake-3.22.0 && ./bootstrap && make -j4 && make install && cd .. && rm -rf cmake-3.22.0 cmake-3.22.0.tar.gz

RUN wget https://github.com/google/glog/archive/refs/tags/v0.4.0.tar.gz && tar -xvf v0.4.0.tar.gz && cd glog-0.4.0 && cmake . -DBUILD_SHARED_LIBS=ON -DWITH_GFLAGS=ON && make -j4 && make install && cd .. && rm -rf glog-0.4.0 v0.4.0.tar.gz

RUN rm -rf /usr/local/lib/python3.8/dist-packages/pyparsing && pip install defusedxml==0.8.0rc1 rospkg pybind11 catkin_pkg joblib pyparsing==2.4.7 && git clone --recursive https://github.com/cvg/DeepLSD.git --depth=1 && cd DeepLSD && git submodule init && git submodule update && pip install -r requirements.txt && pip install -r requirements.txt && rm -rf ~/.cache/pip

RUN bash -c "cd DeepLSD && cd third_party/progressive-x/graph-cut-ransac/build; cmake ..; make -j8" && bash -c "cd DeepLSD && cd third_party/progressive-x/build; cmake ..; make -j8;" && bash -c "cd DeepLSD && pip install -e third_party/progressive-x" && rm -rf ~/.cache/pip

RUN cd DeepLSD && bash -c "pip install -e line_refinement" && bash -c "pip install -e third_party/homography_est" && bash -c "pip install -e third_party/pytlbd" && bash -c "pip install -e third_party/pytlsd" && bash -c "pip install -e ." && bash -c "pip install kornia==0.6 --no-deps" && rm -rf ~/.cache/pip

RUN echo "cd /DeepLSD/third_party/afm_lib/afm_op; python3 setup.py build_ext --inplace; ; rm -rf build; cd ..; pip install -e ." > ~/afm_install.sh && chmod +x ~/afm_install.sh

RUN pip install pytlsd && cd DeepLSD && mkdir weights && wget https://cvg-data.inf.ethz.ch/DeepLSD/deeplsd_wireframe.tar -O weights/deeplsd_wireframe.tar && wget https://cvg-data.inf.ethz.ch/DeepLSD/deeplsd_md.tar -O weights/deeplsd_md.tar

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt update && apt install -y --no-install-recommends python3-yaml ros-melodic-desktop-full python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc && apt clean && apt autoclean
