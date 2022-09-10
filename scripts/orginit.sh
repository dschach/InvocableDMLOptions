#!/bin/bash

echo "Set Dev Hub"
npm run setDevHub

echo "Cleaning previous scratch org..."
sfdx force:org:delete -p -u DMLOptionsOrg

echo "Creating new scratch org"
sfdx force:org:create -f config/project-scratch-def.json --durationdays 21 -a DMLOptionsOrg -s

echo "Pushing metadata"
sfdx force:source:push

#echo "Assigning Permissions"
#sfdx force:user:permset:assign -n PermSetName

echo "Adding sample data"
sfdx force:data:tree:import -p ./data/data-plan.json

echo "Opening org"
sfdx force:org:open

echo "Org is set up"