The IBM JRE is not supposed to be used for standalone Java programs and it
contains configuration for SSL provider which is included in the WAS
libraries. If you are using it with without WebSphere you need to override
ssl.SocketFactory.provider and ssl.ServerSocketFactory.provider from java.security

# Default JSSE socket factories
ssl.SocketFactory.provider=com.ibm.jsse2.SSLSocketFactoryImpl
ssl.ServerSocketFactory.provider=com.ibm.jsse2.SSLServerSocketFactoryImpl
# WebSphere socket factories (in cryptosf.jar)
#ssl.SocketFactory.provider=com.ibm.websphere.ssl.protocol.SSLSocketFactory
#ssl.ServerSocketFactory.provider=com.ibm.websphere.ssl.protocol.SSLServerSocketFactory
