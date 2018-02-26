# This script is designed to work with ubuntu 16.04 LTS

# ensure system is updated and has basic build tools
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils
sudo apt-get --assume-yes install software-properties-common

# download and install GPU drivers
wget "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.1.85-1_amd64.deb" -O "cuda-repo-ubuntu1604_9.1.85-1_amd64.deb"

sudo dpkg -i cuda-repo-ubuntu1604_9.1.85-1_amd64.deb
sudo apt-get update
sudo apt-get -y install cuda
sudo modprobe nvidia
nvidia-smi

# install Anaconda for current user
mkdir downloads
cd downloads
wget "https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh" -O "Anaconda3-5.1.0-Linux-x86_64.sh"
bash "Anaconda3-5.1.0-Linux-x86_64.sh"
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
conda install -y bcolz

# install and configure theano
conda install theano
echo "[global]
THEANO_FLAGS=device=cuda
floatX = float32
[cuda]
root = /usr/local/cuda" > ~/.theanorc
#install tensorflow
conda install tensorflow-gpu

# install and configure keras
conda install keras
mkdir ~/.keras
echo '{
    "image_dim_ordering": "tf",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "tensorflow"
}' > ~/.keras/keras.json

# configure jupyter and prompt for password
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py

#Install pytorch with China source.
conda install pytorch torchvision cuda91 -c pytorch --channel https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/

# clone the fast.ai course repo and prompt to start notebook
cd ~
pip install fastai
git clone https://github.com/fastai/fastai.git
echo "Done!Go and enjoy~"
