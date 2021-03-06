#!/bin/bash
#set -e
#set -x

#if [ ! -d 'BGApipe' ]; then
#  mkdir BGApipe
#fi
#cd BGApipe

start_dir=$(pwd)

#ASSEMBLY
FASTP_VERSION=0.15.0
FASTQC_VERSION=0.11.7
PRINSEQ_VERSION=0.20.4
NXTRIM_VERSION=0.4.3
FILTERSPADES_VERSION=0.1
PRODIGAL_VERSION=2.6.2
SPADES_VERSION=3.12.0
PPLACER_VERSION=1.1.alpha17
HMMER_VERSION=3.2
CHECKM_DATA_VERSION=2015_01_16


#TRANSCRIPT DE
STAR_VERSION=2.6.0a
CUFFLINKS_VERSION=2.2.1
SALMON_VERSION=0.11.3
KALLISTO_VERSION=0.44.0
SAILFISH_VERSION=0.10.0

#ASSEMBLY_tools_download_url
FASTQC_DOWNLOAD_URL="https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip"
#FASTP_DOWNLOAD_URL="https://github.com/OpenGene/fastp.git"
FASTP_DOWNLOAD_URL="http://opengene.org/fastp/fastp"
NXTRIM_DOWNLOAD_URL="https://github.com/sequencing/NxTrim.git"
FILTERSPADES_DOWNLOAD_URL="https://github.com/sarangian/FilterSpades.git"
PRINSEQ_DOWNLOAD_URL="https://sourceforge.net/projects/prinseq/files/standalone/prinseq-lite-${PRINSEQ_VERSION}.tar.gz/download"
PRODIGAL_DOWNLOAD_URL="https://github.com/hyattpd/Prodigal/releases/download/v${PRODIGAL_VERSION}/prodigal.linux"
SPADES_DOWNLOAD_URL="http://cab.spbu.ru/files/release${SPADES_VERSION}/SPAdes-${SPADES_VERSION}-Linux.tar.gz"
PPLACER_DOWNLOAD_URL="https://github.com/matsen/pplacer/releases/download/v${PPLACER_VERSION}/pplacer-Linux-v${PPLACER_VERSION}.zip"
HMMER_DOWNLOAD_URL="http://eddylab.org/software/hmmer/hmmer-${HMMER_VERSION}.tar.gz"
CHECKM_DATA_DOWNLOAD_URL="https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_${CHECKM_DATA_VERSION}.tar.gz"

#transcript_DE_tools_download_url
STAR_DOWNLOAD_URL="https://github.com/alexdobin/STAR/archive/${STAR_VERSION}.tar.gz"
CUFFLINKS_DOWNLOAD_URL="http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-${CUFFLINKS_VERSION}.Linux_x86_64.tar.gz"
SALMON_DOWNLOAD_URL="https://github.com/COMBINE-lab/salmon/releases/download/v${SALMON_VERSION}/salmon-${SALMON_VERSION}-linux_x86_64.tar.gz"
KALLISTO_DOWNLOAD_URL="https://github.com/pachterlab/kallisto/releases/download/v${KALLISTO_VERSION}/kallisto_linux-v${KALLISTO_VERSION}.tar.gz"
SAILFISH_DOWNLOAD_URL="https://github.com/kingsfordgroup/sailfish/releases/download/v${SAILFISH_VERSION}/SailfishBeta-${SAILFISH_VERSION}_CentOS5.tar.gz"


#-----------------Checking dependancies, pre installed tools--------------------------
#----minal dependancies------
declare -a dpkglist=("gcc" "g++" "zlib1g-dev" "git-all" "python-docutils" "python-setuptools" "hmmer" "fastqc")
## now loop through the above array
for package in "${dpkglist[@]}"
do
  if [ $(dpkg-query -W -f='${Status}' $package 2>/dev/null | grep -c "ok installed") -eq 1 ];
then
  echo -e "\e[1;36m $package ...OK \e[0m";
else
  echo -e "\e[1;31m $package not in PATH \e[0m";
fi
done


#----packages from pip-------
declare -a piplist=("pip" "nanofilt" "luigi" "numpy" "scipy" "matplotlib" "pysam" "dendropy" "checkm" "HTSeq")

for package in "${piplist[@]}"
    do
      if python -c "import $package" &> /dev/null;
      then
          echo -e "\e[1;36m $package ...OK \e[0m";
      else
          echo -e "\e[1;31m $package not in PATH \e[0m";
      fi
   done

#----packages from git-hub and apt-get 
#......nxtrim..........
if which nxtrim >/dev/null; 
    then
    echo -e "\e[1;36m nxtrim ...OK \e[0m";
else
    echo -e "\e[1;31m nxtrim not in PATH \e[0m"
fi

#......spades.py.......
if which spades.py >/dev/null; 
    then
    echo -e "\e[1;36m spades ...OK \e[0m";
else
    echo -e "\e[1;31m spades not in PATH \e[0m"
fi

#......filterspades.py.......
if which filterSpades.py >/dev/null;
    then
    echo -e "\e[1;36m filterspades ...OK \e[0m";
else
    echo -e "\e[1;31m filterspades not in PATH \e[0m"
fi

#......pplacer.......
if which pplacer >/dev/null; 
    then
    echo -e "\e[1;36m pplacer ...OK \e[0m";
else
    echo -e "\e[1;31m pplacer not in PATH \e[0m"
fi

#......prodigal.......
if which pplacer >/dev/null; 
    then
    echo -e "\e[1;36m prodigal ...OK \e[0m";
else
    echo -e "\e[1;31m prodigal not in PATH \e[0m"
fi

#......fastp.......
if which fastp >/dev/null; 
    then
    echo -e "\e[1;36m fastp ...OK \e[0m";
else
    echo -e "\e[1;31m fastp not in PATH \e[0m"
fi

#.....STAR.........
if which STAR >/dev/null; 
    then
    echo -e "\e[1;36m STAR ...OK \e[0m";
else
    echo -e "\e[1;31m STAR not in PATH \e[0m"
fi

#.....cufflinks.........
if which cufflinks >/dev/null; 
    then
    echo -e "\e[1;36m cufflinks ...OK \e[0m";
else
    echo -e "\e[1;31m cufflinks not in PATH \e[0m"
fi

#.....salmon.........
if which salmon >/dev/null; 
    then
    echo -e "\e[1;36m salmon ...OK \e[0m";
else
    echo -e "\e[1;31m salmon not in PATH \e[0m"
fi

#.....kallisto.........
if which kallisto >/dev/null; 
    then
    echo -e "\e[1;36m kallisto ...OK \e[0m";
else
    echo -e "\e[1;31m kallisto not in PATH \e[0m"
fi

#.....sailfish.........
if which sailfish >/dev/null; 
    then
    echo -e "\e[1;36m sailfish ...OK \e[0m";
else
    echo -e "\e[1;31m sailfish not in PATH \e[0m"
fi

#####

# Make an install location
if [ ! -d 'external' ]; then
  mkdir external
fi
cd external
build_dir=$(pwd)

# DOWNLOAD EXTERNAL TOOLS THROUGH WGET
download () {
  url=$1
  download_location=$2

  if [ -e $download_location ]; then
    echo -e "\e[1;36m Skipping download of $url, $download_location already exists \e[0m"
  else
    echo -e "\e[1;31m Downloading $url to $download_location \e[0m"
    wget $url -O $download_location
  fi
}

# DOWNLOAD EXTERNAL TOOLS FROM GITHUB USING GIT CLONE 
fetch () {
  url=$1
  download_location=$2

  if [ -e $download_location ]; then
    echo -e "\e[1;36m Skipping download of $url, $download_location already exists  \e[0m"
  else
    echo -e "\e[1;31m Downloading $url to $download_location \e[0m"
    git clone $url $download_location
  fi
}

# INSTALLING TOOLS FROM PIP

function pip_install {
  pip install "$@"
  if [ $? -ne 0 ]; then
    echo "could not install $p - abort"
    exit 1
  fi
}

# INSTALLING TOOLS USING APT-GET

function apt_install {
  sudo apt-get -y install $1
  if [ $? -ne 0 ]; then
    echo "could not install $1 - abort"
    exit 1
  fi
}

#-----------------------------Check and install minimal dependancies-------------------------
declare -a dpkglist=("gcc" "g++" "zlib1g-dev" "git-all" "python-docutils" "python-setuptools" "hmmer")

## now loop through the above array
for package in "${dpkglist[@]}"
do
  if [ $(dpkg-query -W -f='${Status}' $package 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo -e "installing $package"
  apt_install $package
fi

done

# ------------------------Check and install tools from pip --------------------------------

declare -a piplist=("pip" "nanofilt" "luigi" "numpy" "scipy" "matplotlib" "pysam" "dendropy" "HTSeq")

for package in "${piplist[@]}"
do
  if python -c "import $package" &> /dev/null;
then
  echo -e "$package in PATH";
else
  echo -e "\e[1;36m Installing $package  \e[0m"
  pip_install $package
fi

done


#Check CheckM
if python -c "import checkm" &> /dev/null; then
    echo 'CheckM ...OK'
else
    echo -e "\e[1;31m Installing CheckM  \e[0m"
    pip_install checkm-genome --upgrade --no-deps
fi

# --------------- -------------FastQC ----------------------------------------------
if which fastqc >/dev/null; then
    echo -e "FASTQC ...OK";

else
    cd $build_dir
    download $FASTQC_DOWNLOAD_URL "fastqc_v${FASTQC_VERSION}.zip"
    unzip fastqc_v${FASTQC_VERSION}.zip
    fastqc_dir="$build_dir/FastQC"
    cd $fastqc_dir
    chmod 755 fastqc
fi

# ------------- ---------------NxTrim -----------------------------------------------
if which nxtrim >/dev/null; then
    echo -e "nxtrim in PATH";

else
    fetch $NXTRIM_DOWNLOAD_URL $build_dir/"NxTrim-${NXTRIM_VERSION}"
    nxtrim_dir=$build_dir/"NxTrim-${NXTRIM_VERSION}"
    cd $nxtrim_dir
    make
fi

# --------------- -------------prinseq-----------------------------------------------
if which prinseq >/dev/null; then
    echo -e "prinseq in PATH";

else
    cd $build_dir
    download $PRINSEQ_DOWNLOAD_URL "prinseq-lite-${PRINSEQ_VERSION}.tar.gz"
    prinseq_dir="$build_dir/prinseq-lite-${PRINSEQ_VERSION}"
    tar -zxf prinseq-lite-${PRINSEQ_VERSION}.tar.gz
    cd $prinseq_dir
    chmod 755 prinseq-lite.pl
    ln prinseq-lite.pl prinseq
fi

# --------------- -------------spades -----------------------------------------------
if which spades.py >/dev/null; then
    echo -e "spades in PATH";

else
    cd $build_dir
    download $SPADES_DOWNLOAD_URL "SPAdes-${SPADES_VERSION}-Linux.tar.gz"
    spades_dir="$build_dir/SPAdes-${SPADES_VERSION}-Linux/bin"
    tar -zxf SPAdes-${SPADES_VERSION}-Linux.tar.gz

fi

# ------------- ---------------filterspades -----------------------------------------------
if which filterSpades.py >/dev/null; then
    echo -e "filterspades in PATH";

else
    fetch $FILTERSPADES_DOWNLOAD_URL $build_dir/"FilterSPAdes-${FILTERSPADES_VERSION}"
    filterspades_dir=$build_dir/"FilterSPAdes-${FILTERSPADES_VERSION}"
fi

# --------------- -------------pplacer ----------------------------------------------
if which pplacer >/dev/null; then
    echo -e "pplacer in PATH";
else
    cd $build_dir
    download $PPLACER_DOWNLOAD_URL "pplacer-Linux-v${PPLACER_VERSION}.zip"
    pplacer_dir="$build_dir/pplacer-Linux-v${PPLACER_VERSION}"
    unzip pplacer-Linux-v${PPLACER_VERSION}.zip &> /dev/null
fi

# --------------- -------------prodigal ---------------------------------------------
if which prodigal >/dev/null; then
    echo -e "prodigal in PATH";

else

    cd $build_dir
    prodigal_dir="$build_dir/prodigal-${PRODIGAL_VERSION}"
       if [ ! -d "$prodigal_dir" ]; then
           mkdir $prodigal_dir
       fi
       cd $prodigal_dir
       download $PRODIGAL_DOWNLOAD_URL prodigal
       chmod 755 prodigal
fi
#------------------------------fastp-------------------------------------------------
if which fastp >/dev/null; then
    echo -e "fastp in PATH";

else
    cd $build_dir
       fastp_dir="$build_dir/fastp-${FASTP_VERSION}"
       if [ ! -d "$fastp_dir" ]; then
           mkdir $fastp_dir
       fi
       cd $fastp_dir
       download $FASTP_DOWNLOAD_URL fastp
       chmod 755 fastp
fi

# -----------------------------hmmer ------------------------------------------------
#download $HMMER_DOWNLOAD_URL $build_dir/"hmmer-${HMMER_VERSION}.tar.gz"
#cd $build_dir
#tar -xvzf "hmmer-${HMMER_VERSION}.tar.gz"
#hmmer_inst="$build_dir/hmmer-${HMMER_VERSION}"
#cd $hmmer_inst
#./configure
#make
#hmmer_dir="$hmmer_inst/src"

# ----------------------------CheckData --------------------------------------------
if [ $(checkm lineage_wf 2>/dev/null | grep -c "CheckM cannot run without a valid data folder") -eq 1 ];
then
    echo -e "\e[1;31m Downloding CheckM Data from $CHECKM_DATA_DOWNLOAD_URL \e[0m"
    cd $build_dir
    checkm_data_dir="$build_dir/checkm_data_${CHECKM_DATA_VERSION}"
        if [ ! -d "$checkm_data_dir" ]; then
            mkdir $checkm_data_dir
        fi

        cd $checkm_data_dir
        download $CHECKM_DATA_DOWNLOAD_URL $checkm_data_dir/"checkm_data_${CHECKM_DATA_VERSION}.tar.gz"

        tar -xvzf "checkm_data_${CHECKM_DATA_VERSION}.tar.gz" &> /dev/null
        echo -e "\e[1;31m Setting CheckM data directory to $checkm_data_dir\e[0m"
        sudo checkm data setRoot $checkm_data_dir
else 
    echo -e "\e[1;36m CheckM Data already downloaded and data root already set \e[0m"

fi



#-------------------------STAR Aligner----------------------------------------------
if which STAR >/dev/null; then
    echo -e "STAR ....installed";

else
    cd $build_dir
    download $STAR_DOWNLOAD_URL "STAR-${STAR_VERSION}-Linux.tar.gz"
    star_dir="$build_dir/STAR-${STAR_VERSION}/bin/Linux_x86_64"
    tar -xvzf STAR-${STAR_VERSION}-Linux.tar.gz &> /dev/null

fi


#-------------------------Cufflinks----------------------------------------------
if which STAR >/dev/null; then
    echo -e "cufflink ....installed";

else
    cd $build_dir
    download $CUFFLINKS_DOWNLOAD_URL "cufflinks-${CUFFLINKS_VERSION}.Linux_x86_64.tar.gz"
    cufflinks_dir="$build_dir/cufflinks-${CUFFLINKS_VERSION}.Linux_x86_64"
    tar -xvzf cufflinks-${CUFFLINKS_VERSION}.Linux_x86_64.tar.gz &> /dev/null

fi

#-------------------------salmon----------------------------------------------
if which salmon >/dev/null; then
    echo -e "salmon ....installed";

else
    cd $build_dir
    download $SALMON_DOWNLOAD_URL "salmon-${SALMON_VERSION}-linux_x86_64.tar.gz"
    salmon_dir="$build_dir/salmon-${SALMON_VERSION}-linux_x86_64/bin"
    tar -xvzf salmon-${SALMON_VERSION}-linux_x86_64.tar.gz &> /dev/null

fi

#-------------------------kallisto----------------------------------------------
if which kallisto >/dev/null; then
    echo -e "kallisto ....installed";

else
    cd $build_dir
    download $KALLISTO_DOWNLOAD_URL "kallisto_linux-v${KALLISTO_VERSION}.tar.gz"
    kallisto_dir="$build_dir/kallisto_linux-v${KALLISTO_VERSION}"
    tar -xvzf kallisto_linux-v${KALLISTO_VERSION}.tar.gz &> /dev/null

fi

#-------------------------sailfish----------------------------------------------
if which sailfish >/dev/null; then
    echo -e "salifish ....installed";

else
    cd $build_dir
    download $SAILFISH_DOWNLOAD_URL "SailfishBeta-${SAILFISH_VERSION}_CentOS5.tar.gz"
    sailfish_dir="$build_dir/SailfishBeta-${SAILFISH_VERSION}_CentOS5/bin"
    sailfish_lib="$build_dir/SailfishBeta-${SAILFISH_VERSION}_CentOS5/lib"
    tar -xvzf SailfishBeta-${SAILFISH_VERSION}_CentOS5.tar.gz &> /dev/null
    echo '#Added by CGPipe Installer' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH='$sailfish_lib >> ~/.bashrc

fi

#-----------------------------UPDATE PATH-------------------------------------------
echo '# Added by CGPipe Installer' >> ~/.bashrc
cd $build_dir
update_path ()
{
    new_dir=$1

    if [[ "$PATH" =~ (^|:)"${new_dir}"(:|$) ]]
    then
        return 0
    fi
    echo 'export PATH=$PATH:'$new_dir >> ~/.bashrc

}
############# 

update_path ${fastp_dir}
update_path ${fastqc_dir}
update_path ${prinseq_dir}
update_path ${nxtrim_dir}
update_path ${spades_dir}
update_path ${filterspades_dir}
update_path ${pplacer_dir}
update_path ${prodigal_dir}
update_path ${star_dir}
update_path ${cufflinks_dir}
update_path ${salmon_dir}
update_path ${kallisto_dir}
update_path ${sailfish_dir}
#--------------------------SOURCE .bashrc-------------------------------------------

echo 'BGAPipe external tools installed at' $start_dir
echo -e "Run \e[1;36m source ~/.bashrc \e[0m to update path"

#PATH=$(getconf PATH)
#source /etc/environment














