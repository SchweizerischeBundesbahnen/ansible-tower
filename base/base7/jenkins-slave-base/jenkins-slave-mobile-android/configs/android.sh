# modifications for some environments
echo "Set SonarQube instance depending on master ${master}"
case "${master}" in
	"https://ci.sbb.ch")
		cat ${jenkinshome}/.codequality/gradle.prod.properties > ${jenkinshome}/.gradle/gradle.properties
	;;
    "https://ci-i.sbb.ch/")
        cat ${jenkinshome}/.codequality/gradle.int.properties > ${jenkinshome}/.gradle/gradle.properties
	;;
	"http://ci-t.sbb.ch/")
        cat ${jenkinshome}/.codequality/gradle.test.properties > ${jenkinshome}/.gradle/gradle.properties
	;;
	*)
	    exit -1
esac
cat ${jenkinshome}/.codequality/gradle.properties >> ${jenkinshome}/.gradle/gradle.properties
