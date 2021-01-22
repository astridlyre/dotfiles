git clone https://gitlab.com/ebflat9/dotfiles.git
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo install fish
sudo apt install fish
sudo apt install exa
sudo apt install fd-find
sudo apt install fzf
sudo apt install ranger
sudo reboot now
sudo apt update && sudo apt upgrade
sudo apt get update
sudo apt update
sudo apt upgrade
which kitty
sudo ln -s ~/.local/kitty.app/bin/kitty ~/usr/bin/kitty
sudo ln -s ~/.local/kitty.app/bin/kitty /usr/bin/kitty
kitty
bat
which bat
cd dotfiles/
ls
cd scripts/
ls
./update-kitty
sudo apt install gnome-tweaks-tools
sudo apt install gnome-tweak-tools
sudo apt install gnome-tweaks-tool
sudo apt install gnome-tweak-tool
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fish
exit
chsh -s /usr/bin/fish
sudo update-alternatives --config x-terminal-emulator 
sudo apt install kitty-terminfo
sudo update-alternatives --config x-terminal-emulator 
which kitty
sudo update-alternatives --config x-terminal-emulator 
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
sudo update-alternatives --config x-terminal-emulator 
sudo apt install python3
sudo apt install python-pip
sudo apt install python3-pip
curl -fsSL https://fnm.vercel.app/install | bash
echo "export PATH=/home/ml/.fnm:$PATH" >> .bashrc
echo 'eval "`fnm env`"' >> .bashrc 
source .bashrc 
fnm
fnm list-remote
fnm install v15.5.1
fish
exit
ls
cd
cd .config/fish
vi config.fish 
exit
cd ..
cd fish
ls
cd functions/
ls
fisher list
fish
x
exit
Length=7
Variable="Some string"
echo $Variable
echo ${Variable/Some/My}
echo ${Variable:0:Length}
echo ${Variable: -3}
echo ${#Variable}
echo ${Foo:-"Empty"}
array0=(one two three four five six)
echo $array0
echo $array0[0]
echo ${array0[0]}
echo ${array0[1]}
echo ${array0[3]}
echo ${array0[@]}
for i in "${array0[@]}"; do echo "$i"; done
x
exit
help cd
clear
exit
ldd "$(which rg)"
exit
ldd "$(which rg)"
exit
hello

for i in "${array0[@]}"; do echo "$i"; done
array0="one two three four"
for i in "${array0[@]}"; do echo "$i"; done
exit
HERE=$(pwd)
echo $HERE
HERE=$(pwd | cut -f 2 -d "/")
echo $HERE
exit
echo $0
exit
echo $-
for w in "one two three"; do echo $w; done
for w in "one two three"@; do echo $w; done
arr="one two three"
for w in $arr@; do echo $w; done
for w in $arr; do echo $w; done
for w in "one" "two" "three"; do echo $w; done
clear
exit
echo $((2 + 2))
clear
exit
bc << EOF
2 + 2
EOF

echo $(($((5**2)) * 3))
echo Front-{A,B,C}-Back
echo Number_{1..10}
echo {1..100}
echo {a-z}
echo {a..z}
echo {a..z} | cat -s
man tr
echo {a..z} | tr -d [:space:]
echo {a..z} | tr -d [:space:] | cat
echo {a..z} | tr -d [:space:] | echo
echo {a..z} | tr -d [:space:] | cat - \n
echo {a..z} | tr -d [:space:] \n
vi
vim
vi
TERM=xterm-kitty
ls
env
exit
echo {Z..A}
echo {01..25}
echo Kitten-{001..999}
clear
echo {0000..9999} \n
man echo
clear
echo {2005..2020}-{01..12}
clear
echo $USER
printenv | less
clear
echo $(ls)
ls -l $(which cp)
ls -l $(which vim)
exit
file $(ls -d /usr/bin/* | grep zip)
vim /usr/bin/gunzip 
gzip --help
exit
\a
echo \a
echo \b
echo \t
echo "\a"
exit
history | rg zip
sudo reboot now
echo sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
exit
cd dotfiles/ && echo "hi"
exit
tload
clear
exit
if [ -f ~/.bashrc ]; then echo "found bashrc"; fi
exit
$-
echo $-
x
exit
ls
exit
hello
testing
exit
ls
exit
.
. .bashrc
exit
cd .config/nvim/
exit
cd .config/nvim/
ls
exit
ls
c
x
cd .config
cd .config/nvim/
cd nvim
cd plugged/
ls
..
c
vi
c
cd
c
exit
c
echo $PATH
node --version
go version
exit
go version
echo $PATH
exit
echo $PATH
PATH=$PATH:/usr/local/go/bin
go version
exit
go version
echo $PATH
exit
go version
vi
c
ls
c
btc
exit
ls
c
btc
c
ls
x
sudo apt install bash-completion
fd / bash_completion
fd --help
fd bash_completion /
. /etc/profile.d/bash_completion.sh 
exit
c
printenv
x
c
x
ls
c
exit
ls
c
x
ls
c
now
c
market
c
echo $VISUAL
market
c
chsh -s bash
chsh -s /bin/bash
x
echo $SHELL
x
ls
echo $PATH | less
printenv | less
set | less
if
vi .bashrc
source .bashrc
if
c
vi .bashrc
c
vi .bashrc
exit
ls
c
vi
c
neovim --help
nvim --help
mkdir .config/nvim_tiny/
cp .config/nvim/init.vim .config/nvim_tiny/init.vim
vi .config/nvim_tiny/init.vim 
vi .bashrc
vi .bash_aliases 
exit
c
vim
x
vi
vim
vi
vim
rm -rf .config/nvim_tiny/
vim .bash_aliases 
x
c
ls
c
x
c
echo $HELLO
c
x
hello
x
vi
c
vi --no-config
nvim -h
nvim --noconfig
vi
vi -u NONE
vi
c
ls
r
vi
c
vi .bashrc
x
ls
x
ls
x
c
x
echo $0
c
vi .bashrc
x
echo {1..30}
c
x
cd notes
ls
cd LPI
cd TLCL/
ls
touch part3.md
vi part3.md 
..
ls
git add .
n=$(now)
git commit -am "started TLCL notes $n"
git push
x
c
netstat -ie
dig 198.51.100.165
netstat -r
htop
find . | wc -l
ls
find ls -a
ls -a
find * | wc -l
c
find / -nouser 2> /dev/null
find / -nogroup 2> /dev/null
c
x
ping 1.1.1.1
x
c
mkdir -p playground/dir-{001..100}
touch playground/dir-{001..100}/file-{A..Z}
ls
exa -T playground/
c
find playground/ -type f -name "file-A"
find playground/ -type f -name "file-A" | wc -l
touch playground/timestamp
stat playground/timestamp 
touch playground/timestamp 
stat playground/timestamp 
c
find playground/ -type -f -name 'file-B' -exec touch '{}' ';'
find playground/ -type f -name 'file-B' -exec touch '{}' ';'
find playground/ -type f -newer playground/timestamp 
find playground/ -type f -newer playground/timestamp | wc -l
c
find playground/ \( -type f -not -perm 0600 \) -or \( -type d -not -perm 0700 \)
c
find playground/ \( -type f -not -perm 0600 -exec chmod 0600 '{}' ';' \) -or \( -type d -not -perm 0700 -exec chmod 0700 '{}' ';' \)
ls playground/dir-001
rm -rf playground/
ls
c
ls
mkdir -playground/dir-{001..100}
mkdir -p playground/dir-{001..100}
touch playground/dir-{001..100}/file-{A..Z}
tar -cf playground.tar playground/
ls
tar tf playground.tar
tar tf playground.tar | wc -l
c
tar tvf playground.tar
c
mkdir foo
cd foo
tar xf ../playground.tar
ls
cd playground/
ls
c
..
rm -rf foo/
file playground.tar
ls
ll
rm playground.tar
rm -rf playground/
ls
c
update-me
sudo apt autoremove
c
mkdir -p playground/dir-{001..100}
touch playground/dir-{001..100}/file-{A..Z}
rsync playground/ foo
ls
mkdir foo
rsync playground/ foo
ls
cd foo
ls
..
rsync -av playground foo
c
ls
cd foo
ls
cd playground/
ls
..
rsync -av playground foo
touch playground/dir-099/file-Z
rsync -av playground foo
x
c
fd -H coc-*
cd .config/
c
exit
git clone https://github.com/savq/paq-nvim.git     "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
ls
exit
git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
rm -rf .local/share/nvim/site/pack/packer/
git clone https://github.com/savq/paq-nvim.git     "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
cd .local/share/nvim/site
ls
cd pack
ls
cd paqs/
ls
cd opt
ls
..
cd
c
exit
git clone https://github.com/savq/paq-nvim.git     "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
exit
c
mkdir playground
cd playground/
ls /bin > dirlist-bin.txt
ls /usr/bin > dirlist-usr-bin.txt
ls /sbin > dirlist-sbin.txt
ls /usr/sbin > dirlist-usr-sbin.txt
ls dirlist*.txt
ls
c
grep bzip dirlist*.txt
rg bzip dirlist*.txt
rg -l bzip dirlist*.txt
c
rg -L bzip dirlist*.txt
c
grep -L bzip dirlist*.txt
rg -L bzip dirlist*.txt
rg ! bzip dirlist*.txt
man rg | less
rg --files-without-matches bzip dirlist*.txt
rg --files-without-match bzip dirlist*.txt
c
rg 'a$' dirlist*.txt
c
rg -i '^..j.r$' /usr/share/dict/words
rg -i '^kit*n$' /usr/share/dict/words
rg -i '^kit..n$' /usr/share/dict/words
rg -i '^k[a-z]*n$' /usr/share/dict/words
c
rg -h '[bg]zip' dirlist*.txt
rg '[bg]zip' dirlist*.txt
c
cat -A "HelloThis is next"
cat > foo.txt
cat -A foo.txt 
c
rm foo.txt 
ls
..
ls
rm -rf playground/
ls
c
cat > foo.txt
rm foo.txt 
c
du -s / | sort -nr | head
du -s / 2> /dev/null | sort -nr | head
du -s /* 2> /dev/null | sort -nr | head
c
ls -l /usr/bin | sort -nrk 5 | head
ll -l /usr/bin | sort -nrk 5 | head
ll -l /usr/bin | sort -nrk 2 | head
ll -l /usr/bin | sort -nrk 3 | head
ll -l /usr/bin | sort -nrk 1 | head
ll /usr/bin | sort -nrk 2 | head
ll /usr/bin | sort -nrk 4| head
ll /usr/bin | sort -nrk 4 | head
c
ls
cat > file1.txt
cat > file2.txt
diff file1.txt file2.txt 
diff -c file1.txt file2.txt 
echo "e" >> file2.txt
diff -c file1.txt file2.txt 
diff -u file1.txt file2.txt 
diff -Naur file1.txt file2.txt > diff.txt
cat diff.txt 
patch < diff.txt 
cat file1.txt 
cat file2.txt 
ls
rm diff.txt file1.txt file2.txt 
ls
c
echo "lowercase letters" | tr a-z A-
echo "lowercase letters" | tr a-z A-Z
echo "lowercase letters" | tr a-z ABCDEFG-
c
echo mySecretPassword | tr [:alpha:] *
echo mySecretPassword | tr [:alpha:] \*
echo "aaabbbccc" | tr -s ab
cd
cd profllllj
cd Documents/Coding\ Stuff/
zothura TLCL-19.01.pdf &
c
jobs
c
zathura TLCL-19.01.pdf &
disown
cd
cd notes/LPI/TLCL/
c
cat > foo.txt
aspell check foo.txt 
cat foo.txt
c
ls
rm foo.txt.bak 
cat foo.txt 
nl foo.txt 
c
x
echo {1..50}
seq 1 50
x
cd
cd Documents/Coding\ Stuff/
zathura TLCL-19.01.pdf &
disown
cd
cd notes/LPI/TLCL/
c
which gcc
diction
x
c
x
ls
vi .fzf.bash
vi .
vi
cd .fzf
ls
./install
x
vi
x
vi
x
ls
cp .bash* dotfiles/
cd dotfiles/
ls
..
ls
cat projects/
cat .profile 
c
r
x
c
x
htop
killall brave
x
c
vi
c
echo $SHELL
echo $0
c
x
htop
c
sudo shutdown
sudo shutdown now
c
exit
ls
x
ls
eit
exit
exit
ls
cd projects/
ls
cd js
ls
cd ecommerce-app/
ls
npm start
c
npm install
npm start
ls
cd projects/js/ecommerce-app/
npm statr
npm start
exit
ls
x
npm start
ls
x
echo $(pwd)
echo `pwd`
echo $(fd "Iosevka")
fd "Iosevka" | xargs rm -rf
ls
c
fd "Iosevka"
cd /
fd "Iosevka" 2> /dev/null
cd
c
cd Downloads/
ls
rm iosevka-dynamo*
ls
rm arco*
ls
rm debian-10.7.0-amd64-netinst.iso 
rm endeavouros-2020.09.20-x86_64.iso 
rm CentOS-8.3.2011-x86_64-boot.iso 
rm archcraft-2020.12.31-x86_64.iso 
ls
c
cd
ls
c
market
c
ls scripts/
ls scip
x
ls scripts/
x
ls scripts
c
ls
time ls
x
ls
c
x
time exa -T
x
ls
c
x
c
clear
vi
ls
x
ls
c
cd notes/
ls
cd LPI/
cd TLCL/
ls
vi part3-2.md 
x
c
vi .bashrc
x
cat << "hello"
cut -f 1 "hello world"
man cut
x
cd notes/LPI/TLCL/
touch test.txt
lc
ls
ll
rm test.txt 
c
echo $PATH
mkdir report-generator
touch report-generator/template.html
cd report-generator/
chx sys_info_page 
ll
./sys_info_page 
sudo apt install ctags
sudo apt install exuberant-ctags
./sys_info_page 
echo $HOSTNAME
echo $USER
now
ls blk
lsblk
sysinfo
uptime
uname -a
neofetch
lsblk
ps 
ps -aux | head
ps -aux | sort -k 4 | head
ps -aux | sort -k 6 | head
ps -aux | sort --key=4 | head
ps -aux | sort -k 3
c
ps -aux
c
ps -u
c
iwconfig
c
syslog | tail
dmesg | tail
sudo dmesg | tail
lscpu
lscpu | head
c
./sys_info_page 
c
c
cd notes/LPI/TLCL/
vi .
ls
vi .
c
x
c
x
c
ls
x
c
