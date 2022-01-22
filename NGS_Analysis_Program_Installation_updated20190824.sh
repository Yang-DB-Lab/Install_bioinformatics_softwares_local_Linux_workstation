#!/bin/bash -i
# This '-i' option will make the script interactive; 
# Then " soure ~/.bashrc " will work.
# Withouth this setting, this " soure ~/.bashrc " 
#                             has no effect. 

# Or the script can be run from terminal with '-i' option:
#      bash -i Bulk_RNA_Seq_Program_Installation.sh

# This scipt install all programs for bulk RNA-Seq
# The programs will be installed are:
# Fastqc
# MultiQC(via conda; conda pre-installation required


mkdir -p /home/guang/bio_softwares
# Program installation folder

mkdir -p /home/guang/temp_biosoftware_download_install
# A temp folder to download biosoftware packages.
# After finish installation this folder together with the
# installation packages will be deleted.
cd /home/guang/temp_biosoftware_download_install

##*************** Install SRAtoolkit ******************##
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -xvzf sratoolkit.current-ubuntu64.tar.gz #Current(20190813) version is 2.9.6.1 
mv sratoolkit.2.9.6-1-ubuntu64 /home/guang/bio_softwares/
cd /home/guang/bio_softwares/sratoolkit.2.9.6-1-ubuntu64/bin
mkdir -p /data/guang/ncbi/public # Folder for downloaded files by sratoolkit
./vdb-config -i # change configuration of sratoolkit 
                # set download folder to /data/guang/ncbi/public
echo 'export PATH="/home/guang/bio_softwares/sratoolkit.2.9.6-1-ubuntu64/bin:$PATH"' >> ~/.bashrc
echo 'sratoolkit.2.9.6-1-ubuntu64 installation finished.'
echo 'fastq-dump can be used to download GEO data from anywhere.'
##***************************************************************##


##******** Install Oracle Java from PPA ************##
sudo add-apt-repository ppa:linuxuprising/java
sudo apt update
sudo apt install oracle-java12-installer
sudo apt install oracle-java12-set-default
#NOTE: Use tab to set 'OK' and 'Yes' while installing Oracle Java JDK12

########### Install tools for quality control #################
##********** Install FastQC v0.11.8 *****************##
cd /home/guang/temp_biosoftware_download_install
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip
unzip fastqc_v0.11.8.zip -d ./fastqc_v0.11.8
chmod 755 ./fastqc_v0.11.8/FastQC/fastqc
cp -r ./fastqc_v0.11.8 /home/guang/bio_softwares
echo 'export PATH="/home/guang/bio_softwares/fastqc_v0.11.8/FastQC:$PATH"' >> ~/.bashrc

echo "fastqc installation finished"
echo 'fastqc can be called by "fastqc" from anywhere' 
# Add fastqc installation directory to system $PATH by modify ~/.bashrc file
##**************************************************##

##********* Install MultiQC using conda *********##
## NOTE:
##       There are several packages will be installed via conda:
##       multiqc:  requires Python 2.7+ or Python 3.4+
##       Slamdunk: requires Python 2.7+
##       macs2:    requires Python 2.7+
##  
##       So a Python2.7 environment named "NGS_Py2.7" will be created to fulfill
##       requirement of all packages mentioned above.
##       MultiQC will be installed under this Python 2.7 envrionment "NGS_Py2.7"
conda config --add channels conda-forge
conda config --add channels defaults
conda config --add channels r
conda config --add channels bioconda
conda create --name NGS_Py2.7 python=2.7
conda install --name NGS_Py2.7 multiqc
# Create a new environment  named NGS_Py2.7
# and install multiqc in this environment.
# Use
#    source activate NGS_Py2.7
# to activate the environment ‘NGS_Py2.7’
# Then MultiQC can be called by
#    multiqc
# To deactivate an active environment, use: source deactivate
echo 'MultiQC is installed to "NGS_Py2.7" environment using conda'
echo 'MultiQC can be called by:'
echo 'source activate NGS_Py2.7;mutiqc'
echo 'De-activate "NGS_Py2.7" environment by "conda deactivate" '
##**********************************************##

##********** Install Trimmomatic ***********##
cd /home/guang/temp_biosoftware_download_install
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
unzip Trimmomatic-0.39.zip
rm Trimmomatic-0.39.zip
mv Trimmomatic-0.39/ /home/guang/bio_softwares
# Add Trimmomatic directory to system $PATH
echo 'Trimmomatic v0.39 installation finished'
echo 'Trimmomatic can be called by:'
echo 'java -jar /home/guang/bio_softwares/Trimmomatic-0.39/trimmomatic-0.39.jar'
##*****************************************##
#########################################################
#########################################################

######### Part Install RNA-STAR and generate genome reference #######
## *********************Install RNA-STAR v2.7.1a *************##
## Updated 20190810, now we have v2.7.1a
cd /home/guang/temp_biosoftware_download_install
wget https://github.com/alexdobin/STAR/archive/2.7.1a.tar.gz
tar -xzvf 2.7.1a.tar.gz 
mv STAR-2.7.1a/ /home/guang/bio_softwares/RNA_STAR_v2.7.1a
echo 'export PATH="/home/guang/bio_softwares/RNA_STAR_v2.7.1a/bin/Linux_x86_64:$PATH"' >> ~/.bashrc
echo 'RNA_STAR_v2.7.1a installation finished.'
echo 'RNA_STAR can be called by "STAR" from anywhere.'
##***********************************************************##

## **** Download reference genome and gtf annotation files ****##
## Updated 20190810, release97 came out on 20190624
## Download all these files into /data/ directory
mkdir -p /data/guang/mouse_genome
cd /data/guang/mouse_genome
wget ftp://ftp.ensembl.org/pub/release-97/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz
## NOTE: Download the primary_assembly.fa.gz file, NOT "toplevel" file based on STAR manual
##       Using "toplevel" would just create many more duplicates which would be further discarded. 
## NOTE2: Use ftp site to increase download speed!!
gunzip Mus_musculus.GRCm38.dna.primary_assembly.fa.gz
mv Mus_musculus.GRCm38.dna.primary_assembly.fa Mus_musculus.GRCm38.97.dna.primary_assembly.fa

wget ftp://ftp.ensembl.org/pub/release-97/gtf/mus_musculus/Mus_musculus.GRCm38.97.gtf.gz
gunzip Mus_musculus.GRCm38.97.gtf.gz
##***********************************************************##

##***************** Build STAR mouse genome index ***************##
# source ~/.bashrc 
#If '-i' is not include in the head of the script
#   source ~/.bashrc will do nothing.
# Still not sure, whether '-i' can really solve the problem.

# sudo chown guang:guang /data 
## make sure you can work under /data folder
mkdir -p /data/guang/mouse_genome_index/RNA_STAR_overhang100
# Use the full path of STAR to make sure it will always work!!!
/home/guang/bio_softwares/RNA_STAR_v2.7.1a/bin/Linux_x86_64/STAR --runMode genomeGenerate \
--runThreadN 6 \
--genomeDir /data/guang/mouse_genome_index/RNA_STAR_overhang100 \
--genomeFastaFiles /data/guang/mouse_genome/Mus_musculus.GRCm38.97.dna.primary_assembly.fa \
--sjdbGTFfile /data/guang/mouse_genome/Mus_musculus.GRCm38.97.gtf \
--sjdbOverhang 100
##**************************************************************##

##****************** Install(compile) samtools v1.9 *********************##
cd /home/guang/temp_biosoftware_download_install
wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
mv ./samtools-1.9.tar.bz2 /home/guang/bio_softwares
cd /home/guang/bio_softwares
tar -xjvf ./samtools-1.9.tar.bz2
cd samtools-1.9/
./configure
make
#make install
rm /home/guang/bio_softwares/samtools-1.9.tar.bz2
echo 'export PATH="/home/guang/bio_softwares/samtools-1.9:$PATH"' >> ~/.bashrc
echo 'samtools v1.9 is compiled(installed)'
echo 'It can be called from anywhere by "samtools" '
##*******************************************************************##

##************************* Install picard *************************##
## Update 20190810, picard v2.20.5 released!
cd /home/guang/temp_biosoftware_download_install
wget https://github.com/broadinstitute/picard/releases/download/2.20.5/picard.jar
mv ./picard.jar /home/guang/bio_softwares
echo 'picard.jar is installed'
echo 'Picard can be called by "java -jar /home/guang/bio_softwares/picard.jar" '
##******************************************************************##

########################################################################
## Part 3 Install StringTie to extract gene expression table ##
##************************ Install StringTie ************************##
## Update 20190810, v2.0 released on 7/30/2019
cd /home/guang/temp_biosoftware_download_install/
wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-2.0.Linux_x86_64.tar.gz
tar -xzvf stringtie-2.0.Linux_x86_64.tar.gz 
mv stringtie-2.0.Linux_x86_64 /home/guang/bio_softwares/
echo 'export PATH="/home/guang/bio_softwares/stringtie-2.0.Linux_x86_64:$PATH"' >> ~/.bashrc
echo 'StringTie installation finished'
echo 'StringTie can be called by "stringtie" from anywhere'
##******************************************************************##


## Updated 20190812
##*********** Install packages for ATAC-seq analysis *************##

##********* Folders for softwares and for package downloading ********##
mkdir -p /home/guang/bio_softwares
# Program installation folder

mkdir -p /home/guang/temp_biosoftware_download_install
# A temp folder to download biosoftware packages.
# After finish installation this folder together with the
# installation packages will be deleted.
cd /home/guang/temp_biosoftware_download_install
##********************************************************************##

##******************* Install Bowtie2 from binary *******************##
wget https://newcontinuum.dl.sourceforge.net/project/bowtie-bio/bowtie2/2.3.5.1/bowtie2-2.3.5.1-linux-x86_64.zip
unzip bowtie2-2.3.5.1-linux-x86_64.zip
mv bowtie2-2.3.5.1-linux-x86_64 /home/guang/bio_softwares/
## Write the path of bowtie2 into ~/.bashrc file
echo 'export PATH="/home/guang/bio_softwares/bowtie2-2.3.5.1-linux-x86_64:$PATH"' >> ~/.bashrc
echo 'Bowtie2 installation finished'
echo 'Bowtie2 can be called by "bowtie2" from anywhere'
##********************************************************************##

##**** Install macs2 to Python 2.7 environment NGS_Py2.7 using conda ****##
## Check environments existed in conda
## conda env list
# conda environments:
#
## base                  *  /home/guang/anaconda3
## NGS_Py2.7                /home/guang/anaconda3/envs/NGS_Py2.7
conda install --name NGS_Py2.7 MACS2
##***********************************************************************##

##*************** Install HOMER ***************************##
cd /home/guang/bio_softwares/
mkdir ./HOMER_v4.1
cd ./HOMER_v4.1/
wget http://homer.ucsd.edu/homer/configureHomer.pl
perl ./configureHomer.pl -install

echo 'export PATH="/home/guang/bio_softwares/HOMER_v4.1/bin:$PATH"' >> ~/.bashrc
echo 'HOMER2 ver4.1 installation finished'
echo 'findMotifs.pl of HOMER can be called from anywhere'
##*******************************************************##

## ************* Install deeptools using conda *************** ##
## ** Install slamdunk for newly synthesized RNA-seq using conda ** ##
conda install --name NGS_Py2.7 deeptools
conda install --name NGS_Py2.7 slamdunk
## *********************************************************** ##


## ****** Install IGV_ver.2.6.2 from zip file contains binary app ****** ##
cd /home/guang/bio_softwares/
wget https://data.broadinstitute.org/igv/projects/downloads/2.6/IGV_Linux_2.6.2.zip
unzip IGV_Linux_2.6.2.zip 
# This will produce a new folder: IGV_Linux_2.6.2 which contains the app "igv.sh"
# Run IGV by double click igv.sh
echo 'IGV ver2.6.2 installation finished'
echo 'Run "bash igv.sh" in its folder to open IGV program'
## NOTE: if you want to run a .sh script by double click in Ubuntu, 
##       you should set preference of file manager
##       File Manager > Edit > Preferences > Behaviour forExecutable Text Files. 
##       In Ubuntu it is set to View Executable Files when they are opened
##       Set it to "Ask each time" so that you can get 'Run' choice.
## *********************************************************** ##

## ***** Install Sambamba_ver0.7.0 from github release .gz binary ***** ##
cd /home/guang/bio_softwares/
wget https://github.com/biod/sambamba/releases/download/v0.7.0/sambamba-0.7.0-linux-static.gz
gunzip sambamba-0.7.0-linux-static.gz
chmod u+x ./sambamba-0.7.0-linux-static
mkdir -p /home/guang/bio_softwares/sambamba-0.7.0
mv ./sambamba-0.7.0-linux-static /home/guang/bio_softwares/sambamba-0.7.0/sambamba
echo 'export PATH="/home/guang/bio_softwares/sambamba-0.7.0:$PATH"' >> ~/.bashrc
echo 'sambamba ver0.7.0 installation finished'
echo 'sambamba can be called from anywhere'
## ******************************************************************** ##


