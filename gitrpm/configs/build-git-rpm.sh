# build and install rpm
giturl="http://kernel.org/pub/software/scm/git/${name}-${version}.tar.gz"

cd ~/src && wget -q ${giturl} \
         && tar xfz ${name}-${version}.tar.gz \
         && mv ${name}-${version}.tar.gz ~/rpmbuild/SOURCES \
         && cd ~/src/${name}-${version} && sed -i s/@@VERSION@@/${version}/g git.spec.in && rpmbuild -ba git.spec.in \
         && mv /root/rpmbuild/RPMS/x86_64/* /output/. \
         && yum remove -y git perl-Git \
         && yum localinstall -y /output/${name}-${version}-*.rpm /output/perl-Git-${version}-*.rpm \

# upload to p2.sbb.ch
for file in `ls /output/*.rpm`; do curl -s --upload-file $file http://p2.sbb.ch/content/sites/site.wzu-rpms/ && rm -f $file; done

