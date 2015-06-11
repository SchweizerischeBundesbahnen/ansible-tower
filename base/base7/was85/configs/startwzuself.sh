mkdir -p /opt/source/delivery/server1/0.1.13
cd  /opt/source/delivery/server1/0.1.13 && wget http://repo.sbb.ch/service/local/repositories/hosted.wzuself.releases/content/ch/sbb/wzuself/wzuself-ear/0.1.13/wzuself-ear-0.1.13.ear && wget http://repo.sbb.ch/service/local/repositories/hosted.wzuself.releases/content/ch/sbb/wzuself/wzuself-ear/0.1.13/wzuself-ear-0.1.13.zip && cd /opt/source/delivery/server1/0.1.13/ && unzip wzuself-ear-0.1.13.zip
mv /opt/source/delivery/server1/0.1.13/scripts/wzuself_cl_cluster.xml /opt/source/delivery/server1/0.1.13/scripts/server1_cluster.xml
mv /opt/source/delivery/server1/0.1.13/scripts/wzuself_cl_datasource.xml  /opt/source/delivery/server1/0.1.13/scripts/server1_datasource.xml
mv /opt/source/delivery/server1/0.1.13/scripts/wzuself_cl_installadapter.xml  /opt/source/delivery/server1/0.1.13/scripts/server1_installadapter.xml
mv /opt/source/delivery/server1/0.1.13/scripts/wzuself_cl_install.xml  /opt/source/delivery/server1/0.1.13/scripts/server1_install.xml
mv /opt/source/delivery/server1/0.1.13/scripts/wzuself_cl_resource.xml /opt/source/delivery/server1/0.1.13/scripts/server1_resource.xml
curl https://code.sbb.ch/projects/KD_WZU/repos/wzuself/browse/wzuself-ear/wasinstall/server1_postdev_general.xml?raw -o /opt/source/delivery/server1/0.1.13/scripts/server1_postdev_general.xml

curl http://repo.sbb.ch/service/local/repositories/hosted.mwe-wzu.releases/content/ch/sbb/eaio/jca_adapter/1.15.0/jca_adapter-1.15.0.zip -o /opt/source/delivery/server1/0.1.13/jca_adapter.zip && cd /opt/source/delivery/server1/0.1.13/ && unzip jca_adapter.zip
curl https://code.sbb.ch/projects/AM/repos/mpm/browse/mpm-ear/wasresources/server1_installrar.xml?raw -o /opt/source/delivery/server1/0.1.13/scripts/server1_installrar.xml

sed -i 's#value_u="D:\\devsbb\\websphere\\jca_adapter\\Adapter-Metadir\\5.0.0\\metadir-was85-5.0.0.rar"#value_u="/opt/source/delivery/server1/0.11.1/jca_adapter/Adapter-Metadir/5.0.0/metadir-was85-5.0.0.rar"#' /opt/source/delivery/server1/0.1.13/scripts/server1_installrar.xml

cd /opt/me/bin; ./builder.sh /opt/source/delivery/server1/0.1.13/scripts/ cluster
cd /opt/me/bin; ./builder.sh /opt/source/delivery/server1/0.1.13/scripts/ datasource
cd /opt/me/bin; ./builder.sh /opt/source/delivery/server1/0.1.13/scripts/ installrar
cd /opt/me/bin; ./builder.sh /opt/source/delivery/server1/0.1.13/scripts/ installadapter
cd /opt/me/bin; ./builder.sh /opt/source/delivery/server1/0.1.13/scripts/ resource
cd /opt/me/bin; ./builder.sh /opt/source/delivery/server1/0.1.13/scripts/ install_and_run novalidate
/opt/was85/bin/stopServer.sh  server1 && /opt/was85/bin/startServer.sh server1