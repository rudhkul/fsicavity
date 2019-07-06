# Tutorial on HOW TO install OpenFOAM, OpenFOAM-Adapter, preCICE, and MBDyn #

## Firstly, install OpenFOAM 5 and Paraview (as the PRECICE adapter currenlty supports this latest version) by using the following commands: ##
```
sudo sh -c "wget -O - http://dl.openfoam.org/gpg.key | apt-key add -"
sudo add-apt-repository http://dl.openfoam.org/ubuntu
sudo apt-get update
sudo apt-get -y install openfoam5
```
After the installation is over, add `. /opt/openfoam5/etc/bashrc' to your ~/.bashrc file.
```
## Once, the OpenFOAM software has been installed and the library has been included, the OpenFOAM-Adapter with FSI capabilities should be built. However, it requires PRECICE (with Python Interface) to be compiled first. Before, doing anything related to this, the dependencies should be met through, ##
```
sudo apt-get install build-essential cmake libeigen3-dev libxml2-dev
sudo apt-get install petsc-dev libboost-all-dev
sudo apt-get install python-dev python-numpy python-pip swig git
```
## Followed by this, download the latest verison of precice library by using (replace x.y.z with version, e.g. 1.5.1), compile it with necessary flags, and build it. Add  `export PRECICE_ROOT = /path/to/precice/folder' to your ~/.bashrc file. ##
```
\begin{verbatim}
wget https://github.com/precice/precice/archive/vx.y.z.tar.gz
tar -xzvf vx.y.z.tar.gz
cd precice-x.y.z
mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=ON \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DMPI=ON \
-DPETSC=ON \
-DPYTHON=ON \
$PRECICE_ROOT
make -j 8 (Note - 8 stands for number of processors for parallel compiling.)
sudo make install
\end{verbatim}
```
## It is necessary that before proceeding forward, the following environment variables be included to your \verb|~/.bashrc| file. ##

\begin{verbatim}
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export CPATH=$CPATH:/usr/local/include/precice
\end{verbatim}

Later, navigate to \verb|precice-1.5.1/src/precice/bindings/python| and here we further need to compile setup.py. The steps are given below.

\begin{verbatim}
pip install --user cython
python setup.py build_ext --mpicompiler=mpicc \
--include-dirs=$PRECICE_ROOT/src --include-dirs=$PRECICE_ROOT/build/last
python setup.py install --user
pip install --user --egg .
\end{verbatim}
```
## The above procedure is performed using python 2.7 and not later versions, as the rest of the procedure requires the same version. Hence, if an error occurs related to version of python, change the same in python setup.py from '>=3' to '>=2'. ##
```
## Check if the precice module can imported by command line python -c "import precice" after the above compilation. ##
```
## Further, it is necessary that the latest version of yaml-cpp for the latest version of boost. However, the default libyaml-cpp-dev is a lower version, hence, it should be compiled from its git repo. ##
```
\begin{verbatim}
git clone --recursive https://github.com/jbeder/yaml-cpp.git
cd yaml-cpp
mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=ON ..
make -j 8
sudo make install
\end{verbatim}
```
## It is important to add the following two lines in ~/.bashrc so that the OpenFOAM-Adapter can be compiled. ##
```
\begin{verbatim}
export  CPLUS_INCLUDE_PATH="/home/anirudh/yaml-cpp/include:${CPLUS_INCLUDE_PATH}"
export  LD_LIBRARY_PATH="/home/anirudh/yaml-cpp/build:${LD_LIBRARY_PATH}"
\end{verbatim}
```
## Once OpenFOAM, OpenFOAM-Adapter and preCICE have been installed with Python support, the only remaining installation is MBDyn, again with Python support. Follow these steps: ##
```
\begin{verbatim}
wget https://www.mbdyn.org/userfiles/downloads/mbdyn-1.7.3.tar.gz
tar -xf mbdyn-1.7.3.tar.gz
cd mbdyn-1.7.3
CPPFLAGS=-I/usr/include/suitesparse ./configure --enable-python=yes
make 
sudo make install
\end{verbatim}
```
## To put this into use, add the following these linesS in ~/.bashrc file, ##
```
\begin{verbatim}
export  PATH=$PATH:/usr/local/mbdyn/bin
export  PYTHONPATH=$PYTHONPATH:/usr/local/mbdyn/libexec/mbpy
\end{verbatim}
```
## Furthermore, MBDyn Adapter should be downloaded for preCICE module so that OpenFOAM can be linked with it. This can be obtained from https://github.com/precice/mbdyn-adapter. There is a `setup.py' file in this adapter, which should be compiled by `sudo python setup.py install', by which the files are copied to the shared library..\\

![](cell.gif)

![](pres.gif)

![](vel.gif)
