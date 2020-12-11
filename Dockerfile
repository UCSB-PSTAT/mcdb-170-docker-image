# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM jupyter/scipy-notebook:63d0df23b673

LABEL maintainer="Patrick Windmiller <sysadmin@pstat.ucsb.edu>"

USER root

# Install re2 (fb-re2)
RUN git clone https://code.googlesource.com/re2 /tmp/re2 && \
    cd /tmp/re2 && \
    make CFLAGS='-fPIC -c -Wall -Wno-sign-compare -O3 -g -I.' && \
    make test && \
    make install && \
    make testinstall && \
    ldconfig && \
    pip install -U fb-re2

USER $NB_UID

# Prerequisites for MatPlotLib
RUN conda install -c conda-forge ipympl==0.5.8 && \
    conda install -c conda-forge nodejs

# Install MatplotLib
RUN jupyter labextension install jupyter-matplotlib@0.7.4

# Required packages for mcdb-170
RUN conda install -c conda-forge spacy && \
    conda install --quiet -y nltk && \
    conda install --quiet -y mplcursors && \
    pip install biopython && \
    pip install shutils && \
    pip install pymc3 && \
    pip install TensorFlow && \
    pip install datetime
    
# Adding language model to Spacy
RUN python -m spacy download en

RUN python -m spacy download en_core_web_md

RUN jupyter lab build
