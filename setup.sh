#!/bin/sh

set -e

echo "==> Install TeXLive"
mkdir -p /tmp/install-tl
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
  -O /tmp/install-tl/install-tl-unx.tar.gz
mkdir -p /tmp/install-tl/installer
tar --strip-components 1 -zvxf /tmp/install-tl/install-tl-unx.tar.gz \
  -C /tmp/install-tl/installer
/tmp/install-tl/installer/install-tl --profile=/root/texlive.profile

echo "==> Install Packages"
tlmgr update --self
tlmgr install \
  latexmk \
  texliveonfly

# install biber/biblatex from source
# issue: https://github.com/plk/biber/issues/255
mkdir -p /tmp/install-biber
wget https://downloads.sourceforge.net/project/biblatex-biber/biblatex-biber/development/binaries/Linux-musl/biber-linux_x86_64-musl.tar.gz \
  -O /tmp/install-biber/biber-linux_x86_64-musl.tar.gz
tar -zvxf /tmp/install-biber/biber-linux_x86_64-musl.tar.gz -C /tmp/install-biber
mv /tmp/install-biber/biber-linux_x86_64-musl /opt/texlive/texdir/bin/x86_64-linuxmusl/biber
wget https://downloads.sourceforge.net/project/biblatex/development/biblatex-3.13.tgz \
  -O /tmp/install-biber/biblatex-3.13.tgz
tar -zvxf /tmp/install-biber/biblatex-3.13.tgz -C /tmp/install-biber
mv /tmp/install-biber/biblatex/latex /opt/texlive/texmf-local/tex/latex/biblatex
mv /tmp/install-biber/biblatex/bibtex/bst /opt/texlive/texmf-local/bibtex/bst/biblatex
mv /tmp/install-biber/biblatex/bibtex/bib /opt/texlive/texmf-local/bibtex/bib/biblatex
texhash

echo "==> Clean up"
rm -rf \
  /opt/texlive/texdir/install-tl \
  /opt/texlive/texdir/install-tl.log \
  /opt/texlive/texdir/texmf-dist/doc \
  /opt/texlive/texdir/texmf-dist/source \
  /opt/texlive/texdir/texmf-var/web2c/tlmgr.log \
  /root/setup.sh \
  /root/texlive.profile \
  /tmp/install-biber \
  /tmp/install-tl
