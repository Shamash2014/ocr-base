FROM python:3.6
MAINTAINER Roman Myronov <warp.buddhist@gmail.com>

RUN apt-get update && \
        apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        tesseract-ocr \
        tesseract-ocr-eng \
        libopencv-dev \
        libtesseract-dev \
        libleptonica-dev \
        pkg-config \
        libcv-dev \
        python-opencv \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libavformat-dev \
        autoconf automake libtool \
        autoconf-archive \
        pkg-config \
        libpng12-dev \
        libjpeg62-turbo-dev \
        libtiff5-dev \
        zlib1g-dev \
        libpq-dev

RUN pip install numpy scikit-image

WORKDIR /
RUN wget https://github.com/Itseez/opencv/archive/3.2.0.zip \
&& unzip 3.2.0.zip \
&& mkdir /opencv-3.2.0/cmake_binary \
&& cd /opencv-3.2.0/cmake_binary \
&& cmake -DBUILD_TIFF=ON \
  -DBUILD_opencv_java=OFF \
  -DWITH_CUDA=OFF \
  -DENABLE_AVX=ON \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=$(python3.6 -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=$(which python3.6) \
  -DPYTHON_INCLUDE_DIR=$(python3.6 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python3.6 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. \
&& make install \
&& rm /3.2.0.zip \
&& rm -r /opencv-3.2.0

RUN wget http://www.leptonica.com/source/leptonica-1.74.1.tar.gz \
  && tar -xvf leptonica-1.74.1.tar.gz \
  && cd leptonica-1.74.1 \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && rm -r leptonica-1.74.1 \
  && rm -r leptonica-1.74.1.tar.gz

RUN git clone https://github.com/tesseract-ocr/tesseract.git \
  && cd tesseract \
  && ./autogen.sh \
  && ./configure --enable-debug \
  && LDFLAGS="-L/usr/local/lib" CFLAGS="-I/usr/local/include" make \
  && make install \
  && ldconfig \
  && cd .. \
  && rm -r tesseract

RUN pip install Cython flake8 pep8 tesserocr --upgrade

RUN mkdir -p /app
WORKDIR /app
