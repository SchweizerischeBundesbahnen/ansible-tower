import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*


def busyExecutors = Jenkins.instance.computers
                                .collect { 
                                  c -> c.executors.findAll { it.isBusy() }
                                }
                                .flatten() // reminder: transforms list(list(executor)) into list(executor)

busyExecutors.each { e -> 
  println e.getCurrentExecutable();  ; 

  println "" 
}

println "Done"
