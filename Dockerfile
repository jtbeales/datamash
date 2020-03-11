FROM bioconductor/bioconductor_docker:RELEASE_3_10

MAINTAINER Jeremy Beales <beales.jeremy@gmail.com>

LABEL Image for datamash

#some basic tools
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential \
    bzip2 \
    curl \
    csh \
    default-jdk \
    default-jre \
    emacs \
    emacs-goodies-el \
    ess \
    evince \
    g++ \
    gawk \
    git \
    grep \
    less \
    libcurl4-openssl-dev \
    libpng-dev \
    librsvg2-bin \
    libssl-dev \
    libxml2-dev \
    lsof \
    make \
    man \
    ncurses-dev \
    nodejs \
    openssh-client \
    pdftk \
    pkg-config \
    python \
    rsync \
    screen \
    tabix \
    unzip \
    wget \
    zip \
    vim \
    zlib1g-dev


RUN apt-get update && apt-get install -y \
    r-cran-xml \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    ghostscript \
    datamash

ENV PATH=pkg-config:$PATH

RUN install2.r --error --deps TRUE \
    doParallel \
    && rm -rf /tmp/downloaded_packages/

RUN Rscript -e 'BiocManager::install(c("Biobase", "biomaRt", "RnBeads", "RnBeads.hg38", "limma", "edgeR", "DESeq2", "tximport", "tidyverse"))'


#################################
# Python 2 and 3, plus packages

# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

# Install conda
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    curl -s https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh -o miniconda.sh && \
    /bin/bash miniconda.sh -f -b -p $CONDA_DIR && \
    rm miniconda.sh && \
    $CONDA_DIR/bin/conda config --system --add channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    conda clean -tipsy

# Install Python 3 packages available through pip
RUN conda install --yes 'pip' && \
    conda clean -tipsy && \
    #dependencies sometimes get weird - installing each on it's own line seems to help
    pip install numpy==1.13.0 && \
    pip install scipy==0.19.0 && \
    pip install cruzdb==0.5.6 && \
    pip install cython==0.25.2 && \
    pip install pyensembl==1.1.0 && \
    pip install pyfaidx==0.4.9.2 && \
    pip install pybedtools==0.7.10 && \
    pip install cyvcf2==0.7.4 && \
    pip install intervaltree_bio==1.0.1 && \
    pip install pandas==0.20.2 && \
    pip install scipy==0.19.0 && \
    pip install pysam==0.11.2.2 && \
    pip install seaborn==0.7.1 && \
    pip install scikit-learn==0.18.2 && \
    pip install openpyxl==2.4.8 && \
    pip install svviz==1.6.1

# Install Python 2
RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 'pip' && \
    conda clean -tipsy && \
    /bin/bash -c "source activate python2 && \
    #dependencies sometimes get weird - installing each on it's own line seems to help
    pip install numpy==1.13.0 && \
    pip install scipy==0.19.0 && \
    pip install cruzdb==0.5.6 && \
    pip install cython==0.25.2 && \
    pip install pyensembl==1.1.0 && \
    pip install pyfaidx==0.4.9.2 && \
    pip install pybedtools==0.7.10 && \
    pip install cyvcf2==0.7.4 && \
    pip install intervaltree_bio==1.0.1 && \
    pip install pandas==0.20.2 && \
    pip install scipy==0.19.0 && \
    pip install pysam==0.11.2.2 && \
    pip install seaborn==0.7.1 && \
    pip install scikit-learn==0.18.2 && \
    pip install openpyxl==2.4.8 && \
    source deactivate"
