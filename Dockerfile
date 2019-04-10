FROM continuumio/miniconda3

# System packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    vim \
    curl \
    unzip \
    git \
&& rm -rf /var/lib/apt/lists/*

# Build dependencies
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

# Main Python packages
RUN conda install \
    # Math base
	numpy \
    scipy \
    pandas \
    dask \
	# Notebooks
    jupyter \
	jupyterlab \
	ipywidgets \
	# Visialization
	matplotlib \
	seaborn \
    plotly \
	pydot \
    pydotplus \
    graphviz \
    bokeh \
	# Machine Learning
	scikit-learn \
	tensorflow \
	keras \
	lightgbm \
	# Statistics
    statsmodels \
    # Text
    gensim \
    nltk \
    # Utils
	tqdm \
    joblib \
    pillow \
    pytest \
    nodejs

# Packages from different conda repos
RUN conda install -c conda-forge \
    scikit-surprise
# PyTorch [CPU]
RUN conda install -c pytorch \
    pytorch-cpu \
    torchvision-cpu

# Packages absent in conda
RUN pip install --upgrade \
    catboost \
    watermark \
    geopy \
    jupyter-contrib-nbextensions \
    jupyter-nbextensions-configurator  

# Jupyter configs
RUN jupyter notebook --allow-root --generate-config -y && \
    echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py && \
    jupyter contrib nbextension install --system && \
    jupyter nbextensions_configurator enable --system && \
	jupyter nbextension enable --py widgetsnbextension && \
	jupyter labextension install @jupyter-widgets/jupyterlab-manager

# JDK
# RUN apt-get -y install openjdk-8-jdk
# ENV CPLUS_INCLUDE_PATH=/usr/lib/jvm/java-8-openjdk-amd64/include/linux:/usr/lib/jvm/java-1.8.0-openjdk-amd64/include

# WORKDIR /build
# Vowpal Wabbit
# RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git && \
#    cd vowpal_wabbit && \
#    cmake . && \
#    make -j $(nproc) && \
#    make install
# Vowpal Wabbit Python wrapper
# RUN rm vowpal_wabbit/CMakeCache.txt && \
#    cd vowpal_wabbit/python && \
#    python3 setup.py install

# XGBoost
# RUN git clone --recursive https://github.com/dmlc/xgboost && \
#    cd xgboost && \
#    make -j4 
# XGBoost Python wrapper
# RUN cd xgboost/python-package && \
#    python3 setup.py install

# LightGBM
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

# Facebook Prophet
# RUN pip install --upgrade pystan cython
# RUN pip install --upgrade fbprophet

# Additional Python modules
COPY packages.txt /packages.txt
RUN pip install -r /packages.txt

COPY docker/notebook.json /root/.jupyter/nbconfig/notebook.json
COPY docker/entry-point.sh /entry-point.sh
RUN mkdir -p /home/user && \
    chmod a+x /entry-point.sh

WORKDIR /home/user
EXPOSE 4545

ENTRYPOINT ["/entry-point.sh"]
CMD ["shell"]
