"""Construct a profile with two hosts for testing owamp

Instructions:
  Wait for the profile to start. . .
"""

# Boiler plate
import geni.portal as portal
import geni.rspec.pg as rspec
request = portal.context.makeRequestRSpec()

# Get nodes
host = request.RawPC("host")
target = request.RawPC("target")

# Force hardware type for consistency
host.hardware_type = "m510"
target.hardware_type = "m510"

link1 = request.Link(members = [host, target])

# Set scripts from repo
# node1.addService(rspec.Execute(shell="sh", command="/local/repository/initDocker.sh"))

# Boiler plate
portal.context.printRequestRSpec()
