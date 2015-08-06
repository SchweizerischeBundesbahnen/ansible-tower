import hudson.FilePath
import hudson.model.Node
import hudson.model.Slave
import jenkins.model.Jenkins

Jenkins jenkins = Jenkins.instance
def jenkinsNodes =jenkins.nodes

for (Node node in jenkinsNodes) 
{
  // Make sure slave is online
  if (!node.getComputer().isOffline()) 
  {           
    //Make sure that the slave busy executor number is 0.
    if(node.getComputer().countBusy()==0)
    {
       println "$node.nodeName"
    }
  }  
}
