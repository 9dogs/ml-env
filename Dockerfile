FROM nvidia/cuda:10.2-base

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# Install system packages
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        apt-utils \
        ca-certificates \
        dialog \
        build-essential \
        vim \
        curl \
        wget \
        unzip \
        git \
        gnupg2 \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install miniconda3
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

# Add conda channels
RUN /opt/conda/bin/conda config --prepend channels conda-forge \
    && /opt/conda/bin/conda config --prepend channels pytorch

# Install packages to <base> conda environment
COPY environment.yml /tmp/conda-tmp/
RUN /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml

# Configure Jupyter
RUN jupyter notebook --allow-root --generate-config -y \
    && echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py \
    && jupyter contrib nbextension install --system \
    && jupyter nbextensions_configurator enable --system \
    && jupyter nbextension enable --py widgetsnbextension \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
    && jupyter labextension install @jupyterlab/toc

# Install additional packages
COPY additional_packages.txt /tmp/conda-tmp/
RUN pip install -r /tmp/conda-tmp/additional_packages.txt \
    && rm -rf /tmp/conda-tmp

# Install build dependencies for Vowpal Wabbit
# RUN apt-get --no-install-recommends -y install \
#     build-essential \
#     zlib1g-dev \
#     libboost-dev \
#     libboost-python-dev \
#     libboost-system-dev \
#     libboost-program-options-dev \
#     libboost-thread-dev \
#     libboost-test-dev \
#     automake \
#     cmake \
# && rm -rf /var/lib/apt/lists/*

# Install JDK (for Vowpal Wabbit)
# RUN apt-get -y install openjdk-8-jdk
# ENV CPLUS_INCLUDE_PATH=/usr/lib/jvm/java-8-openjdk-amd64/include/linux:/usr/lib/jvm/java-1.8.0-openjdk-amd64/include

# WORKDIR /build
# Build Vowpal Wabbit
# RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git && \
#    cd vowpal_wabbit && \
#    cmake . && \
#    make -j $(nproc) && \
#    make install
# Vowpal Wabbit Python wrapper
# RUN rm vowpal_wabbit/CMakeCache.txt && \
#    cd vowpal_wabbit/python && \
#    python3 setup.py install

# Build the latest XGBoost
# RUN git clone --recursive https://github.com/dmlc/xgboost && \
#    cd xgboost && \
#    make -j4
# XGBoost Python wrapper
# RUN cd xgboost/python-package && \
#    python3 setup.py install

# Build the latest LightGBM
# RUN git clone --recursive --depth 1 https://github.com/Microsoft/LightGBM && \
#    cd LightGBM && \
#    mkdir build && \
#    cd build && \
#    cmake .. && \
#    make -j $(nproc)
# LightGBM Python wrapper
# RUN cd LightGBM/python-package && \
#    python3 setup.py install

# Clean builds
# WORKDIR /
# RUN rm -rf /build

# Install Facebook Prophet
# RUN pip install --upgrade pystan cython
# RUN pip install --upgrade fbprophet

# Copy notebook configuration and entry-point files
COPY docker/notebook.json /root/.jupyter/nbconfig/notebook.json
COPY docker/entry-point.sh /entry-point.sh
RUN mkdir -p /home/user && \
    chmod a+x /entry-point.sh

WORKDIR /home/user
EXPOSE 8000

ENTRYPOINT ["/entry-point.sh"]
CMD ["shell"]
