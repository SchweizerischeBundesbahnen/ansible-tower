import hudson.model.*
import hudson.node_monitors.*
import hudson.slaves.*
import java.util.concurrent.*
import javax.activation.*

jenkins = Hudson.instance


minimumRequiredSlavesPerLabel = ['android': 0, 'jee': 0, 'yves-migration': 0, 'iib9': 0, 'nodejs': 0, 'wmb': 0 ]

def getEnviron(computer) {
    def env
    def thread = Thread.start("Getting env from ${computer.name}", { env = computer.environment })
    thread.join(2000)
    if (thread.isAlive()) thread.interrupt()
    env
}

def slaveAccessible(computer) {
    getEnviron(computer)?.get('PATH') != null
}


def labelMap = [:]

def putLabelsInMap(slave, labelMap) {
    def labels = slave.getLabelString().split()
    def computer = slave.computer
    for (label in labels) {
        if (!(labelMap.containsKey(label))) {
            labelMap.put(label, [])
        }
        labelMap.get(label).add(computer.name)
    }
}

for (slave in jenkins.slaves) {
    def computer = slave.computer
    putLabelsInMap(slave, labelMap)
}


for (label in minimumRequiredSlavesPerLabel.keySet()) {
    def has = labelMap[label] ? labelMap[label].size() : 0
    println(label+"="+has);
}

