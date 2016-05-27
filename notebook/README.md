apt-get update
apt-get install python-pip python-dev -y --no-install-recommends
pip install jupyter
git clone https://github.com/pprzetacznik/IElixir.git
cd IElixir
mix deps.get
./install_script.sh

jupyter notebook
